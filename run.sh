#!/bin/bash

xhost +
XSOCK=/tmp/.X11-unix

docker run -it --rm \
 --runtime=nvidia \
 -e DISPLAY=$DISPLAY \
 -v $XSOCK:$XSOCK \
 -v /home/nvidia:/workspace/home \
 --privileged \
 --net=host \
 --ipc=host \
 --pid=host \
 --shm-size=500M \
 zzang2/jax_ros:humble_jax0.4.35
