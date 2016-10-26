#!/bin/sh
set -e

elm make src/elm/Mastermind/Game.elm --output build/js/game.js
cp src/index.html build/index.html
mkdir -p build/css
cp src/css/* build/css/
