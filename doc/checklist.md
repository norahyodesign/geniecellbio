
# UI/UX 개선 체크리스트

검토일: 2026-05-02  
검토 기준 파일: `index.html`, `tokens.css`, `about.html`, `support.html`, `cdmo.html`, `cell-management.html`, `cell-facility.html`

우선순위 기준

- `P0`: 즉시 수정. 탐색, 전환, 신뢰에 직접 손실이 나는 항목
- `P1`: 이번 개선 사이클에서 처리. 사용성 품질을 눈에 띄게 끌어올리는 항목
- `P2`: 다음 사이클에서 구조적으로 정리. 누적되면 품질 저하를 만드는 항목

## 핵심 요약

- 랜딩 핵심 동선에 실제로 막히는 링크 이슈가 있습니다.
- 회사 신뢰를 깎는 플레이스홀더 정보와 페이지 간 정보 불일치가 남아 있습니다.
- 내비게이션과 인터랙션이 마우스 중심으로 설계되어 키보드, 모바일, 접근성 대응이 약합니다.
- 메인 페이지는 시각적으로 강하지만 `mandatory scroll-snap`과 강한 모션 때문에 정보 탐색 효율이 떨어집니다.
- 디자인 시스템은 `tokens.css`로 정리되어 있지만, 메인 페이지가 별도 스타일을 크게 중복 보유해 일관성 관리가 어려운 상태입니다.

## 1. 내비게이션 / IA

- [ ] `P0` 메인 서비스 카드 2개가 상세 페이지로 연결되지 않음  
  근거: `index.html`의 두 번째, 세 번째 서비스 카드 버튼이 `href="#"`로 남아 있습니다.  
  의견: 서비스 소개 섹션은 사용자의 탐색 의도가 가장 높은 구간입니다. 여기서 링크가 막히면 브랜드 인상보다 먼저 "아직 덜 완성된 사이트"라는 인식이 생깁니다.  
  권장 조치: `cell-management.html`, `cell-facility.html`로 바로 연결하고 카드 전체를 클릭 가능 영역으로 확장합니다.

- [ ] `P1` 데스크톱 글로벌 내비게이션이 hover 중심이라 키보드 탐색과 터치 대응이 약함  
  근거: `tokens.css`, `index.html` 모두 드롭다운 노출이 `.nav-item:hover .nav-drop`에 의존하고 있습니다.  
  의견: B2B 사이트의 상단 메뉴는 "예쁘게 열리는 것"보다 "예측 가능하게 열리는 것"이 우선입니다. 현재 구조는 마우스 사용자에게만 최적화돼 있습니다.  
  권장 조치: 클릭 토글, `aria-expanded`, `aria-controls`, `Escape` 닫기, 외부 클릭 닫기를 공통 컴포넌트처럼 붙입니다.

- [ ] `P1` 모바일 드로어가 최소 기능만 있어 실제 사용성이 낮음  
  근거: 모든 페이지의 햄버거 버튼이 인라인 `onclick`으로 `open` 클래스만 토글하며, 오버레이, 닫기 버튼, 포커스 트랩, 배경 스크롤 잠금이 없습니다.  
  의견: 모바일 메뉴는 "보인다"가 아니라 "제어된다"가 중요합니다. 지금 구조는 레이어는 뜨지만 인터랙션 계약이 완성되지 않았습니다.  
  권장 조치: 드로어 오버레이, 닫기 버튼, `body` 스크롤 잠금, 포커스 이동, `Escape` 처리까지 포함해 패턴을 완성합니다.

- [ ] `P1` 메인 페이지의 `mandatory scroll-snap`이 정보 탐색을 강하게 제한함  
  근거: `index.html`에서 `#snap`은 `scroll-snap-type: y mandatory`, 각 섹션은 `100dvh` 고정입니다.  
  의견: 브랜드 쇼케이스 관점에서는 인상적이지만, 바이오 B2B 사용자는 비교적 빨리 훑고 필요한 정보를 찾고 싶어합니다. 현재 구조는 감상형 경험에 치우쳐 있습니다.  
  권장 조치: `proximity`로 완화하거나 모바일에서만 일반 스크롤로 전환하고, 각 섹션 내부 정보 밀도를 더 유연하게 구성합니다.

