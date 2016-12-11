'use strict';

const Elm = require('./game.js');


let app = Elm.Mastermind.Game.fullscreen();


app.ports.saveGame.subscribe(function (savedGame) {
    localStorage.setItem('savedGame', JSON.stringify(savedGame));
    app.ports.gameSaved.send(true);
});

app.ports.loadGame.subscribe(function () {
    var savedGame = localStorage.getItem('savedGame');
    app.ports.gameLoaded.send(JSON.parse(savedGame));
});
