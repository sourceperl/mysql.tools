#!/bin/bash
# add a logrotate conf file for backup a database with 8 days rotates
# usage: sudo ./add_rotate_backup.sh DB_NAME
#
# need: mysql_export must be install

# params
DB=$1

# vars
NAME=$(basename $0)
BAK_FILE="/var/backups/$DB.sql.gz"

# some checks
[ $EUID -ne 0 ] && { printf "ERROR: $NAME needs to be run by root\n" 1>&2; exit 1; }
[ ! -x "$(command -v mysql_export)" ] && { printf "ERROR: mysql_export not found\n" 1>&2; exit 1; }
[[ ! "$DB" =~ ^[a-z][a-zA-Z0-9_]*$ ]] && { printf "ERROR: $DB not valid DB name\n" 1>&2; exit 1; }

# current dir is script dir
cd "$(dirname "$0")"

# install logrotate conf.
umask 022

ROTATE_CONF="$BAK_FILE {\n
  daily\n
  rotate 8\n
  nocompress\n
  create 640 root adm\n
  postrotate\n
  mysql_export $DB $BAK_FILE\n
  endscript\n}"

ROTATE_FILE="/etc/logrotate.d/$DB-sql-backup"
if [ -f $ROTATE_FILE ]
then
  echo "$ROTATE_FILE already exist"
else
  echo "create $ROTATE_FILE"
  echo -e $ROTATE_CONF > $ROTATE_FILE
  echo "init first backup $BAK_FILE (need by logrotate)"
  mysql_export $DB $BAK_FILE
fi