- [ ] `P2` 탭 내비게이션이 좁은 화면에서 넘칠 가능성이 큼  
  근거: `tokens.css`의 `.tab-nav-inner`는 중앙 정렬 고정이고, `.tab-item`은 `white-space: nowrap`이며 가로 스크롤 처리 코드가 없습니다.  
  의견: 현재 텍스트 길이 기준으로 `support.html`은 버틸 수 있어도 `cdmo.html`처럼 긴 탭 라벨은 작은 모바일에서 금방 답답해집니다.  
  권장 조치: 모바일에서는 탭 바를 가로 스크롤 가능한 pill 리스트로 바꾸고, 첫 진입 시 현재 탭이 중앙에 오도록 처리합니다.

- [ ] `P1` 메인 로고 링크 경로가 서브페이지와 달라 배포 환경에 따라 혼란 가능성이 있음  
  근거: `index.html`의 로고는 `href="/"`, 서브페이지는 `href="index.html"`을 사용합니다.  
  의견: 정적 사이트, CDN, iframe 삽입 환경에서는 루트 경로가 의도와 다르게 동작할 수 있습니다. 내비게이션은 환경별 운에 맡기면 안 됩니다.  
  권장 조치: 모든 페이지의 홈 링크 정책을 하나로 통일합니다.

## 2. 접근성 / 인터랙션

- [ ] `P1` 글로벌 포커스 스타일이 사실상 부재함  
  근거: `tokens.css`와 `index.html`에서 버튼, 링크, 내비, 카드에 대한 `:focus` 또는 `:focus-visible` 스타일이 거의 없고, 폼 필드만 일부 포커스 표시가 있습니다.  
  의견: 키보드 사용자는 현재 어디에 포커스가 있는지 추적하기 어렵습니다. 접근성 문제이면서 동시에 조작 신뢰도 문제입니다.  
  권장 조치: 링크, 버튼, 탭, 카드 CTA, 상단 메뉴에 공통 `focus-visible` 링을 추가합니다.

- [ ] `P1` 모션 강도가 높지만 `prefers-reduced-motion` 대응이 없음  
  근거: `index.html`에는 `fadeUp`, `scrollDot`, `ringPulse`, `orbPulse`, hover 이동, smooth scroll이 다수 존재하지만 모션 축소 미디어 쿼리가 없습니다.  
  의견: 현재 모션은 브랜드 톤을 살리는 데는 유효합니다. 다만 선택권이 없어서 일부 사용자에게는 피로로 작동할 수 있습니다.  
  권장 조치: `prefers-reduced-motion: reduce`에서 애니메이션, 스크롤 스무딩, 자동 움직임을 최소화합니다.

- [ ] `P1` FAQ, 모바일 메뉴, 탭 상태가 시각적으로만 표현되고 의미론적 상태 전달이 부족함  
  근거: `support.html`의 FAQ 버튼은 `aria-expanded`가 없고, 모바일 드로어 토글도 상태 속성이 없으며, 탭 활성화 역시 `aria-selected` 없이 클래스만 바뀝니다.  
  의견: 화면에는 열림과 닫힘이 보이지만, 보조기기에는 거의 전달되지 않습니다. "작동"과 "설명되는 작동"은 다릅니다.  
  권장 조치: FAQ는 아코디언 패턴, 탭은 탭 패턴, 드로어는 메뉴 버튼 패턴에 맞는 ARIA 속성을 추가합니다.

