FROM ubuntu:12.04
MAINTAINER sameer@damagehead.com
ENV DEBIAN_FRONTEND noninteractive

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update # 20140405

# essentials
RUN apt-get install -y vim curl wget sudo net-tools pwgen unzip \
			logrotate supervisor openssh-server && apt-get clean

# build tools
# RUN apt-get install -y gcc make && apt-get clean

# image specific
RUN apt-get install -y mysql-server

ADD assets/ /app/
RUN chmod 755 /app/setup/install && /app/setup/install

ADD authorized_keys /root/.ssh/
RUN mv /app/.vimrc /app/.bash_aliases /root/
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys && chown root:root -R /root

EXPOSE 3306

CMD ["/usr/bin/supervisord", "-n"]
