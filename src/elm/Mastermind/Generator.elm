module Mastermind.Generator exposing (fourColors)

import Mastermind.Four as Four exposing (Four)
import Mastermind.Model exposing (Color(..))
import Random exposing (Generator)


fourColors : Generator (Four Color)
fourColors =
    Random.map4 Four.build
        colorGenerator
        colorGenerator
        colorGenerator
        colorGenerator


colorGenerator : Generator Color
colorGenerator =
    Random.map intToColor (Random.int 0 5)


intToColor : Int -> Color
intToColor int =
    case int of
        0 ->
            Red

        1 ->
            Cyan

        2 ->
            Green

        3 ->
            Orange

        4 ->
            Magenta

        _ ->
            Blue
