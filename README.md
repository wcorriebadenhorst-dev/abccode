# AbcCode

#long way

Terminal 1  

cd ~/AbcCode/gpu-share							#Die main folder
source venv/bin/activate
python3 app.py

Terminal 2

cd ~/AbcCode/gpu-share/electron-app
npm start

#shortway
bash ~/AbcCode/gpu-share/setup.sh 
bash ~/AbcCode/gpu-share/run.sh