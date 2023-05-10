#!/bin/bash
set -e
#check if APP_STATUS_API and STATUS_API_KEY are not empty
if [[ -n "$VERSIONS_API_ENDPOINT" && -n "$VERSIONS_API_KEY" ]]; then
  
# Detect the PHP, WordPress, and Node.js versions
PHP_VERSION=$(php -v | head -n 1 | cut -d ' ' -f 2)
WP_VERSION=$(wp core version --skip-plugins --skip-themes --skip-packages)

# Set the JSON payload with versions and other info
JSON_PAYLOAD=$(cat <<EOF
{
    "category": "wordpress",
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
    --max-time 3 \
    --retry 3 \
    --retry-all-errors \
    --retry-delay 3 \
    --retry-max-time 18 \
    -H "Content-Type: application/json" \
    -H "x-api-key: $VERSIONS_API_KEY" \
    -d "$JSON_PAYLOAD" \
       "$VERSIONS_API_ENDPOINT"
else
  wp core version --extra
  php -v
fi
