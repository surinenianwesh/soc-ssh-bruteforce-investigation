#!/bin/bash

# SSH failed-login detection
# Checks the most recent five minutes

THRESHOLD=5

COUNT=$(sudo journalctl -u ssh \
    --since "5 minutes ago" \
    --no-pager | grep -c "Failed password")

echo "SSH Failed-Login Detection"
echo "--------------------------"
echo "Time window: Last 5 minutes"
echo "Failed SSH attempts: $COUNT"
echo "Alert threshold: $THRESHOLD"

if [ "$COUNT" -ge "$THRESHOLD" ]; then
    echo "ALERT: SSH failed-login threshold reached"
else
    echo "NO ALERT: Below threshold"
fi
