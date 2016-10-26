module Mastermind.Four exposing (Four, map, list, build)


type alias Four a =
    { one : a
    , two : a
    , three : a
    , four : a
    }


build : a -> a -> a -> a -> Four a
build w x y z =
    { one = w
    , two = x
    , three = y
    , four = z
    }


map : (a -> b) -> Four a -> Four b
map mapFunc four =
    { one = mapFunc four.one
    , two = mapFunc four.two
    , three = mapFunc four.three
    , four = mapFunc four.four
    }


list : Four a -> List a
list four =
    [ four.one
    , four.two
    , four.three
    , four.four
    ]


listMap : (a -> b) -> Four a -> List b
listMap f four =
    list (map f four)
