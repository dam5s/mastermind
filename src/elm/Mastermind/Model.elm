module Mastermind.Model exposing (..)

import Mastermind.Four exposing (Four)


type Color
    = Red
    | Cyan
    | Green
    | Orange
    | Magenta
    | Blue
    | None


type alias Model =
    { solution : Maybe (Four Color)
    , pastAttempts : List (Four Color)
    , currentAttempt : Four Color
    , remainingAttempts : List (Four Color)
    }
