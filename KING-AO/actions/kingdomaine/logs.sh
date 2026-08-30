#!/bin/bash
echo "📜 KINGDOMAINE — logs"

docker logs kingdomaine-api -f
docker logs kingdomaine-cockpit -f
