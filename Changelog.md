# Changelog

**latest**
- mount volume at `/var/run/mysqld` allowing the mysql unix socket can be exposed
- determine remote access filter based on the docker network (first run only).
- switched to sameersbn/ubuntu:14.04.20140818 base image
- optimized image size by removing `/var/lib/apt/lists/*`.
- accept connections only after we have create the users and databases
