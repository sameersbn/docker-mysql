FROM ubuntu:12.04
MAINTAINER sameer@damagehead.com

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get clean # 20130925

RUN apt-get install -y mysql-server

ADD resources/ /mysql/
RUN chmod 755 /mysql/setup/configure /mysql/setup/install && /mysql/setup/install

EXPOSE 3306

CMD ["/usr/bin/mysqld_safe"]
