#!/bin/bash
set -e
#check if APP_STATUS_API and STATUS_API_KEY are not empty
if [[ -n "$VERSIONS_API_ENDPOINT" && -n "$VERSIONS_API_KEY" ]]; then
  
# Detect the PHP, WordPress, and Node.js versions
PHP_VERSION=$(php -v | head -n 1 | cut -d ' ' -f 2)
WP_VERSION=$(wp core version --skip-plugins --skip-themes --skip-packages)

 # Determine stage based on WP_ENV
if [[ "$WP_ENV" == "production" ]]; then
    STAGE="prod"
elif [[ "$WP_ENV" == "staging" ]]; then
    STAGE="preprod"
else
    STAGE="unknown"
fi

# Set the JSON payload with versions and other info
JSON_PAYLOAD=$(cat <<EOF
{
    "category": "wordpress",
    "domain": "$WP_FORCE_HOST",
    "stage": "$STAGE",
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
