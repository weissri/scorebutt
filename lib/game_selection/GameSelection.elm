module GameSelection where

import Graphics.Input as Input
import Scenarios (scenario1,scenario2,scenario3)
import ScoreGraph (scoreGraph)
import FieldGen (fieldGen)

type Score = Float
type Team = {name : String, teamColor : Color, scores : [(Time,Score)], players : [String]}
type Game = {teams : [Team]}

welcome = 
  [markdown|
    Welcome to Edurange
    ===================

    Select the scenarios you want to play.
  |]

(startGame, gameStarted) =
  let (btn,start) = Input.button "Start Game" in
  (btn, foldp (\_ go -> not go) False start)

-- Setup the UI of the entire page
draw : Element -- Start Game Button
    -> [Element] -- Scenarios
    -> Element   -- Score Graph
    -> (Element,[String]) -- (Team 1 Fields, Team 1 Names)
    -> (Element,[String]) -- (Team 2 Fields, Team 2 Names)
    -> Bool -- Game Started
    ->  Element
draw startGame scenarios scoreGraph team1 team2 gameStarted = 
  if   gameStarted
  then scoreGraph
  else spacer 20 1 `beside` flow down
      [ welcome
      , flow down scenarios
      , spacer 1 40
      , fst team1
      , spacer 1 40
      , fst team2
      , spacer 1 40
      , startGame
      ]

(team1NameE,team1NameS) = Input.field "Team 1 Name"
(team2NameE,team2NameS) = Input.field "Team 2 Name"

team1Players : Signal (Element,[String])
team1Players = fieldGen "Team 1 Player Name"

team2Players : Signal (Element,[String])
team2Players = fieldGen "Team 2 Player Name"

main = draw startGame <~ 
  combine [scenario1,scenario2,scenario3] ~
  scoreGraph ~
  team1Players ~
  team2Players ~
  gameStarted