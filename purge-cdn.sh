#!/bin/bash
# jsDelivr CDN 캐시 퍼지 스크립트
# 사용법: ./purge-cdn.sh

REPO="norahyodesign/geniecellbio"
BRANCH="main"
BASE_URL="https://purge.jsdelivr.net/gh/${REPO}@${BRANCH}"

FILES=(
  "01_menu.html"
  "02_hero.html"
  "03_about.html"
  "04_services.html"
  "05_pipeline.html"
  "06_contact.html"
  "07_footer.html"
  "index.html"
)

echo ""
echo "🚀 jsDelivr CDN 캐시 퍼지 시작"
echo "   리포지토리: ${REPO}@${BRANCH}"
echo ""

SUCCESS=0
FAIL=0

for FILE in "${FILES[@]}"; do
  URL="${BASE_URL}/${FILE}"
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
  if [ "$HTTP_CODE" = "200" ]; then
    echo "  ✅  ${FILE}"
    ((SUCCESS++))
  else
    echo "  ❌  ${FILE}  (HTTP ${HTTP_CODE})"
    ((FAIL++))
  fi
done

echo ""
echo "완료: ✅ ${SUCCESS}개 성공 / ❌ ${FAIL}개 실패"
echo ""