- [ ] `P2` 메인 진행 점 UI가 숫자만 보여 주고 라벨이 없어 해석성이 낮음  
  근거: `index.html`의 `.pdot`는 `1`, `2`, `3`, `4`만 표시하며 섹션 이름을 알 수 있는 텍스트나 접근성 라벨이 없습니다.  
  의견: 내부 구조를 아는 사람에게는 단축키처럼 보이지만, 처음 보는 사용자에게는 의미 없는 숫자입니다.  
  권장 조치: `aria-label`에 섹션명을 넣고, 툴팁 또는 작은 텍스트 라벨을 함께 제공합니다.

- [ ] `P1` 문의 완료 피드백이 `alert`와 단순 박스 노출에 의존함  
  근거: `support.html`은 유효성 오류를 `alert()`로 보여 주고, 성공 메시지는 `div.visible`만 추가하며 `aria-live`가 없습니다.  
  의견: 브라우저 기본 팝업은 흐름을 끊고, 성공 메시지는 스크린리더에 잘 전달되지 않습니다. 폼 경험이 올드하게 느껴집니다.  
  권장 조치: 필드별 인라인 오류와 `aria-live="polite"` 성공 영역으로 교체합니다.

## 3. 신뢰 / 전환

- [ ] `P0` 회사 정보에 플레이스홀더와 페이지 간 불일치가 공존함  
  근거: `about.html`, `support.html`에는 `홍길동`, `02-000-0000`, `000` 주소가 남아 있고, `index.html`의 주소는 `서울시 송파구 충민로 66`으로 서로 다릅니다.  
  의견: 바이오 기업 사이트에서 가장 치명적인 UX는 "멋있지만 믿기 어렵다"입니다. 현재 상태는 바로 그 인상을 줄 수 있습니다.  
  권장 조치: 대표명, 연락처, 주소, 연혁, 시설 위치를 단일 원본 기준으로 정리하고 전 페이지를 동기화합니다.

- [ ] `P0` 문의 폼이 실제 전송이 아니라 `mailto`에 의존하면서 성공 메시지를 먼저 보여 줌  
  근거: `support.html`의 폼 제출은 `window.location.href = mailto:` 방식이며, 메일 앱 실행 여부와 무관하게 성공 박스를 노출합니다.  
  의견: 사용자는 문의가 접수됐다고 믿지만 실제로는 메일 앱이 안 열리거나 발송이 취소될 수 있습니다. 전환 지표를 왜곡하는 구조입니다.  
  권장 조치: 백엔드 없는 상황이라도 Formspree, Basin, Netlify Forms 같은 수신 채널을 붙이고 실제 성공 시점에만 완료 메시지를 보여 줍니다.

- [ ] `P1` 푸터의 정책 링크가 모두 더미 링크임  
  근거: `about.html`, `support.html`, `index.html` 등의 푸터 링크가 `href="#"`입니다.  
  의견: 특히 문의 폼이 있는 사이트에서 개인정보처리방침 링크가 비어 있으면 법무 리스크보다 먼저 신뢰 하락이 발생합니다.  
  권장 조치: 실제 정책 페이지를 만들거나 준비 중이라면 링크 비노출이 낫습니다.

- [ ] `P1` 위치 안내가 실제 지도 경험이 아니라 플레이스홀더 수준에 머물러 있음  
  근거: `about.html`의 위치 섹션은 `map-placeholder` 박스와 넓은 지역 검색 링크만 제공합니다.  
  의견: 방문 예약, 시설 상담이 중요한 업종에서는 길 찾기 정확도가 신뢰의 일부입니다. 현재는 "위치가 있다" 수준이지 "찾아갈 수 있다" 수준은 아닙니다.  
  권장 조치: 실제 주소 기준 지도를 임베드하거나, 최소한 정확한 플레이스 링크와 교통 안내를 제공합니다.

- [ ] `P1` 메인 CTA 섹션의 연락 정보가 다른 페이지와 불일치함  
  근거: `index.html`의 전화번호와 주소가 `about.html`, `support.html`과 다릅니다.  
  의견: 랜딩 마지막 CTA에서 보여 주는 정보는 사용자의 최종 판단 근거입니다. 이 구간의 불일치는 전환 직전 불안을 크게 키웁니다.  
  권장 조치: 연락처 데이터를 공통 소스로 분리하고 모든 페이지에서 재사용합니다.

