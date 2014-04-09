# Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Store](#data-store)
    - [Securing the server](#securing-the-server)
    - [Allowing remote access](#allowing-remote-access)
- [Maintenance](#maintenance)
    - [SSH Login](#ssh-login)

# Introduction
Dockerfile to build a MySQL container image.

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```
docker pull sameersbn/mysql:latest
```

Alternately you can build the image yourself.

```
git clone https://github.com/sameersbn/docker-mysql.git
cd docker-mysql
docker build -t="$USER/mysql" .
```

# Quick Start
Run the mysql image

```
docker run -name mysql -d sameersbn/mysql:latest
MYSQL_IP=$(docker inspect mysql | grep IPAddres | awk -F'"' '{print $4}')
```

By default the root mysql user is not assigned a password and remote logins are permitted from the '172.17.%.%' address space. This means that you should be able to login to the mysql server as root from the host machine.

```
mysql -h${MYSQL_IP} -uroot
```

# Configuration

## Data Store
You should mount a volume at /var/lib/mysql.

```
mkdir /opt/mysql/mysql
docker run -name mysql -d \
  -v /opt/mysql/mysql:/var/lib/mysql sameersbn/mysql:latest
```

This will make sure that the data stored in the database is not lost when the image is stopped and started again.

## Securing the server
By default the mysql server does not assigned a password for the root user. If you wish secure the server, run the image with the app:secure_installation command

```
docker run -name mysql -i -t \
  -v /opt/mysql/mysql:/var/lib/mysql sameersbn/mysql:latest app:secure_installation
```

Internally the mysql_secure_installation command executed and you will be prompted to assign a password for the root user among other things.

## Allowing remote access
By default the installation will allow remote access to the root user from the '172.17.%.%' address space. This means that your host machine and other containers running on the host machine can login to the mysql server as root.

```
GRANT ALL ON *.<db-name> TO '<db-user>'@'<ip-address>' IDENTIFIED BY 'PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

# Maintenance

## SSH Login
There are two methods to gain root login to the container, the first method is to add your public rsa key to the authorized_keys file and build the image.

The second method is use the dynamically generated password. Every time the container is started a random password is generated using the pwgen tool and assigned to the root user. This password can be fetched from the docker logs.

```
docker logs mysql 2>&1 | grep '^User: ' | tail -n1
```
This password is not persistent and changes every time the image is executed.

# Upgrading

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Stop the currently running image

```
docker stop mysql
```

- **Step 2**: Update the docker image.

```
docker pull sameersbn/mysql:latest
```

- **Step 3**: Start the image

```
docker run -name mysql -d [OPTIONS] sameersbn/mysql:latest
```
