# Table of Contents

- [Introduction](#introduction)
- [Changelog](Changelog.md)
- [Reporting Issues](#reporting-issues)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Store](#data-store)
    - [Allowing remote access](#allowing-remote-access)
- [Shell Access](#shell-access)
- [Upgrading](#upgrading)

# Introduction
Dockerfile to build a MySQL container image which can be linked to other containers.

# Reporting Issues

Docker is a relatively new project and is active being developed and tested by a thriving community of developers and testers and every release of docker features many enhancements and bugfixes.

Given the nature of the development and release cycle it is very important that you have the latest version of docker installed because any issue that you encounter might have already been fixed with a newer docker release.

For ubuntu users I suggest [installing docker](https://docs.docker.com/installation/ubuntulinux/) using docker's own package repository since the version of docker packaged in the ubuntu repositories are a little dated.

Here is the shortform of the installation of an updated version of docker on ubuntu.

```bash
sudo apt-get purge docker.io
curl -s https://get.docker.io/ubuntu/ | sudo sh
sudo apt-get update
sudo apt-get install lxc-docker
```

Fedora and RHEL/CentOS users should try disabling selinux with `setenforce 0` and check if resolves the issue. If it does than there is not much that I can help you with. You can either stick with selinux disabled (not recommended by redhat) or switch to using ubuntu.

If using the latest docker version and/or disabling selinux does not fix the issue then please file a issue request on the [issues](https://github.com/sameersbn/docker-mysql/issues) page.

In your issue report please make sure you provide the following information:

- The host ditribution and release version.
- Output of the `docker version` command
- Output of the `docker info` command
- The `docker run` command you used to run the image (mask out the sensitive bits).

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull sameersbn/mysql:latest
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/sameersbn/docker-mysql.git
cd docker-mysql
docker build -t="$USER/mysql" .
```

# Quick Start

Run the mysql image

```bash
docker run -name mysql -d sameersbn/mysql:latest
```

By default the root mysql user is not assigned a password and remote logins are permitted from the docker network which normally is the '172.17.%.%' address space. This means that you should be able to login to the mysql server as root from the host machine as well as other containers running on the same host.

To test if the mysql server is configured properly, try connecting to the server.

```bash
mysql -h$(docker inspect --format {{.NetworkSettings.IPAddress}} mysql) -uroot
```

# Configuration

## Data Store

You should mount a volume at `/var/lib/mysql`.

SELinux users are also required to change the security context of the mount point so that it plays nicely with selinux.

```bash
mkdir -p /opt/mysql/data
sudo chcon -Rt svirt_sandbox_file_t /opt/mysql/data
```

The updated run command looks like this.

```
docker run -name mysql -d \
  -v /opt/mysql/data:/var/lib/mysql sameersbn/mysql:latest
```

This will make sure that the data stored in the database is not lost when the image is stopped and started again.

## Allowing remote access

By default the installation will allow remote access to the root user from the docker network which normally is the `172.17.%.%` address space. This means that your host machine and other containers running on the host machine can login to the mysql server as root.

```sql
GRANT ALL ON *.<db-name> TO '<db-user>'@'<ip-address>' IDENTIFIED BY 'PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

# Shell Access

For debugging and maintenance purposes you may want access the container shell. Since the container does not allow interactive login over the SSH protocol, you can use the [nsenter](http://man7.org/linux/man-pages/man1/nsenter.1.html) linux tool (part of the util-linux package) to access the container shell.

Some linux distros (e.g. ubuntu) use older versions of the util-linux which do not include the `nsenter` tool. To get around this @jpetazzo has created a nice docker image that allows you to install the `nsenter` utility and a helper script named `docker-enter` on these distros.

To install the nsenter tool on your host execute the following command.

```bash
docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
```

Now you can access the container shell using the command

```bash
sudo docker-enter mysql
```

For more information refer https://github.com/jpetazzo/nsenter

Another tool named `nsinit` can also be used for the same purpose. Please refer https://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/ for more information.

# Upgrading

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Stop the currently running image

```bash
docker stop mysql
```

- **Step 2**: Update the docker image.

```bash
docker pull sameersbn/mysql:latest
```

- **Step 3**: Start the image

```bash
docker run -name mysql -d [OPTIONS] sameersbn/mysql:latest
```
