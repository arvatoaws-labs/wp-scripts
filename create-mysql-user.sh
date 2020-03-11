#!/bin/bash
set -e

if [ -n "$DB_HOST" ]; then
  MYSQL_HOST=$DB_HOST
fi
if [ -n "$DB_NAME" ]; then
  MYSQL_DATABASE=$DB_NAME
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

if [ "$MYSQL_ROOT_PASSWORD" = "" ]
then
  echo "skipping database user creation because of missing root password"
else
  mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -se"GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* To '$MYSQL_USER' IDENTIFIED BY '$MYSQL_PASSWORD';"
fi
