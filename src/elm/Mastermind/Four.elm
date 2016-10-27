module Mastermind.Four exposing (Four, map, list, fromList, build)


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


fromList : a -> List a -> Four a
fromList default list =
    let
        elem =
            listElement default list
    in
        { one = elem 0
        , two = elem 1
        , three = elem 2
        , four = elem 3
        }


listElement : a -> List a -> Int -> a
listElement default list index =
    Maybe.withDefault default (List.head (List.drop index list))


listMap : (a -> b) -> Four a -> List b
listMap f four =
    list (map f four)
