sudo lshw -C display
sudo lshw -c video | grep configuration
modinfo vmwgfx 
sudo apt-get install mesa-utils
glxinfo | grep openGL

