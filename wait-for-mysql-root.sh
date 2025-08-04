#!/bin/bash
set -e

if [ -n "$DB_HOST" ]; then
  MYSQL_HOST=$DB_HOST
fi
if [ -n "$DB_USER" ]; then
  MYSQL_USER=$DB_USER
fi
if [ -n "$DB_PASSWORD" ]; then
  MYSQL_PASSWORD=$DB_PASSWORD
fi
if [ -n "$DB_ROOT_USER" ]; then
  MYSQL_ROOT_USER=$DB_ROOT_USER
fi
if [ -n "$DB_ROOT_PASSWORD" ]; then
  MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD
fi
if [ "$WAIT_TIMEOUT" = "" ]; then
  WAIT_TIMEOUT=900
fi

echo "waiting for mysql server..."
if [ "$MYSQL_ROOT_PASSWORD" = "" ]
then
  echo "skipping database connection test because of missing root password"
else
  echo "using host $MYSQL_HOST"
  echo "using user $MYSQL_ROOT_USER"
  i=0
  while ! mariadb-admin status -h"$MYSQL_HOST" -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" ; do
    sleep 1
    echo -n .
    ((i++))
    if [ $i -gt $WAIT_TIMEOUT ]
    then
      echo "timeout"
      exit 1
    fi
  done
fi
