#!/bin/bash

echo "[PORTAL] Stopping module..."

docker stop portal 2>/dev/null
docker rm portal 2>/dev/null

echo "[PORTAL] Module stopped"
