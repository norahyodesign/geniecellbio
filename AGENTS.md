# 지니셀바이오 AI 에이전트 지침

이 파일은 Claude, GitHub Copilot 등 AI 도구가 이 프로젝트를 일관되게 유지·관리하기 위한 공통 지침입니다.

---

## 섹션 파일 규칙

섹션 HTML 파일은 아래 네이밍 규칙을 따릅니다.

```
NN_name.html
```

- `NN`: 2자리 숫자 (순서/렌더 순서 결정)
- `name`: 영문 소문자, 언더스코어 허용

**현재 섹션 파일 목록** (렌더 순서):

| 파일 | 설명 | CDN 퍼지 대상 |
|------|------|:---:|
| `01_menu.html` | 메뉴/네비게이션 | ✅ |
| `02_hero.html` | 히어로 배너 | ✅ |
| `03_about.html` | 회사소개 | ✅ |
| `04_services.html` | 서비스 | ✅ |
| `05_pipeline.html` | 파이프라인 | ✅ |
| `06_contact.html` | 문의하기 | ✅ |
| `07_footer.html` | 푸터 | ✅ |

> `05_pipeline.html`은 현재 `index.html` / `test-cdn.html` / `iweb_template.html`에서 **로드하지 않음** (준비 중). 추가 시 아래 지침을 따를 것.

---

## 파일 추가 시 업데이트 체크리스트

섹션 파일(`NN_name.html`)을 **새로 추가**할 때 반드시 아래 5곳을 모두 업데이트합니다.

### 1. `README.md` — 파일 구조 트리

`## 파일 구조` 블록의 섹션 파일 목록에 번호 순서에 맞게 한 줄 추가합니다.

```
├── NN_name.html        # 섹션 설명
```

### 2. `purge-cdn.sh` — FILES 배열

`FILES=(` 블록 안에 번호 순서에 맞게 추가합니다.

```bash
  "NN_name.html"
```

### 3. `index.html` — files 배열

```js
const files = ['01_menu','02_hero', ... ,'NN_name'];
```

배열에 **확장자 없이** 파일명(prefix)을 번호 순서대로 추가합니다.

### 4. `test-cdn.html` — sections 배열 + 상태 패널

**sections 배열** (script 내부):
```js
{ file: 'NN_name.html', id: 'name' },
```

**상태 패널** (html 내부 `#cdn-status` div):
```html
<span id="s-name" class="loading">⏳ NN_name</span><br>
```

두 곳 모두 번호 순서에 맞게 추가합니다.

### 5. `iweb_template.html` — fetch 블록

기존 블록 번호(`block-NN`) 뒤에 추가합니다. `block-NN` 번호는 목록에서의 **순번**(섹션 파일 번호가 아닌 노출 순서)을 사용합니다.

```html
<!-- 섹션 N: 설명 -->
<div id="block-NN"></div>
<script>
fetch('https://cdn.jsdelivr.net/gh/norahyodesign/geniecellbio@main/NN_name.html')
  .then(r => r.text())
  .then(html => document.getElementById('block-NN').innerHTML = html);
</script>
```

---

## 파일 삭제 시 업데이트 체크리스트

추가와 반대 방향으로 위 5곳에서 해당 항목을 제거합니다.  
`iweb_template.html`의 `block-NN` 번호는 삭제 후 나머지를 재번호 매기지 않아도 됩니다(gap 허용).

---

## 파일 이름 변경 시

- 위 5곳에서 구 파일명을 모두 신 파일명으로 교체합니다.
- `test-cdn.html`의 `id` 속성도 새 이름에 맞게 변경합니다.

---

## 비섹션 파일 추가 시

`NN_` prefix가 없는 파일(도구, 문서, 스크립트 등)은 `README.md`의 파일 구조 트리 **상단 블록**에만 추가합니다. 나머지 4곳은 수정 불필요.

---

## CDN 정보

| 항목 | 값 |
|------|-----|
| 리포지토리 | `norahyodesign/geniecellbio` |
| 브랜치 | `main` |
| CDN Base URL | `https://cdn.jsdelivr.net/gh/norahyodesign/geniecellbio@main/` |
| Purge Base URL | `https://purge.jsdelivr.net/gh/norahyodesign/geniecellbio@main/` |

---

## 작업 흐름

```
섹션 파일 생성/삭제
  → 위 체크리스트 5곳 업데이트
  → ./serve.sh 로 로컬 확인
  → git add . && git commit && git push
  → ./purge-cdn.sh 실행
  → test-cdn.html 에서 CDN 확인
```
