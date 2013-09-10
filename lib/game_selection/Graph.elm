module Graph where

line : Int -> Int -> Float -> Float -> [(Color,[(Float,Float)])] -> Element
line w h x y cs =
  let hw = toFloat w / 2
      hh = toFloat h / 2
      fs = map (\(c,xs) -> traced (solid c) (path <| map (\(a,b) -> (a*x,b*y)) xs)) cs
      gs = map (move (-hw,-hh)) fs in
  collage w h <| (outlined (solid black) <| rect (toFloat w) (toFloat h)) :: gs

timeline : Int -> Int -> Float -> Float -> [(Color,[(Time,Float)])] -> Element
timeline w h x y xs = 
  let f qs = case qs of
        (q,_)::_ -> map (\(t,a) -> (abs <| t - q, a)) qs
        []       -> [] in
  line w h x y <| map (\(c,ys) -> (c,f ys)) xs