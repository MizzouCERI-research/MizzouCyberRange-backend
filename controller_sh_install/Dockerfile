From Ubuntu

MAINTAINER Songjie Wang "wangso@missouri.edu"

RUN apt-get -y update
RUN apt-get -y install vim nano curl python
RUN mkdir /data
WORKDIR /data
COPY controller_install.sh /data/.
RUN chmod +x controller_install.sh
RUN ./controller_install.sh
RUN service apach2 start
RUN service mysql start
