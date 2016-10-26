module Tests exposing (..)

import Mastermind.GameTests
import Test exposing (..)
import Expect
import String


all : Test
all =
    describe "Mastermind"
        [ Mastermind.GameTests.all
        ]
