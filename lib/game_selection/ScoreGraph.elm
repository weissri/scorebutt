module ScoreGraph (scoreGraph) where

{-
Contains the code for drawing the score graph
-}

import Mouse
import Graph
import Window

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
team3Scores = (,) <~ constant green ~ foldp (\t xs -> take 5000 <| (t, snd (head xs) + sin t * 6 + 0.5) :: xs) [(0,10)] (every <| second / 10)

-- Scores generated from cos wave
team4Scores : Signal (Color,[(Time,Float)])
team4Scores = (,) <~ constant purple ~ foldp (\t xs -> take 5000 <| (t, snd (head xs) + cos t * 6 + 0.5) :: xs) [(0,10)] (every <| second / 10)

scoreGraph = (\xs wx wy -> Graph.timeline wx (wy `div` 2) (1/(toFloat wx/30)) (1/2) xs) <~ 
  combine [team1Scores, team2Scores, team3Scores, team4Scores] ~ Window.width ~ Window.height