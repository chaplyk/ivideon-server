FROM ubuntu:17.10

MAINTAINER Bohdan Chaplyk

ENV DEBIAN_FRONTEND noninteractive

COPY videoserverd.config /root/.IvideonServer/videoserverd.config

RUN \
  apt-get update && \
  apt-get install -y \
  xvfb \
  x11vnc \
  openbox menu \
  wget gnupg

RUN wget http://packages.ivideon.com/ubuntu/keys/ivideon.list -O /etc/apt/sources.list.d/ivideon.list
RUN wget -O ~/ivideon.key http://packages.ivideon.com/ubuntu/keys/ivideon.key
RUN apt-key add ~/ivideon.key
RUN apt-get update
RUN apt-get install -y ivideon-video-server

RUN mkdir ~/.vnc
RUN x11vnc -storepasswd 1122334455 ~/.vnc/passwd

CMD \
# X Server
  Xvfb :1 -screen 0 1280x720x16 & \
# Openbox
  (export DISPLAY=:1 && openbox-session) & \
  (export DISPLAY=:1 && ivideon-server) & \
  service videoserver start & \
# VNC Server
   x11vnc -display :1.0 -forever -rfbauth ~/.vnc/passwd
