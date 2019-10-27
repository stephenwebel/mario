module Main exposing (..)


import Playground exposing (..)
import Debug exposing (log)
import Set

-- MAIN


main =
  game view update
    { x = 0
    , y = 0
    , vx = 0
    , vy = 0
    , px = 0
    , py = 0
    , dir = "right"
    , prev_keys = Set.fromList []
    , in_air = False
    , can_double_jump = False
    , double_jumped = False
    }


-- VIEW


view computer mario =
  let
    w = computer.screen.width
    h = computer.screen.height
    b = computer.screen.bottom
  in
  [ rectangle (rgb 174 238 238) w h
  , rectangle (rgb 74 163 41) w 100
      |> moveY b
  , image 70 70 (toGif mario)
      |> move mario.x (b + 76 + mario.y)
  ]


toGif mario =
  if mario.y > 0 then
    "images/mario/jump/" ++ mario.dir ++ ".gif"
  else if mario.vx /= 0 then
    "images/mario/walk/" ++ mario.dir ++ ".gif"
  else
    "images/mario/stand/" ++ mario.dir ++ ".gif"



-- UPDATE


update computer mario =
  let
    dt = 1.666
    vx = toX computer.keyboard
    keys_down = Set.diff computer.keyboard.keys mario.prev_keys

    grounded = mario.y == 0
    
    hit_space = Set.member " " keys_down

    jumped = grounded && hit_space

    double_jumped = mario.can_double_jump && hit_space
  

    vy =
      if jumped then 5
      else if double_jumped then 7
      else mario.vy - dt / 8
    x = mario.x + dt * vx
    y = mario.y + dt * vy
    px = mario.x
    py = mario.y
  in
  { x = x
  , y = max 0 y
  , vx = vx
  , vy = vy
  , px = px
  , py = py
  , dir = if vx == 0 then mario.dir else if vx < 0 then "left" else "right"
  , prev_keys = computer.keyboard.keys
  , in_air = mario.y > 0
  , can_double_jump = log "double_jumped" (mario.double_jumped == False) && mario.in_air
  , double_jumped = if grounded then False else (mario.double_jumped || double_jumped)
  }

    -- { x = 0
    -- , y = 0
    -- , vx = 0
    -- , vy = 0
    -- , px = 0
    -- , py = 0
    -- , dir = "right"
    -- , prev_keys = Set.fromList []
    -- , did_double_jump = False
    -- , in_air = False
    -- }