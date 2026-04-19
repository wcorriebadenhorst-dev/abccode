const { app, BrowserWindow } = require('electron');
const { execFile } = require('child_process');
const path = require('path');

function createWindow() {
  const win = new BrowserWindow({
    width: 900,
    height: 600,
    webPreferences: {
      preload: __dirname + '/preload.js'
    }
  });

  win.loadFile('web-ui/index.html');

  win.webContents.on('did-finish-load', () => {
    const rustBinary = path.join(
      __dirname,
      '../rust-host/target/release/rust-host'
    );

    execFile(rustBinary, (err, stdout) => {
      if (err) {
        console.error(err);
        return;
      }

      const gpus = JSON.parse(stdout);

      win.webContents.send('gpu-data', gpus);
    });
  });
}

app.whenReady().then(createWindow);