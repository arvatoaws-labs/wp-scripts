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

echo "updating admin user settings..."
wp user update $WORDPRESS_USERNAME --user_pass="$WORDPRESS_PASSWORD" --user_email="$WORDPRESS_EMAIL" --skip-email --allow-root
