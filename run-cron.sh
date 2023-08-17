#!/bin/bash
set -e

/scripts/sleep.sh

/scripts/wait-for-mysql-user.sh

echo "running wp cronjobs..."
wp cron event run --due-now