## 4. 시각 언어 / 디자인 시스템

- [ ] `P1` 메인 페이지가 디자인 시스템을 우회해 별도 스타일을 대량 보유함  
  근거: `index.html`은 `tokens.css`를 로드하지 않고, 동일한 토큰과 컴포넌트 성격의 스타일을 파일 안에 직접 선언합니다.  
  의견: 메인 페이지가 가장 중요할수록 시스템의 예외가 아니라 기준점이 되어야 합니다. 지금 구조는 수정이 쌓일수록 비주얼 드리프트를 부릅니다.  
  권장 조치: 메인 페이지도 `tokens.css`를 기본으로 사용하고, 메인 전용 스타일만 분리합니다.

- [ ] `P2` 내비게이션 마크업과 활성 상태 관리가 페이지별 수작업이라 일관성 리스크가 큼  
  근거: `about.html`, `support.html`, `cdmo.html` 등 각 파일이 거의 동일한 내비를 복붙하고 `is-active`를 개별 관리합니다.  
  의견: 지금 보이는 작은 불일치들은 대부분 이 구조에서 반복적으로 생깁니다. 디자인보다 운영 방식의 문제입니다.  
  권장 조치: 공통 include가 어렵다면 최소한 스크립트로 현재 경로를 읽어 활성 상태를 자동 처리합니다.

- [ ] `P2` `about.html`의 이모지 아이콘이 프리미엄 바이오 브랜드 톤과 다소 어긋남  
  근거: 핵심 가치 카드가 `🔬`, `🤝`, `⚡`, `🌱` 이모지에 의존합니다.  
  의견: 친근함은 생기지만, 현재 사이트 전체가 추구하는 정제된 B2B 톤과는 약간 결이 다릅니다. 특히 투자자나 파트너 관점에서는 가벼워 보일 수 있습니다.  
  권장 조치: 동일한 스트로크 스타일의 SVG 아이콘 세트로 교체합니다.

- [ ] `P2` 페이지 내부에 인라인 스타일이 남아 있어 컴포넌트 일관성이 약해짐  
  근거: `about.html`의 일부 섹션 제목과 간격이 `style="margin-top: ..."` 등으로 직접 제어됩니다.  
  의견: 지금 당장 깨지는 문제는 아니지만, 이런 예외가 늘수록 "왜 여기는 다르지"가 쌓입니다.  
  권장 조치: 간격 유틸리티 또는 전용 섹션 변형 클래스로 정리합니다.

## 5. 빠른 실행 순서 제안

- [ ] 1차 배포 전 즉시 수정: 서비스 카드 링크, 회사 정보 정합성, 문의 폼 접수 방식, 정책 링크
- [ ] 2차 사용성 개선: 내비게이션 토글 구조, 모바일 드로어, 포커스 스타일, FAQ/탭 ARIA
- [ ] 3차 구조 개선: 메인 페이지의 디자인 시스템 통합, 데이터 공통화, 모바일 탭 바 개선, 모션 축소 대응

## 총평

현재 사이트는 시각적 완성도와 브랜드 톤은 이미 일정 수준 이상입니다. 다만 실제 사용성의 병목은 "보이는 디자인"보다 "동작 계약"과 "신뢰 데이터"에서 발생하고 있습니다.  
디자인을 더하는 것보다 먼저, 막힌 링크와 불일치 정보, 접수 신뢰, 내비게이션 제어를 정리하면 UX 체감 품질이 가장 크게 올라갑니다.

## 6. Base Template / Token 적용 현황 표

