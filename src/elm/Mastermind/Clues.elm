module Mastermind.Clues exposing (Clue(..), buildClues)

import List.Extra exposing (zip)
import Mastermind.Four as Four exposing (Four)
import Mastermind.Model exposing (Color)


type Clue
    = Correct
    | Misplaced
    | NoClue


buildClues : Four Color -> Four Color -> Four Clue
buildClues solution attempt =
    let
        solutionList =
            Four.list solution

        attemptList =
            Four.list attempt
    in
        potentialMatchesToClues
            (buildPotentialMatches solution attempt)


buildPotentialMatches : Four Color -> Four Color -> Four PotentialMatch
buildPotentialMatches solution attempt =
    let
        exactMatches =
            initialMatches solution attempt
    in
        findPartialMatches exactMatches attempt


initialMatches : Four Color -> Four Color -> Four PotentialMatch
initialMatches solution attempt =
    { one = exactMatchOrNone solution.one attempt.one
    , two = exactMatchOrNone solution.two attempt.two
    , three = exactMatchOrNone solution.three attempt.three
    , four = exactMatchOrNone solution.four attempt.four
    }


exactMatchOrNone : Color -> Color -> PotentialMatch
exactMatchOrNone x y =
    if x == y then
        Match Correct
    else
        NoMatch x


findPartialMatches : Four PotentialMatch -> Four Color -> Four PotentialMatch
findPartialMatches matches attempt =
    List.foldl findPartialMatch matches (Four.list attempt)


findPartialMatch : Color -> Four PotentialMatch -> Four PotentialMatch
findPartialMatch color matches =
    if matches.one == NoMatch color then
        { matches | one = Match Misplaced }
    else if matches.two == NoMatch color then
        { matches | two = Match Misplaced }
    else if matches.three == NoMatch color then
        { matches | three = Match Misplaced }
    else if matches.four == NoMatch color then
        { matches | four = Match Misplaced }
    else
        matches


noMatches : Four Color -> Four PotentialMatch
noMatches solution =
    Four.map NoMatch solution


potentialMatchesToClues : Four PotentialMatch -> Four Clue
potentialMatchesToClues potentialMatches =
    Four.list potentialMatches
        |> List.map potentialMatchToClue
        |> List.sortWith clueComparison
        |> Four.fromList NoClue


clueComparison : Clue -> Clue -> Order
clueComparison a b =
    case a of
        Correct ->
            LT

        Misplaced ->
            case b of
                NoClue ->
                    LT

                Misplaced ->
                    EQ

                Correct ->
                    GT

        NoClue ->
            GT


potentialMatchToClue : PotentialMatch -> Clue
potentialMatchToClue potentialMatch =
    case potentialMatch of
        Match clue ->
            clue

        NoMatch color ->
            NoClue


type PotentialMatch
    = Match Clue
    | NoMatch Color
