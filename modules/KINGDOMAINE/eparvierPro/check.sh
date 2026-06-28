#!/bin/bash

echo "🔍 EPARVIER PRO — Vérification des services"

echo "📡 solaizeapi :"
docker ps | grep solaizeapi

echo "🖥️ solaizecockpit :"
docker ps | grep solaizecockpit

echo "🗄️ mongo_eparvier :"
docker ps | grep mongo_eparvier

echo "✔ Vérification terminée."