| 구분 | base template 적용 | token 기반 디자인 적용 | 현재 판단 | 의견 |
|------|--------------------|------------------------|-----------|------|
| `tokens.css` | 해당 없음 | 예 | 정상 | 컬러, 타이포, 버튼, 섹션, 카드, 폼, 탭 내비, 페이지 히어로까지 공통 자산으로 갖고 있어 디자인 시스템의 뼈대는 이미 있습니다. |
| `about.html` | 예 | 예 | 양호 | `page-wrap`, `page-hero`, `tab-nav`, `section`, `cta-section` 흐름이 문서화된 유형 B와 가장 가깝습니다. 통합 페이지의 기준 샘플로 삼기 좋습니다. |
| `support.html` | 예 | 예 | 양호 | `about.html`과 동일한 통합 탭 구조를 따르고 있어 유형 B 베이스 템플릿이 실제 운영되는 사례입니다. 문의 폼 UX는 별도 개선이 필요하지만 템플릿 적용도 자체는 안정적입니다. |
| `cdmo.html` | 부분 적용 | 예 | 보통 | 토큰은 잘 쓰고 있지만 문서상 유형 A와 다르게 글로벌 드롭다운 내비와 별도 탭 내비를 함께 사용합니다. 즉, "서비스 상세용 base template"가 실제 구현에서 변형된 상태입니다. |
| `cell-management.html` | 부분 적용 | 예 | 보통 | 공통 CSS는 잘 타고 있지만 유형 A의 단순 상세 페이지라기보다 탭이 붙은 변형 상세 페이지로 굳어졌습니다. 템플릿 정의와 실제 산출물이 어긋나기 시작한 구간입니다. |
| `cell-facility.html` | 부분 적용 | 예 | 보통 | `cell-management.html`과 같은 패턴입니다. 서비스 상세용 템플릿이 공통 구조로 고정되지 않고 페이지별 커스텀으로 확장되는 징후가 보입니다. |
| `index.html` | 아니오 | 부분 적용 | 예외 | 내부에 별도 `:root`와 공통 컴포넌트 성격의 스타일을 다시 선언합니다. 시각 톤은 맞지만 시스템을 "사용"하는 페이지가 아니라 시스템을 "복제"하는 페이지에 가깝습니다. |

### 적용 현황 해석

- 서브페이지에는 token 기반 디자인이 실질적으로 적용되어 있습니다.
- 다만 base template은 문서상 정의에 비해 실제 구현이 균일하지 않습니다.
- 특히 서비스 상세 페이지군은 동일한 유형 A라기보다 "유사하지만 조금씩 다른 변형"으로 운영되고 있습니다.
- 메인 페이지는 브랜드 기준점이어야 하는데 현재는 공통 시스템의 예외로 존재합니다.

## 7. 메인 포함 통합 Base Template 개편안

### 목표

- 메인 페이지까지 포함해 하나의 디자인 시스템 위에서 모든 페이지가 동작하도록 정리
- 문서에 적힌 유형 A, 유형 B가 실제 소스 구조와 1:1로 대응되도록 정비
- 페이지마다 반복되는 내비, 푸터, 탭, CTA, 상태 스타일을 공통 자산으로 수렴

### 권장 구조

| 레이어 | 역할 | 권장 내용 |
|--------|------|-----------|
| `tokens.css` | 디자인 토큰과 프리미티브 | 컬러, 타이포, spacing, radius, shadow, z-index, transition, breakpoint만 유지 |
| `base.css` | 전역 베이스 템플릿 | reset, body/html, nav, drawer, footer, page-wrap, inner, section, page-hero, tab-nav, button, form, card, CTA |
| `patterns.css` | 재사용 패턴 | timeline, process, FAQ, stats, strengths, service-card, overview-card 같은 중간 단위 패턴 |
| `index.css` | 메인 전용 | scroll-snap, hero video, progress dots, section-specific visual treatment, homepage-exclusive motion |
| 페이지별 inline style 또는 page css | 최소 예외만 허용 | 해당 페이지에서만 필요한 배치 보정이나 특수 비주얼만 유지 |
| `site.js` | 공통 인터랙션 | 모바일 드로어, 드롭다운, 탭 활성화, FAQ 아코디언, active nav, reduced-motion 대응 |

