#!/usr/bin/env bash
set -e

# Usage:
#   export JENKINS_URL="https://your-public-domain.ngrok-free.app"
#   ./setup-webhook.sh
# OR:
#   ./setup-webhook.sh https://your-public-domain.ngrok-free.app

TARGET_URL="${1:-$JENKINS_URL}"

if [ -z "$TARGET_URL" ]; then
    echo "================================================================="
    echo "Error: Public Jenkins URL not specified."
    echo ""
    echo "GitHub requires a publicly reachable URL (not localhost)."
    echo ""
    echo "1. Start your tunnel (e.g. ngrok http 8080)"
    echo "2. Export your public URL:"
    echo "     export JENKINS_URL=\"https://<your-subdomain>.ngrok-free.app\""
    echo "3. Run this script:"
    echo "     ./setup-webhook.sh"
    echo "================================================================="
    exit 1
fi

# Format URL ensuring proper /github-webhook/ endpoint
CLEAN_URL="${TARGET_URL%/}"
if [[ "$CLEAN_URL" != */github-webhook ]]; then
    FINAL_WEBHOOK_URL="${CLEAN_URL}/github-webhook/"
else
    FINAL_WEBHOOK_URL="${CLEAN_URL}/"
fi

echo "Registering GitHub webhook for repository P20000/java-hello-world..."
echo "Webhook target: ${FINAL_WEBHOOK_URL}"

gh api repos/P20000/java-hello-world/hooks \
  -f name=web \
  -F "active=true" \
  -F "events[]=push" \
  -F "config[url]=${FINAL_WEBHOOK_URL}" \
  -F "config[content_type]=json"

echo ""
echo "Webhook registered successfully on P20000/java-hello-world!"
