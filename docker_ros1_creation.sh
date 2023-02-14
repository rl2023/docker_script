#!/bin/bash

xhost +

##Without sharing a folder
docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb \
--env=LOCAL_USER_ID="$(id -u)" \
-v /home/jcacace/dev:/home/dev/:rw \
-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
-e DISPLAY=:0 \
--network host \
--workdir="/home/dev/" \
--name=ros1-noetic osrf/ros:noetic-desktop bash



