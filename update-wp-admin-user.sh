#!/bin/bash
set -e

cd /app

if [ "$WORDPRESS_USERNAME" = "" ]
then
   echo "please define WORDPRESS_USERNAME"
   exit 1
fi

if [ "$WORDPRESS_PASSWORD" = "" ]
then
   echo "please define WORDPRESS_PASSWORD"
   exit 1
fi

if [ "$WORDPRESS_EMAIL" = "" ]
then
   echo "please define WORDPRESS_EMAIL"
   exit 1
fi

echo "create admin user if not exists otherwise update admin user..."
wp user list --field=user_login | grep "$WORDPRESS_USERNAME" && wp user update $WORDPRESS_USERNAME --user_pass="$WORDPRESS_PASSWORD" --user_email="$WORDPRESS_EMAIL" --skip-email --allow-root || wp user create "$WORDPRESS_USERNAME" "$WORDPRESS_EMAIL" --role=administrator --user_pass="$WORDPRESS_PASSWORD"