const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('api', {
  onGPUData: (callback) => {
    ipcRenderer.on('gpu-data', (_, data) => callback(data));
  }
});