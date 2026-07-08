#!/bin/bash

echo "[PORTAL] Healthcheck..."

curl -s http://localhost:8088 >/dev/null

if [ $? -eq 0 ]; then
    echo "[PORTAL] OK - Portal is responding"
else
    echo "[PORTAL] ERROR - Portal is not responding"
fi
