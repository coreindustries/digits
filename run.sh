#nvidia-docker run -it --rm --name digits -v /media/corey/raid/projects:/projects coreindustries/digits
nvidia-docker run --name digits -d -p 5000:5000 -p 6006:6006 -v /media/corey/raid/projects/digits:/jobs nvidia/digits:6.0
