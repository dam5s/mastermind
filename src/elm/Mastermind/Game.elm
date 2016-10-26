module Mastermind.Game exposing (main, buildClues)

import Html exposing (Html, div, h1, li, nav, p, section, text, ul)
import Html.App
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List.Extra exposing (zip)
import Mastermind.Model exposing (Clue(..), Color(..), Model)
import Mastermind.Four as Four exposing (Four)
import Mastermind.Generator as Generator
import Random exposing (Generator)


type Msg
    = SolutionGenerated (Four Color)
    | Choose Color


initialModel : Model
initialModel =
    { solution = Nothing
    , pastAttempts = []
    , currentAttempt = blankAttempt
    , remainingAttempts = List.repeat 11 blankAttempt
    }


blankAttempt : Four Color
blankAttempt =
    { one = None
    , two = None
    , three = None
    , four = None
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Random.generate SolutionGenerated Generator.fourColors )


view : Model -> Html Msg
view model =
    case model.solution of
        Nothing ->
            section [ class "game" ]
                [ h1 [] [ text "mastermind" ]
                , p [] [ text "Loading..." ]
                ]

        Just solution ->
            section [ class "game" ]
                [ h1 [] [ text "mastermind" ]
                , ul [ class "attempts" ]
                    (List.concat
                        [ (List.map (viewAttemptWithClues solution) model.pastAttempts)
                        , [ viewCurrentAttempt model.currentAttempt ]
                        , (List.map viewRemainingAttempt model.remainingAttempts)
                        ]
                    )
                , nav [ class "controls" ]
                    [ div [ onClick (Choose Red), class "pin Red" ] []
                    , div [ onClick (Choose Cyan), class "pin Cyan" ] []
                    , div [ onClick (Choose Green), class "pin Green" ] []
                    , div [ onClick (Choose Orange), class "pin Orange" ] []
                    , div [ onClick (Choose Magenta), class "pin Magenta" ] []
                    , div [ onClick (Choose Blue), class "pin Blue" ] []
                    , div [ onClick (Choose None), class "pin None" ] []
                    , div [ class "pin Ok" ] []
                    ]
                ]


viewAttemptWithClues : Four Color -> Four Color -> Html Msg
viewAttemptWithClues solution attempt =
    let
        clues =
            buildClues solution attempt

        clueViews =
            Four.map viewClue clues
    in
        li [ class "attempt" ]
            [ div [ class "pins" ]
                (Four.list (Four.map viewPin attempt))
            , div [ class "clues" ]
                (Four.list clueViews)
            ]


viewCurrentAttempt : Four Color -> Html Msg
viewCurrentAttempt attempt =
    li [ class "attempt" ]
        [ div [ class "pins" ]
            [ viewPin attempt.one
            , viewPin attempt.two
            , viewPin attempt.three
            , viewPin attempt.four
            ]
        , div [ class "clues" ]
            (List.repeat 4 (viewClue NoMatch))
        ]


viewRemainingAttempt =
    viewCurrentAttempt


buildClues : Four Color -> Four Color -> Four Clue
buildClues solution attempt =
    let
        solutionList =
            Four.list solution

        attemptList =
            Four.list attempt
    in
        cluesFromMatches
            (numberOfPerfectMatches solutionList attemptList)
            (numberOfMisplacedMatches solutionList attemptList)


cluesFromMatches : Int -> Int -> Four Clue
cluesFromMatches perfect misplaced =
    listToFourClue
        (List.concat
            [ (List.repeat perfect Correct)
            , (List.repeat misplaced Misplaced)
            , (List.repeat (4 - misplaced - perfect) NoMatch)
            ]
        )


listToFourClue : List Clue -> Four Clue
listToFourClue list =
    { one = clueAtIndex 0 list
    , two = clueAtIndex 1 list
    , three = clueAtIndex 2 list
    , four = clueAtIndex 3 list
    }


clueAtIndex : Int -> List Clue -> Clue
clueAtIndex index list =
    Maybe.withDefault NoMatch (List.head (List.drop index list))


numberOfPerfectMatches : List Color -> List Color -> Int
numberOfPerfectMatches solutionList attemptList =
    zip solutionList attemptList
        |> List.foldl accumulateMatches 0


numberOfMisplacedMatches : List Color -> List Color -> Int
numberOfMisplacedMatches solutionList attemptList =
    attemptList
        |> List.foldl (accumulateMisplaced solutionList) 0


accumulateMatches : ( Color, Color ) -> Int -> Int
accumulateMatches ( colorOne, colorTwo ) current =
    if colorOne == colorTwo then
        current + 1
    else
        current


accumulateMisplaced : List Color -> Color -> Int -> Int
accumulateMisplaced solutionList attempt current =
    if List.member attempt solutionList then
        current + 1
    else
        current


viewClue : Clue -> Html Msg
viewClue clue =
    div [ class ("clue " ++ toString clue) ] []


viewPin : Color -> Html Msg
viewPin color =
    div [ class ("pin " ++ toString color) ] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SolutionGenerated new ->
            ( { model | solution = Just new }, Cmd.none )

        Choose color ->
            let
                current =
                    model.currentAttempt

                new =
                    { current | one = color }
            in
                ( { model | currentAttempt = new }, Cmd.none )


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
