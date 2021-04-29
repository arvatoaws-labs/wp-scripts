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

echo "using wordpress-username $WORDPRESS_USERNAME"
echo "using wordpress-email $WORDPRESS_EMAIL"

echo "create admin user if not exists otherwise update admin user..."
wp user list --field=user_login | grep "$WORDPRESS_USERNAME" && wp user update $WORDPRESS_USERNAME --user_pass="$WORDPRESS_PASSWORD" --user_email="$WORDPRESS_EMAIL" --skip-email --allow-root || wp user create "$WORDPRESS_USERNAME" "$WORDPRESS_EMAIL" --role=administrator --user_pass="$WORDPRESS_PASSWORD"

for number in {2..9}; do

   wp_user="WORDPRESS_USERNAME_$number"
   wp_pass="WORDPRESS_PASSWORD_$number"
   wp_email="WORDPRESS_EMAIL_$number"

   WORDPRESS_USERNAME="${!wp_user}"
   WORDPRESS_PASSWORD="${!wp_pass}"
   WORDPRESS_EMAIL="${!wp_email}"

   if [ "$WORDPRESS_USERNAME" = "" ]
   then
      continue
   fi

   if [ "$WORDPRESS_PASSWORD" = "" ]
   then
      continue
   fi

   if [ "$WORDPRESS_EMAIL" = "" ]
   then
      continue
   fi

   echo "using wordpress-username $WORDPRESS_USERNAME"
   echo "using wordpress-email $WORDPRESS_EMAIL"

   echo "create admin user if not exists otherwise update admin user..."
   wp user list --field=user_login | grep "$WORDPRESS_USERNAME" && wp user update $WORDPRESS_USERNAME --user_pass="$WORDPRESS_PASSWORD" --user_email="$WORDPRESS_EMAIL" --skip-email --allow-root || wp user create "$WORDPRESS_USERNAME" "$WORDPRESS_EMAIL" --role=administrator --user_pass="$WORDPRESS_PASSWORD"

done
exit 0
