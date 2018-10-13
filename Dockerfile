FROM ubuntu:17.10

MAINTAINER Bohdan Chaplyk

ENV DEBIAN_FRONTEND noninteractive

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
  Xvfb :99 -ac -listen tcp -screen 0 1280x720x16 & \
  (export DISPLAY=:99 && openbox-session) & \
  (export DISPLAY=:99 && ivideon-server) & \
  service videoserver start & \
  x11vnc -display :99.0 -forever -rfbauth ~/.vnc/passwd
