'use strict';

const electron = require('electron');
const path = require('path');


let mainWindow = null;

let createWindow = () => {
    if (mainWindow !== null) {
        return;
    }

    mainWindow = new electron.BrowserWindow({
        width: 600,
        height: 800,
        useContentSize: true,
        resizable: false,
        fullscreen: false,
        show: false,
        titleBarStyle: 'hidden-inset',
        icon: path.join(__dirname, '..', '..', 'assets', 'icon.png')
    });


    mainWindow.loadURL(`file://${path.join(__dirname, 'index.html')}`);

    mainWindow.webContents.on('did-finish-load', () => {
        setTimeout(() => {
            mainWindow.show();
        }, 100);
    });

    mainWindow.on('closed', () => {
        mainWindow = null
    });
};


electron.app.on('ready', createWindow);
electron.app.on('activate', createWindow);

electron.app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        electron.app.quit()
    }
});
