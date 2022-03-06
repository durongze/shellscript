   git clone https://github.com/KLayout/klayout.git
   cd klayout/
   git fetch --all
   git submodule update --remote
   git submodule update
   git submodule init
   git submodule sync
   sudo apt install ruby2.7-dev 
   sudo apt install libqt5core5a 
   sudo apt-get install qt5-default
   sudo apt-get install libqt5webkit5-dev
   sudo apt-get install libqt5multimedia5
   sudo apt-get install libqt5multimediawidgets5 
   sudo apt-get install libqt5svg5 
   sudo apt-get install libqt5svg5-dev 
   sudo apt-get install libqt5multimediawidgets5 
   sudo apt-get install libqt5xmlpatterns5-dev 
   sudo apt-get install libqt5designer5 
   sudo apt-get install libqt5multimediaquick5
   sudo apt-get install libqt5multimediawidgets5 
   sudo apt-get install qtmultimedia5-dev 
   sudo apt-get install qttools5-dev
   ./build.sh 
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${HOME}/code/klayout/klayout/bin-release/
   ./bin-release/klayout 
