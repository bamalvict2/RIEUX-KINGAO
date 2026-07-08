#!/bin/bash

echo "🔧 Rebuild de l'image EPARVIER METIER..."

cd ../../modules/eparvier-metier

docker build -t eparvier-metier:latest .

echo "✅ Image EPARVIER METIER rebuild."
