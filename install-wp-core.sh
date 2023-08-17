#!/bin/bash
set -e

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

if [ "$WORDPRESS_BLOGURL" = "" ]
then
   echo "please define WORDPRESS_BLOGURL"
   exit 1
fi

if [ "$WORDPRESS_BLOGNAME" = "" ]
then
   echo "please define WORDPRESS_BLOGNAME"
   exit 1
fi

if [ "$WORDPRESS_EMAIL" = "" ]
then
   echo "please define WORDPRESS_BLOGNAME"
   exit 1
fi

echo "installing wp core if necessary..."
wp core is-installed --allow-root || wp core install --url="$WORDPRESS_BLOGURL" --title="$WORDPRESS_BLOGNAME" --admin_user="$WORDPRESS_USERNAME" --admin_password="$WORDPRESS_PASSWORD" --admin_email="$WORDPRESS_EMAIL" --skip-email --allow-root
