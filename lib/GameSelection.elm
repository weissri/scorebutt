module GameSelection where

import Graphics.Input as I
import Signal as S

welcome = 
  [markdown|
    Welcome to Edurange
    ===================

    What scenarios would you like to play today?
  |]

(numPlayersE,numPlayersS) = 
  let (elm,sig) = I.dropDown <| map (\x -> (show x,x)) [1..99] in 
  ((\elm -> elm `beside` plainText "  Number of Players") <~ elm, sig)

s1Desc = 
  [markdown|
    Scenario Title
    ==============

    Lengthy description of scenario.
  |]

(s1SelectE,  s1SelectS)  = labeledCheckbox "Play Scenario #1"
(s1ScoredE,  s1ScoredS)  = labeledCheckbox "Keep track of scores for scenario #1"
(s1Option1E, s1Option1S) = labeledCheckbox "Option #1 for scenario #1"
(s1Option2E, s1Option2S) = labeledCheckbox "Option #2 for scenario #1"
(s1Option3E, s1Option3S) = labeledCheckbox "Option #3 for scenario #1"

scenario1 = scenario <~ 
  constant s1Desc ~
  s1SelectE ~
  s1SelectS ~
  S.combine [s1ScoredE,s1Option1E,s1Option2E,s1Option3E]

main = ui <~ 
  numPlayersS ~
  numPlayersE ~
  S.combine [scenario1]

-- Setup the UI of the entire page
ui numPlayersS numPlayersE scenarios = 
  spacer 20 1 `beside` flow down
    [ welcome
    , numPlayersE
    , flow down scenarios
    ]

-- Create a scenario block
scenario : Element -> Element -> Bool -> [Element] -> Element
scenario description selectBox selectSig options = 
  flow down 
    [ description
    , selectBox
    , case selectSig of
        False -> spacer 0 0
        True  -> spacer 20 1 `beside` flow down options
    ]

labeledCheckbox lbl = let (elm,sig) = I.checkbox False in
  ((\elm -> elm `beside` spacer 10 1 `beside` plainText lbl) <~ elm, sig)