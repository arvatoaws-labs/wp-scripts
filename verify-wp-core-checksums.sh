#!/bin/bash
set -e

echo "verifying wp core checksums..."
wp core verify-checksums --allow-root
