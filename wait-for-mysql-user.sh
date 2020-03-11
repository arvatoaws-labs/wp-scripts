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

echo "waiting for mysql server..."
echo "using host $MYSQL_HOST"
echo "using user $MYSQL_USER"
while ! mysqladmin status -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" ; do
  sleep 1
  echo -n .
done
