module GameSelection where

import Graphics.Input as Input
import Scenarios (scenario1,scenario2,scenario3)
import FieldGen (fieldGen,chatbox)
import Mouse
import Graph
import Window

type Score = Float
type Team = {name : String, teamColor : Color, scores : [(Time,Score)], players : [String]}
type Game = {teams : [Team]}

-- Scores generated from mouse x position
team1Scores : Signal (Color,[(Time,Float)])
team1Scores = (,) <~ constant (rgb 255 100 0) ~ foldp (\(t,x) xs -> take 5000 <| (t,toFloat x) :: xs) []
  (timestamp <| sampleOn (fps 10) Mouse.x)

-- Scores generated from mouse y position
team2Scores : Signal (Color,[(Time,Float)])
team2Scores = (,) <~ constant blue ~ foldp (\(t,x) xs -> take 5000 <| (t,toFloat x) :: xs) []
  (timestamp <| sampleOn (fps 10) Mouse.y)

-- Scores generated from sin wave
team3Scores : Signal (Color,[(Time,Float)])
team3Scores = (,) <~ constant green ~ foldp (\t xs -> take 5000 <| (t, snd (head xs) + sin t * 6 + 0.1) :: xs) [(0,50)] (every <| second / 10)

-- Scores generated from cos wave
team4Scores : Signal (Color,[(Time,Float)])
team4Scores = (,) <~ constant purple ~ foldp (\t xs -> take 5000 <| (t, snd (head xs) + cos t * 6 + 0.1) :: xs) [(0,50)] (every <| second / 10)

scoreGraph = (\xs wx wy -> Graph.timeline wx (wy `div` 2) (toFloat wx/(minute * 5)) (1/2) xs) <~ 
  combine [team1Scores, team2Scores, team3Scores, team4Scores] ~ Window.width ~ Window.height

welcome = 
  [markdown|
    Welcome to Edurange
    ===================

    Select the scenarios you want to play. 
    Each scenario you select will increase 
    the number of VM's that EDURange starts.
  |]

-- (Element, Signal Bool)
(startGame, gameStarted) =
  let (btn,start) = Input.button "Start Game" in
  (btn, foldp (\_ go -> not go) False start)

(team1NameE,team1NameS) = Input.field "Team 1 Name"
(team2NameE,team2NameS) = Input.field "Team 2 Name"

team1Players : Signal (Element,[String])
team1Players = fieldGen "Team 1 Player Name"

team2Players : Signal (Element,[String])
team2Players = fieldGen "Team 2 Player Name"

(msgBox,message) = chatbox

messages = foldp (::) [] message

-- Setup the UI of the entire page
draw : Bool -- Game Started
    -> Element -- Start Game Button
    -> [Element] -- Scenarios
    -> (Element,[String]) -- (Team 1 Fields, Team 1 Names)
    -> (Element,[String]) -- (Team 2 Fields, Team 2 Names)
    -> Element -- Score Graph
    -> Element -- Scenario Preview
    -> Element -- Chatbox
    -> [String] -- Messages
    -> Element
draw gameStarted startGame scenarios team1 team2 scoreGraph scenarioPreview chatbox messages = 
  if   gameStarted
  then flow down 
      [ scoreGraph
      , spacer 20 1 `beside` chatbox
      , spacer 20 1 `beside` flow down (map plainText messages)
      ]
  else 
    spacer 20 1 `beside` 
    (width 400 <| flow down
      [ welcome
      , flow down scenarios
      , spacer 1 40
      -- , plainText "Enter Team 1 Player Names"
      , fst team1
      , spacer 1 40
      -- , plainText "Enter Team 2 Player Names"
      , fst team2
      , spacer 1 40
      , startGame
      ]) `beside`
    spacer 40 1 `beside` 
    scenarioPreview

main = draw <~ 
  gameStarted ~
  constant startGame ~
  combine [scenario1,scenario2,scenario3] ~
  team1Players ~
  team2Players ~
  scoreGraph ~
  (constant (flow down <| map (\_ -> plainText "Scenario Preview Goes Over Here") [1..40])) ~
  msgBox ~
  messages