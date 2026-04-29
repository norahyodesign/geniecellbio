#!/bin/bash
cd "$(dirname "$0")"
echo ""
echo "🌐 로컬 테스트  → http://localhost:8080/index.html"
echo "📡 CDN  테스트  → http://localhost:8080/test-cdn.html"
echo ""
open "http://localhost:8080/index.html"
python3 -m http.server 8080
