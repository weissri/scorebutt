module FieldGen (fieldGen) where

import Dict as D
import Graphics.Input as I

-- Create an infinite list of fields.

type FieldGen = 
  { events : Signal (Int,I.FieldState)
  , field : 
    (I.FieldState -> (Int,I.FieldState)) -> String -> I.FieldState -> Element
  }

fieldGen : String -> Signal (Element,[String])
fieldGen txt = 
  let fg = I.fields (-1,I.emptyFieldState) in
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
  (0, []) fg.events

insert n v xs = case xs of
  (n',v')::xs -> if n' == n then (n,v)::xs else (n',v')::insert n v xs
  _           -> [(n,v)]

remove n xs = case xs of
  (n',v)::xs -> if n' == n then xs else (n',v)::remove n xs
  _          -> []