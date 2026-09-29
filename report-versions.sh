#!/bin/bash
set -e
#check if APP_STATUS_API and STATUS_API_KEY are not empty
if [[ -n "$VERSIONS_API_ENDPOINT" && -n "$VERSIONS_API_KEY" ]]; then
  
# Detect the PHP and WordPress versions
PHP_VERSION=$(php -v | head -n 1 | cut -d ' ' -f 2)
WP_VERSION=$(wp core version --skip-plugins --skip-themes --skip-packages)
# Plugins must load so their update checks run. --skip-plugins omits those results.
PLUGINS_JSON=$(wp plugin list --format=json --fields=name,title,status,update,version,update_version --skip-themes --skip-packages)
# NGINX_VERSION is injected as an env var from the nginx image tag,
# since the nginx binary is not present in this container.

 # Determine stage based on WP_ENV
if [[ "$WP_ENV" == "production" ]]; then
    STAGE="prod"
elif [[ "$WP_ENV" == "staging" ]]; then
    STAGE="preprod"
elif [[ "$WP_ENV" == "development" ]]; then
    STAGE="dev"
else
    STAGE="unknown"
fi

# Set the JSON payload with versions and other info
JSON_PAYLOAD=$(
  PHP_VERSION="$PHP_VERSION" \
  WP_VERSION="$WP_VERSION" \
  NGINX_VERSION="$NGINX_VERSION" \
  WP_FORCE_HOST="$WP_FORCE_HOST" \
  STAGE="$STAGE" \
  PLUGINS_JSON="$PLUGINS_JSON" \
  php -r '
    $plugins = json_decode(getenv("PLUGINS_JSON") ?: "[]", true);
    if (!is_array($plugins)) {
        fwrite(STDERR, "wp plugin list did not return a JSON array\n");
        exit(1);
    }
    echo json_encode([
        "category" => "wordpress",
        "domain" => (string) getenv("WP_FORCE_HOST"),
        "stage" => (string) getenv("STAGE"),
        "products" => [
            ["name" => "php", "version" => (string) getenv("PHP_VERSION")],
            ["name" => "wordpress", "version" => (string) getenv("WP_VERSION")],
            ["name" => "nginx", "version" => (string) getenv("NGINX_VERSION")],
        ],
        "plugins" => $plugins,
    ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
  '
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
  echo "nginx $NGINX_VERSION"
fi
