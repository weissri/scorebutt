module Scenarios (scenario1,scenario2,scenario3) where

{-
Contains the description of each scenario and its options.
-}

import Graphics.Input as I

labeledCheckbox : String -> (Signal Element,Signal Bool)
labeledCheckbox lbl = let (elm,sig) = I.checkbox False in
  ((\elm -> elm `beside` spacer 10 1 `beside` plainText lbl) <~ elm, sig)

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

s1Desc = 
  [markdown|
    Scenario 1 Title
    ==============

    Lengthy description of scenario.
  |]

s2Desc = 
  [markdown|
    Scenario 2 Title
    ==============

    Lengthy description of scenario.
  |]

s3Desc = 
  [markdown|
    Scenario 3 Title
    ==============

    Lengthy description of scenario.
  |]

(s1SelectE,  s1SelectS)  = labeledCheckbox "Play Scenario #1"
(s1Option1E, s1Option1S) = labeledCheckbox "Option #1 for scenario #1"
(s1Option2E, s1Option2S) = labeledCheckbox "Option #2 for scenario #1"
(s1Option3E, s1Option3S) = labeledCheckbox "Option #3 for scenario #1"

(s2SelectE,  s2SelectS)  = labeledCheckbox "Play Scenario #2"
(s2Option1E, s2Option1S) = labeledCheckbox "Option #1 for scenario #2"
(s2Option2E, s2Option2S) = labeledCheckbox "Option #2 for scenario #2"
(s2Option3E, s2Option3S) = labeledCheckbox "Option #3 for scenario #2"

(s3SelectE,  s3SelectS)  = labeledCheckbox "Play Scenario #3"
(s3Option1E, s3Option1S) = labeledCheckbox "Option #1 for scenario #3"
(s3Option2E, s3Option2S) = labeledCheckbox "Option #2 for scenario #3"
(s3Option3E, s3Option3S) = labeledCheckbox "Option #3 for scenario #3"

-- A scenario to be played
scenario1 = scenario <~ 
  constant s1Desc ~
  s1SelectE ~
  s1SelectS ~
  combine [s1Option1E,s1Option2E,s1Option3E]

-- A scenario to be played
scenario2 = scenario <~ 
  constant s2Desc ~
  s2SelectE ~
  s2SelectS ~
  combine [s2Option1E,s2Option2E,s2Option3E]

-- A scenario to be played
scenario3 = scenario <~ 
  constant s3Desc ~
  s3SelectE ~
  s3SelectS ~
  combine [s3Option1E,s3Option2E,s3Option3E]