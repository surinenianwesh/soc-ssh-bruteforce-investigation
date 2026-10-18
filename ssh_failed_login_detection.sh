#!/bin/bash

# Basic SSH failed-login detection script
# Example threshold: 5 failures in a defined time window

START="2026-10-18 00:05:00"
END="2026-10-18 00:10:00"
THRESHOLD=5

COUNT=$(sudo journalctl -u ssh \
    --since "$START" \
    --until "$END" \
    --no-pager | grep -c "Failed password")

echo "SSH Failed-Login Detection"
echo "--------------------------"
echo "Failed SSH attempts: $COUNT"
echo "Alert threshold: $THRESHOLD"

if [ "$COUNT" -ge "$THRESHOLD" ]; then
    echo "ALERT: SSH failed-login threshold reached"
else
    echo "NO ALERT: Below threshold"
fi
