FROM sameersbn/ubuntu:12.04.20140628
MAINTAINER sameer@damagehead.com

RUN apt-get update && \
		apt-get install -y mysql-server && \
		rm -rf /var/lib/mysql/mysql && \
		apt-get clean # 20140418

ADD init /init
RUN chmod 755 /init

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

CMD ["/init"]
