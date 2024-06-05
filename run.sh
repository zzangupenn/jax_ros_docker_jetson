#!/bin/bash

xhost +
XSOCK=/tmp/.X11-unix

docker run -it --rm \
 --runtime=nvidia \
 -e DISPLAY=$DISPLAY \
 -v $XSOCK:$XSOCK \
 --privileged \
 --net=host \
 --shm-size=1g \
 jax_ros /usr/bin/bash