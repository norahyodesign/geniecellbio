# 작업 TODO / 기능 개발 계획

> 에이전트는 작업 시작 전 이 파일을 읽고, 완료 시 해당 항목을 `[x]`로 업데이트합니다.

---

## 🔴 콘텐츠 — 실제 정보 입력 필요

- [ ] 대표이사 실명 입력 (about.html — 현재: 홍길동)
- [ ] 본사 주소 입력 (index.html, about.html, support.html — 현재: 서울특별시 마포구 월드컵북로 000)
- [ ] 대표 전화번호 입력 (index.html, support.html — 현재: 02-000-0000)
- [ ] CDMO 전화 링크 수정 (cdmo.html — 현재: tel:0212345678)
- [ ] 세포처리시설 전화 입력 (about.html — 현재: 031-000-0000)

---

## 🟡 기능 — 페이지 생성 필요

- [ ] 개인정보처리방침 페이지 생성 및 전 파일 푸터 링크 연결
- [ ] 이용약관 페이지 생성 및 전 파일 푸터 링크 연결

---

## 🟡 SEO

- [ ] Google Search Console 등록 (직접 진행 필요)
- [ ] 네이버 서치어드바이저 등록 (직접 진행 필요)
- [ ] og:image 대표 이미지 추가 (SNS 공유 썸네일)

---

## 🔵 아임웹 이전 (장기)

- [ ] support.html → 아임웹 네이티브 이전
- [ ] about.html → 아임웹 네이티브 이전
- [ ] cdmo.html → 아임웹 네이티브 이전
- [ ] cell-management.html → 아임웹 네이티브 이전
- [ ] cell-facility.html → 아임웹 네이티브 이전
- [ ] index.html → 아임웹 네이티브 이전
- [ ] GitHub Pages → 아임웹 도메인으로 리다이렉트 처리

---

## ✅ 완료

- [x] 파일명 영어로 통일
- [x] jsDelivr CDN 방식으로 전환
- [x] 로컬 개발 서버 스크립트 (serve.sh)
- [x] CDN 로드 상태 테스트 페이지 (test-cdn.html)
- [x] UI/UX 체크리스트 P0/P1 전 항목 반영
- [x] HTML 유효성 0 에러 달성
- [x] tokens.css 디자인 시스템 통합 (index.html 포함)
- [x] SVG 스프라이트 symbol/use 패턴 적용
- [x] Google Fonts 비차단 로딩 (preload)
- [x] Hero 비디오 webm 우선 + poster 이미지
- [x] 접근성 — focus-visible, prefers-reduced-motion, ARIA 전 파일
- [x] pre-commit hook 자동 검사 (HTML 유효성·보안·플레이스홀더)
- [x] header/main 시맨틱 태그 전 파일 추가
- [x] SEO 메타태그 (description, og:title, og:description) 전 파일
- [x] favicon.svg 생성 및 연결
- [x] og:url + canonical 전 파일 추가
- [x] robots.txt + sitemap.xml 생성
- [x] 모바일 UX — tab-nav 스크롤, 버튼 :active, 드로어 바깥 탭 닫기
- [x] .claude worktree submodule 제거 (GitHub Pages 빌드 오류 수정)
