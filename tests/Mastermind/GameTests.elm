module Mastermind.GameTests exposing (all)

import Expect
import Mastermind.Four as Four exposing (Four)
import Mastermind.Game exposing (buildClues)
import Mastermind.Model exposing (Clue(..), Color(..))
import Test exposing (Test, describe, test)


all : Test
all =
    describe "Game.buildClues"
        [ test "with no matches" <|
            \() ->
                let
                    solution =
                        Four.build Blue Blue Blue Blue

                    attempt =
                        Four.build Magenta Magenta Magenta Magenta

                    expected =
                        Four.build NoMatch NoMatch NoMatch NoMatch
                in
                    Expect.equal expected (buildClues solution attempt)
        , test "with exact matches" <|
            \() ->
                let
                    solution =
                        Four.build Blue Orange Magenta Green

                    attempt =
                        Four.build Blue Orange Magenta Green

                    expected =
                        Four.build Correct Correct Correct Correct
                in
                    Expect.equal expected (buildClues solution attempt)
        , test "with one partial match" <|
            \() ->
                let
                    solution =
                        Four.build Orange Orange Blue Orange

                    attempt =
                        Four.build Blue Red Red Red

                    expected =
                        Four.build Misplaced NoMatch NoMatch NoMatch
                in
                    Expect.equal expected (buildClues solution attempt)
        ]