### 추천 HTML 기준안

#### 공통 shell

```html
<body data-page="about" data-template="tabbed-page">
  <nav id="gcb-nav">...</nav>
  <div id="gcb-drawer" class="nav-drawer">...</div>

  <div class="page-wrap">
    <!-- page hero -->
    <!-- optional tab nav -->
    <!-- page sections -->
    <!-- shared cta -->
    <footer class="page-footer">...</footer>
  </div>

  <script src="site.js"></script>
</body>
```

#### 유형 A: 서비스 상세

```html
<body data-page="cdmo" data-template="service-detail">
  <nav id="gcb-nav">...</nav>
  <div class="page-wrap">
    <section class="page-hero">...</section>
    <nav class="tab-nav">...</nav>
    <section class="section">overview</section>
    <section class="section alt">detail</section>
    <section class="section">process</section>
    <section class="section alt">strengths</section>
    <section class="cta-section">...</section>
    <footer class="page-footer">...</footer>
  </div>
</body>
```

#### 유형 B: 통합 탭 페이지

```html
<body data-page="support" data-template="tabbed-page">
  <nav id="gcb-nav">...</nav>
  <div class="page-wrap">
    <section class="page-hero">...</section>
    <nav class="tab-nav">...</nav>
    <section class="tab-section section tab-offset">...</section>
    <section class="tab-section section alt tab-offset">...</section>
    <section class="cta-section">...</section>
    <footer class="page-footer">...</footer>
  </div>
</body>
```

#### 메인 페이지

```html
<body data-page="home" data-template="home-snap">
  <nav id="gcb-nav">...</nav>
  <div id="snap" class="home-snap">
    <section class="home-hero">...</section>
    <section class="section">...</section>
    <section class="section alt">...</section>
    <section class="section section-contact">...</section>
  </div>
  <script src="site.js"></script>
</body>
```

### 개편 원칙

- 메인 페이지도 반드시 `tokens.css`와 공통 base css를 로드합니다.
- 내비게이션 마크업은 모든 페이지에서 동일해야 합니다.
- 푸터, CTA, 버튼, 탭, 카드의 클래스 이름과 상태 클래스는 재정의하지 않고 공통 사용합니다.
- 페이지 안의 `<style>`은 "페이지 고유 레이아웃 보정"만 허용하고, 공통 컴포넌트 재선언은 금지합니다.
- 활성 메뉴, 드로어 토글, 탭 활성화 같은 상태 로직은 HTML마다 따로 쓰지 않고 공통 JS에서 처리합니다.

### 현실적인 실행 순서

- 1단계: `index.html`에서 재선언 중인 토큰과 공통 버튼/내비/레이아웃 스타일을 분리 대상 목록으로 추출
- 2단계: `tokens.css`는 토큰 중심으로 정리하고, 공통 컴포넌트는 `base.css` 또는 `patterns.css`로 이동
- 3단계: `about.html`, `support.html`를 기준 템플릿으로 삼아 shell 마크업을 표준화
- 4단계: `cdmo.html`, `cell-management.html`, `cell-facility.html`를 동일한 서비스 상세 템플릿 구조로 정렬
- 5단계: `index.html`을 공통 shell 위로 올리고 홈 전용 스타일만 남김
- 6단계: 내비, 드로어, 탭, FAQ를 `site.js`로 통합하고 페이지별 인라인 스크립트 제거

### 총 의견

지금 프로젝트는 "디자인 시스템이 없는 상태"가 아니라, "디자인 시스템은 있는데 메인과 상세 페이지들이 각자 조금씩 다르게 운용하는 상태"에 가깝습니다.  
따라서 새로 만드는 것보다, 이미 있는 `tokens.css`와 서브페이지 패턴을 기준으로 메인을 합류시키는 방식이 비용 대비 효과가 가장 좋습니다.