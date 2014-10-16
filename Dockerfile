FROM phusion/baseimage:0.9.11
MAINTAINER boyer411 <boyer411@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/trusty universe multiverse"
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/trusty-updates universe multiverse"
RUN apt-get update -q

# Install Dependencies
RUN apt-get install -yq rrdtool perl libwww-perl libmailtools-perl libmime-lite-perl librrds-perl libdbi-perl libxml-simple-perl libhttp-server-simple-perl libconfig-general-perl libio-socket-ssl-perl

# Install Monitorix
RUN mkdir /opt/monitorix
RUN apt-get install -y wget nano
RUN wget http://www.monitorix.org/monitorix_3.6.0-izzy1_all.deb && \ dpkg -i monitorix*.deb
RUN chown nobody:users /opt/monitorix

EXPOSE 8080

# Monitorix Configuration
VOLUME /config

# Add the launch script
ADD launch.sh /launch.sh
RUN chmod +x /launch.sh

ENTRYPOINT /launch.sh
