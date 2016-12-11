#!/bin/sh
set -e

elm make src/elm/Mastermind/Game.elm --output build/game.js
cp -r src/index.html src/ports.js src/main.js src/css build/
