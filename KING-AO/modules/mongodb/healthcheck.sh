#!/bin/bash
docker exec mongodb mongo --eval "db.runCommand({ ping: 1 })"
