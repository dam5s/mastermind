module Mastermind.Game exposing (main)

import Html exposing (Html, div, h1, li, nav, p, section, text, ul)
import Html.App
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Mastermind.Clues exposing (Clue(NoClue), buildClues)
import Mastermind.Model exposing (Color(..), Model)
import Mastermind.Four as Four exposing (Four)
import Mastermind.Generator as Generator
import Random exposing (Generator)


type Msg
    = SolutionGenerated (Four Color)
    | Choose Color
    | Erase
    | Check


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
                        , [ viewCurrentAttempt solution ]
                        ]
                    )
                , nav [ class "controls" ]
                    [ div [ onClick (Choose Red), class "pin Red" ] []
                    , div [ onClick (Choose Cyan), class "pin Cyan" ] []
                    , div [ onClick (Choose Green), class "pin Green" ] []
                    , div [ onClick (Choose Orange), class "pin Orange" ] []
                    , div [ onClick (Choose Magenta), class "pin Magenta" ] []
                    , div [ onClick (Choose Blue), class "pin Blue" ] []
                    , div [ onClick Erase, class "pin None" ] []
                    , div [ onClick Check, class "pin Ok" ] []
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
            (List.repeat 4 (viewClue NoClue))
        ]


viewRemainingAttempt =
    viewCurrentAttempt


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
            { model | currentAttempt = chooseColor model.currentAttempt color }
                ! []

        Erase ->
            { model | currentAttempt = erase model.currentAttempt }
                ! []

        Check ->
            case model.remainingAttempts of
                [] ->
                    ( model, Cmd.none )

                x :: xs ->
                    { model
                        | pastAttempts = (List.append model.pastAttempts [ model.currentAttempt ])
                        , currentAttempt = x
                        , remainingAttempts = xs
                    }
                        ! []


chooseColor : Four Color -> Color -> Four Color
chooseColor attempt color =
    if attempt.one == None then
        { attempt | one = color }
    else if attempt.two == None then
        { attempt | two = color }
    else if attempt.three == None then
        { attempt | three = color }
    else
        { attempt | four = color }


erase : Four Color -> Four Color
erase attempt =
    if attempt.four /= None then
        { attempt | four = None }
    else if attempt.three /= None then
        { attempt | three = None }
    else if attempt.two /= None then
        { attempt | two = None }
    else
        { attempt | one = None }


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
