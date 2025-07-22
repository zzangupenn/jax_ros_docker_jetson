#!/bin/bash

xhost +
XSOCK=/tmp/.X11-unix

docker run -it --rm \
 --runtime=nvidia \
 -e DISPLAY=$DISPLAY \
 -v $XSOCK:$XSOCK \
 -v /home/nvidia:/home/docker/host \
 --privileged \
 --net=host \
 --ipc=host \
 --pid=host \
 --shm-size=500M \
 test2
