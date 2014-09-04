#!/bin/bash
set -e

generate_mysql_localnet_filter () {
  if [ -d /sys/class/net/eth0 ]; then
    declare -a filter
    IFS=. read -a ip <<< $(ifconfig eth0 | awk '/inet addr:/ {print $2}'|sed 's/addr://')
    IFS=. read -a mask <<< $(ifconfig eth0 | awk '/inet addr:/ {print $4}'|sed 's/Mask://')
    for i in 0 1 2 3
    do
      if [ ${mask[$i]} -eq 255 ]; then
        filter[$i]="${ip[$i]}"
      else
        filter[$i]="%"
      fi
    done
    IFS=.; echo -n "${filter[*]}"
  else
    echo -n ""
  fi
}

# listen on all interfaces
cat > /etc/mysql/conf.d/mysql-listen.cnf <<EOF
[mysqld]
bind = 0.0.0.0
EOF

# fix permissions and ownership of /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql
chmod 700 /var/lib/mysql

# fix permissions and ownership of /var/run/mysqld
chown -R mysql:root /var/run/mysqld
chmod 755 /var/lib/mysql

# initialize MySQL data directory
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Installing database..."
  mysql_install_db --user=mysql >/dev/null 2>&1

  # start mysql server
  echo "Starting MySQL server..."
  /usr/bin/mysqld_safe >/dev/null 2>&1 &

  # wait for mysql server to start (max 120 seconds)
  timeout=120
  while ! mysqladmin -uroot ping >/dev/null 2>&1
  do
    timeout=$(expr $timeout - 1)
    if [ $timeout -eq 0 ]; then
      echo "Timeout error occurred trying to start MySQL Daemon."
      exit 1
    fi
    sleep 1
  done

  # grant remote access to root user over the localnet
  filter=$(generate_mysql_localnet_filter)
  if [ -n "$filter" ]; then
    echo "Allowing remote access to user 'root' over '$filter' network..."
    echo "GRANT ALL ON *.* TO 'root'@'${filter}' IDENTIFIED BY '' WITH GRANT OPTION;" | mysql -uroot
    echo "FLUSH PRIVILEGES;" | mysql -uroot
  fi
else
  echo "Starting MySQL server..."
  /usr/bin/mysqld_safe >/dev/null 2>&1 &
fi

tail -F /var/log/mysql/error.log
