#!/bin/bash
set -e

# listen on all interfaces
cat > /etc/mysql/conf.d/mysql-listen.cnf <<EOF
[mysqld]
bind = 0.0.0.0
EOF

# fix permissions and ownership of /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql
chmod 700 /var/lib/mysql

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

	# grant remote access from '172.17.%.%' address space to root user
	echo "GRANT ALL ON *.* TO 'root'@'172.17.%.%' IDENTIFIED BY '' WITH GRANT OPTION;" | mysql -uroot
	echo "FLUSH PRIVILEGES;" | mysql -uroot
else
	echo "Starting MySQL server..."
	/usr/bin/mysqld_safe >/dev/null 2>&1 &
fi

tail -F /var/log/mysql/error.log
