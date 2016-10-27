module Mastermind.CluesTests exposing (all)

import Expect
import Mastermind.Four as Four exposing (Four)
import Mastermind.Clues exposing (buildClues, Clue(..))
import Mastermind.Model exposing (Color(..))
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
                        Four.build NoClue NoClue NoClue NoClue
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
        , test "with partial matches" <|
            \() ->
                let
                    solution =
                        Four.build Orange Orange Blue Green

                    attempt =
                        Four.build Blue Green Red Red

                    expected =
                        Four.build Misplaced Misplaced NoClue NoClue
                in
                    Expect.equal expected (buildClues solution attempt)
        , test "with repeating partial match" <|
            \() ->
                let
                    solution =
                        Four.build Orange Blue Blue Green

                    attempt =
                        Four.build Magenta Magenta Orange Orange

                    expected =
                        Four.build Misplaced NoClue NoClue NoClue
                in
                    Expect.equal expected (buildClues solution attempt)
        , test "when one in attempt and multiple in solution" <|
            \() ->
                let
                    solution =
                        Four.build Orange Blue Blue Orange

                    attempt =
                        Four.build Orange Magenta Magenta Magenta

                    expected =
                        Four.build Correct NoClue NoClue NoClue
                in
                    Expect.equal expected (buildClues solution attempt)
        ]
