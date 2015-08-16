FROM sameersbn/ubuntu:14.04.20150805
MAINTAINER sameer@damagehead.com

RUN apt-get update \
 && apt-get install -y mysql-server \
 && rm -rf /var/lib/mysql \
 && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3306/tcp
VOLUME ["/var/lib/mysql", "/run/mysqld"]
CMD ["/sbin/entrypoint.sh"]
