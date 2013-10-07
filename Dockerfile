FROM ubuntu:12.04
MAINTAINER sameer@damagehead.com

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get clean # 20130925

RUN apt-get install -y mysql-server

ADD resources/mysql-listen.cnf /etc/mysql/conf.d/mysql-listen.cnf
ADD resources/commands.sql /mysql/commands.sql
ADD resources/configure /mysql/configure
RUN chmod 755 /mysql/configure && /mysql/configure

EXPOSE 3306

CMD ["/usr/bin/mysqld_safe"]
