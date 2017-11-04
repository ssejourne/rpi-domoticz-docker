#
# Dockerfile for Rpi-Domoticz
#
# Based on version by LBTM
#
# Base image.
FROM resin/rpi-raspbian:stretch

MAINTAINER Florian Chauveau

# Install Domoticz from sources.
RUN \
  apt-get update && \
  apt-get install -y cmake apt-utils build-essential && \
  apt-get install -y libboost-dev libboost-thread-dev libboost-system-dev libsqlite3-dev subversion curl libcurl4-openssl-dev libusb-dev zlib1g-dev && \
  apt-get install -y python3-dev && \
  apt-get install -y iputils-ping && \
  apt-get install -y wget && \
  apt-get clean && \
  apt-get autoclean && \
  wget https://releases.domoticz.com/releases/beta/domoticz_linux_armv7l.tgz -O /tmp/domoticz_linux_armv7l.tgz && \
  mkdir /root/domoticz && \
  tar xvf /tmp/domoticz_linux_armv7l.tgz -C /root/domoticz && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  ln -s /dev/ttyAMA0 /dev/ttyUSB20

# Expose port.
EXPOSE 8080

CMD ["/root/domoticz/domoticz", "-www", "8080"]

