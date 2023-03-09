#!/bin/bash
set -e
#check if APP_STATUS_API and STATUS_API_KEY are not empty
if [[ -n "$APP_STATUS_API" && -n "$STATUS_API_KEY" ]]; then
  
WP_PROJECT=$(echo "$HOSTNAME" | cut -d'-' -f1-2)
# Detect the PHP, WordPress, and Node.js versions
PHP_VERSION=$(php -v | head -n 1 | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
WP_VERSION=$(wp core version --skip-plugins --skip-themes --skip-packages | cut -d '.' -f 1,2)

# Set the JSON payload with versions and other info
JSON_PAYLOAD=$(cat <<EOF
{
    "category": "wordpress",
    "project": "$WP_PROJECT",
    "domain": "$WP_FORCE_HOST",
    "products": [
        {
            "name": "php",
            "version": "$PHP_VERSION"
        },
        {
            "name": "wordpress",
            "version": "$WP_VERSION"
        }
    ]
}
EOF
)
# echo $JSON_PAYLOAD
#   Send the HTTP POST request with curl
curl -X POST \
     -H "Content-Type: application/json" \
     -H "x-api-key: $STATUS_API_KEY" \
     -d "$JSON_PAYLOAD" \
        "$STATUS_API_ENDPOINT"
else
  wp core version --extra
fi