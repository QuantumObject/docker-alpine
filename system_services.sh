#!/bin/sh
export LC_ALL=C TERM="xterm"

#adding testing repository 
echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk --no-cache upgrade

## Install init process.
cp /build/bin/my_init /sbin/
chmod 750 /sbin/my_init
mkdir -p /etc/my_init.d
mkdir -p /etc/container_environment
touch /etc/container_environment.sh
touch /etc/container_environment.json
chmod 700 /etc/container_environment

addgroup -g 8377 docker_env
chown :docker_env /etc/container_environment.sh /etc/container_environment.json
chmod 640 /etc/container_environment.sh /etc/container_environment.json
ln -s /etc/container_environment.sh /etc/profile.d/
echo ". /etc/container_environment.sh" >> /root/.bashrc

## Install runit.
apk --no-cache add runit

## Install cron daemon.
mkdir -p /etc/service/cron
mkdir -p /var/log/cron
chmod 600 /etc/crontabs
cp /build/runit/cron /etc/service/cron/run
cp /build/config/cron_log_config /var/log/cron/config
chown -R cron  /var/log/cron
chmod +x /etc/service/cron/run

## Often used tools.
apk --no-cache add psmisc

#cleanup
rm -rf /build
rm -rf /tmp/* /var/tmp/*
