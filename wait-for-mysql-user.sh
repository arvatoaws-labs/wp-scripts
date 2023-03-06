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
if [ "$WAIT_TIMEOUT" = "" ];then
  WAIT_TIMEOUT=900
fi

if [ "$MYSQL_HOST" = "" ]
then
  echo "please define MYSQL_HOST or DB_HOST"
  exit 1
fi
if [ "$MYSQL_USER" = "" ]
then
  echo "please define MYSQL_USER or DB_USER"
  exit 1
fi
if [ "$MYSQL_PASSWORD" = "" ]
then
  echo "please define MYSQL_PASSWORD or DB_PASSWORD"
  exit 1
fi

echo "waiting for mysql server..."
echo "using host $MYSQL_HOST"
echo "using user $MYSQL_USER"

i=0
while ! mysqladmin status -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" ; do
  sleep 1
  echo -n .
  ((i++))
  if [ $i -gt $WAIT_TIMEOUT ]
  then
    echo "timeout"
    exit 1
  fi
done
