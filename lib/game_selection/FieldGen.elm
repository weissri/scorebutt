module FieldGen (fieldGen,chatbox) where

import Dict as D
import Graphics.Input as I
import Keyboard as K

-- Create an infinite list of fields.

type FieldGen = 
  { events : Signal (Int,I.FieldState)
  , field : 
    (I.FieldState -> (Int,I.FieldState)) -> String -> I.FieldState -> Element
  }

-- Creates a signal containing a vertical list of fields, and the strings contained in the fields.
fieldGen : String -> Signal (Element,[String])
fieldGen txt = let fg = I.fields (-1,I.emptyFieldState) in
  lift (\(n,xs) ->
    (flow down <| fg.field ((,) -1) txt I.emptyFieldState :: 
      map (\(i,st) -> fg.field ((,) i) txt st) xs, map (.string . snd) xs)) <| 
  foldp 
    -- Take an (Int,FieldState) & (Int,[FieldState])
    (\(i,st) (n,xs) -> 
      -- Check if updated field is the default
      if i == -1 
      then if st.string == ""
           then (n,xs) 
           else (n+1, insert n st xs) 
      else if st.string == ""
           -- Remove empty field
           then (n, remove i xs)
           -- Update field
           else (n, insert i st xs)) 
    (0, []) 
    fg.events

insert : Int -> a -> [(Int,a)] -> [(Int,a)]
insert n v xs = case xs of
  (n',v')::xs -> if n' == n then (n,v)::xs else (n',v')::insert n v xs
  _           -> [(n,v)]

remove : Int -> [(Int,a)] -> [(Int,a)]
remove n xs = case xs of
  (n',v)::xs -> if n' == n then xs else (n',v)::remove n xs
  _          -> []

chatbox : (Signal Element, Signal String)
chatbox = 
  let cbGen = I.fields I.emptyFieldState
      fieldState = foldp 
        (\(pressed,st') _ -> 
          if pressed && st'.string /= "" 
          then (cbGen.field id "Say something" I.emptyFieldState, st'.string)
          else (cbGen.field id "Say something" st'              , "")
        )
        (cbGen.field id "Say something" I.emptyFieldState, "")
        ((,) <~ K.enter ~ cbGen.events) 
  in
    ( fst <~ fieldState
    , snd <~ fieldState
    )