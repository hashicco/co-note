#!/bin/sh
set -e

mkdir -p /var/log/mysql
chown -R mysql /var/log/mysql

touch /var/log/mysql/general.log
touch /var/log/mysql/error.log
touch /var/log/mysql/slow_query.log
chown mysql /var/log/mysql/*.log

