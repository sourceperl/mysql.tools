#!/bin/bash
# setup for mysql tools

# vars
NAME=$(basename $0)

# some checks
[ $EUID -ne 0 ] && { printf "ERROR: $NAME needs to be run by root\n" 1>&2; exit 1; }

# current dir is script dir
cd "$(dirname "$0")"

# do the stuff
umask 022

cp mysql_convert_4to5 /usr/local/bin/
chmod +x /usr/local/bin/mysql_convert_4to5

cp mysql_export /usr/local/sbin/
chmod +x /usr/local/sbin/mysql_export

cp mysql_import /usr/local/sbin/
chmod +x /usr/local/sbin/mysql_import
