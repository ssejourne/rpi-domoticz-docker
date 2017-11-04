#
# Dockerfile for Rpi-Domoticz
#
# Based on version by LBTM
#
# Base image.
FROM resin/rpi-raspbian:stretch

LABEL maintainer="sebastien@sejourne.org"

# Install Domoticz from sources.
RUN \
  apt-get update && \
  apt-get install -y cmake apt-utils build-essential \
  	libboost-all-dev \
	libsqlite3-0 libsqlite3-dev \
	libssl1.0.2 libssl1.1 libssl-dev \
	curl libcurl4-openssl-dev \
	libusb-dev \
        libudev-dev \
	zlib1g-dev \
  	python3-dev python3-pip \
  	iputils-ping \
  	wget \
  	git && \

# Fix libssl1.0.0 bug with domoticz
  wget http://mirrordirector.raspbian.org/raspbian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u6_armhf.deb -O /tmp/libssl1.0.0_1.0.1t-1+deb8u6_armhf.deb && \
  dpkg -i /tmp/libssl1.0.0_1.0.1t-1+deb8u6_armhf.deb && \

## OpenZwave installation
# grep git version of openzwave
  git clone --depth 2 https://github.com/OpenZWave/open-zwave.git /src/open-zwave && \
  cd /src/open-zwave && \
# compile
  make && \

# "install" in order to be found by domoticz
  ln -s /src/open-zwave /src/open-zwave-read-only && \

# Link ttyUSB20 to zwave module on GPIO - pas marche...
  ln -s /dev/ttyAMA0 /dev/ttyUSB20 && \

# INSTALL domoticz
  wget https://releases.domoticz.com/releases/release/domoticz_linux_armv7l.tgz -O /tmp/domoticz_linux_armv7l.tgz && \
  mkdir /root/domoticz && \
  tar xvf /tmp/domoticz_linux_armv7l.tgz -C /root/domoticz && \

# ouimeaux
##pip3 install -U ouimeaux && \

# CLEANUP
  apt-get autoremove -y && \
  apt-get clean && \
  apt-get autoclean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Volume
VOLUME /config

# Expose port.
EXPOSE 8080

CMD ["/root/domoticz/domoticz", "-www", "8080", "-sslwww", "0"]

