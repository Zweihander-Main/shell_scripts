#!/usr/bin/env sh

# Scenario: You want to run OpenBBTerminal via docker on Linux with X support.

xhost +local:
sudo docker run -it --rm \
	--name openbb \
	--env-file="${XDG_CONFIG_HOME}/openbb/openbb.env" \
       	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	ghcr.io/openbb-finance/openbbterminal-poetry-full:latest
xhost -local:
