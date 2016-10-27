module Tests exposing (..)

import Mastermind.CluesTests
import Test exposing (..)
import Expect
import String


all : Test
all =
    describe "Mastermind"
        [ Mastermind.CluesTests.all
        ]
