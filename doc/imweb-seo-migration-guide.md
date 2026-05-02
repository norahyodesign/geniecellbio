# 아임웹 SEO 전환 가이드

> 현재 상태: 아임웹 사이트 완성 + 결제 완료  
> 목표: Google·네이버 검색 노출 최적화, 향후 GitHub Pages → 아임웹 완전 이전

---

## 현재 구조의 SEO 한계

```
사용자 접속
  └── 아임웹 도메인
        └── iframe → GitHub Pages (실제 콘텐츠)
```

Google은 **iframe 안의 콘텐츠를 부모 페이지로 인식하지 않습니다.**  
지금은 아임웹 도메인이 아닌 GitHub Pages URL이 검색에 노출됩니다.  
→ 향후 아임웹 네이티브 페이지로 이전해야 검색 효과가 온전히 발휘됩니다.

---

## Step 1 — 아임웹 페이지별 SEO 설정

아임웹 관리자 → **페이지 관리** → 각 페이지 → **SEO 설정**

| 페이지 | 타이틀 | 설명 |
|--------|--------|------|
| 메인 | 지니셀바이오 \| 첨단바이오의약품 CDMO | 첨단바이오의약품 CDMO, 인체세포등 관리업, 세포처리시설 전문기업. GMP 기준 세포치료제 위탁개발·생산·인허가 원스톱 서비스. |
| CDMO | CDMO 서비스 \| 지니셀바이오 | 첨단바이오의약품 위탁개발·GMP 생산·품질시험·인허가 컨설팅 원스톱 CDMO 서비스. |
| 인체세포등 관리업 | 인체세포등 관리업 \| 지니셀바이오 | 첨단재생바이오법 기준 원료세포 수급, 안전성 검증, 자가세포 장기 보관 서비스. |
| 세포처리시설 | 세포처리시설 \| 지니셀바이오 | 투여용 인체세포 공급, 의료기관 위탁생산(CMO), 치료계획서 작성 지원 서비스. |
| 회사소개 | 회사소개 \| 지니셀바이오 | 첨단재생바이오의약품 분야 전문 CDMO 기업, 지니셀바이오의 인사말·회사 개요·핵심 가치·연혁·오시는 길. |
| 고객지원 | 고객지원 \| 지니셀바이오 | CDMO, 인체세포 관리업, 세포처리시설 관련 FAQ 및 상담 문의. |

---

## Step 2 — 도메인 연결

아임웹 관리자 → **설정 → 도메인 관리**

- 커스텀 도메인 있으면 연결 (`genicellbio.com` 등)
- 없으면 아임웹 기본 도메인(`xxx.imweb.me`)으로 우선 진행
- ⚠️ 커스텀 도메인이 있어야 Search Console 등록이 실질적 효과 있음

---

## Step 3 — Google Search Console 등록

1. [search.google.com/search-console](https://search.google.com/search-console) 접속
2. **URL prefix** → 아임웹 사이트 주소 입력
3. 인증 방법: **HTML 메타태그** 선택 → 아래 형식의 코드 복사
   ```html
   <meta name="google-site-verification" content="XXXXXXX" />
   ```
4. 아임웹 관리자 → **설정 → SEO → 검색엔진 인증 → Google**  
   `content=""` 안의 값만 붙여넣기 → 저장
5. Search Console로 돌아가서 **확인** 클릭

---

## Step 4 — 사이트맵 제출

아임웹은 sitemap을 자동 생성합니다.

1. Search Console 좌측 → **Sitemaps**
2. 아래 URL 형식으로 제출:
   ```
   https://[아임웹도메인]/sitemap.xml
   ```

---

## Step 5 — 네이버 서치어드바이저 (한국 타겟 필수)

1. [searchadvisor.naver.com](https://searchadvisor.naver.com) 접속
2. 사이트 등록 → 아임웹 도메인 입력
3. **HTML 태그** 인증 방식 선택 → 태그 복사
4. 아임웹 SEO 설정 → 네이버 인증란에 붙여넣기 → 저장
5. 서치어드바이저 → 사이트맵 제출 (`https://[도메인]/sitemap.xml`)

---

## 향후 — GitHub Pages → 아임웹 완전 이전

### 이전 순서 (권장)

```
1. support.html      → 아임웹 폼 위젯 활용 가능, 가장 쉬움
2. about.html        → 텍스트 중심, 비교적 단순
3. cdmo.html         → 서비스 핵심 페이지, 신중하게
4. cell-management.html
5. cell-facility.html
6. index.html        → Hero 영상 포함, 마지막에
```

### 아임웹 이전 방식 선택

| 방식 | 설명 | 권장 |
|------|------|------|
| **HTML 위젯** | 섹션별로 HTML 코드 위젯에 붙여넣기 | 빠르지만 유지보수 어려움 |
| **아임웹 네이티브** | 텍스트·이미지·버튼 위젯으로 재구성 | SEO 최적, 장기적으로 권장 |

### 이전 전 확정 필요 항목

현재 코드에 플레이스홀더로 남아있는 정보:

| 항목 | 현재 값 | 확정 필요 |
|------|--------|----------|
| 대표이사 | 홍길동 | 실명 |
| 본사 주소 | 서울특별시 마포구 월드컵북로 000 | 실제 주소 |
| 대표 전화 | 02-000-0000 | 실제 번호 |
| 세포처리시설 전화 | 031-000-0000 | 실제 번호 |

### 이전 완료 후 SEO 전환 처리

1. **아임웹 각 페이지 SEO 재설정** (Step 1 반복)
2. **Search Console** → 새 URL 구조로 재등록 + 구 URL 삭제 요청
3. **GitHub Pages에 리다이렉트 추가** (구 URL 방문자 보호)

   각 GitHub Pages HTML 파일 `<head>` 상단에:
   ```html
   <meta http-equiv="refresh" content="0; url=https://[아임웹도메인]/cdmo">
   <script>window.location.replace('https://[아임웹도메인]/cdmo');</script>
   ```

---

## 검색 노출 확인 방법

| 방법 | 설명 |
|------|------|
| `site:` 연산자 | Google 검색창에 `site:[도메인]` 입력 → 색인된 페이지 수 확인 |
| Search Console Coverage | 색인 상태, 오류 페이지 상세 확인 |
| [opengraph.xyz](https://www.opengraph.xyz) | SNS 공유 시 미리보기 확인 |
| [metatags.io](https://metatags.io) | Google·SNS 검색 결과 미리보기 |

> ⚠️ 새 사이트는 크롤링까지 **2~4주** 소요됩니다.
