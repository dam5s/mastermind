port module Mastermind.Ports exposing (..)

import Mastermind.Four as Four exposing (Four)
import Mastermind.Model exposing (Color(..), Model)


type alias GameState =
    { solution : Maybe (Four String)
    , pastAttempts : List (Four String)
    , currentAttempt : Four String
    , remainingAttempts : List (Four String)
    }


toGameState : Model -> GameState
toGameState model =
    { solution = Maybe.map (Four.map colorToString) model.solution
    , pastAttempts = List.map (Four.map colorToString) model.pastAttempts
    , currentAttempt = Four.map colorToString model.currentAttempt
    , remainingAttempts = List.map (Four.map colorToString) model.remainingAttempts
    }


colorToString : Color -> String
colorToString color =
    case color of
        Red ->
            "Red"

        Cyan ->
            "Cyan"

        Green ->
            "Green"

        Orange ->
            "Orange"

        Magenta ->
            "Magenta"

        Blue ->
            "Blue"

        None ->
            "None"


toModel : GameState -> Model
toModel gameState =
    { solution = Maybe.map (Four.map stringToColor) gameState.solution
    , pastAttempts = List.map (Four.map stringToColor) gameState.pastAttempts
    , currentAttempt = Four.map stringToColor gameState.currentAttempt
    , remainingAttempts = List.map (Four.map stringToColor) gameState.remainingAttempts
    }


stringToColor : String -> Color
stringToColor string =
    case string of
        "Red" ->
            Red

        "Cyan" ->
            Cyan

        "Green" ->
            Green

        "Orange" ->
            Orange

        "Magenta" ->
            Magenta

        "Blue" ->
            Blue

        _ ->
            None


port saveGame : GameState -> Cmd msg


port gameSaved : (Bool -> msg) -> Sub msg


port loadGame : Bool -> Cmd msg


port gameLoaded : (GameState -> msg) -> Sub msg
