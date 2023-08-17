#!/bin/bash
set -e

echo "updating wp core database if necessary..."
wp core update-db --allow-root
