#!/bin/bash

echo "[PORTAL] Rebuilding module..."

docker stop portal 2>/dev/null
docker rm portal 2>/dev/null

docker build -t portal-image .

docker run -d \
    --name portal \
    -p 8088:80 \
    portal-image

echo "[PORTAL] Rebuild complete"
