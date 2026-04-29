# 지니셀바이오 AI 에이전트 지침

이 파일은 Claude, GitHub Copilot 등 AI 도구가 이 프로젝트를 일관되게 유지·관리하기 위한 공통 지침입니다.

---

## 현재 아키텍처

프로젝트는 **두 가지 레이어**로 구성됩니다.

| 레이어 | 파일 | 용도 |
|--------|------|------|
| **메인 사이트** | `index.html` | 단일 HTML 파일, 4개 scroll-snap 섹션 완전 내장 |
| **iWeb CDN 연동** | `01_menu.html` ~ `07_footer.html` + `iweb_template.html` | 아임웹에 삽입하는 CDN 방식 |

> `index.html`은 섹션 파일을 fetch하지 않습니다. 모든 섹션(S1~S4)이 파일 안에 직접 작성되어 있습니다.

---

## index.html 섹션 구조

`index.html`은 scroll-snap 레이아웃으로 아래 4개 섹션을 포함합니다.

| ID | 내용 |
|----|------|
| `#s1` | Hero — MP4 영상 배경, 타이틀, CTA |
| `#s2` | About — 회사 소개, 개발 4단계 스텝 카드 |
| `#s3` | Services — CDMO·인체세포관리업·세포처리시설 카드 |
| `#s4` | Contact — 문의 CTA, 연락처, 푸터 |

`index.html`을 수정할 때는 섹션 파일을 건드릴 필요가 없습니다.

---

## CDN 섹션 파일 목록 (iWeb 연동용)

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
| `06_contact.html` | 문의하기 | ✅ |
| `07_footer.html` | 푸터 | ✅ |

> `05_pipeline.html`은 제거됨 (PDF 근거 없음). CDN 파일 목록 및 `iweb_template.html`에서도 제외된 상태.

---

## index.html 섹션 수정 시

`index.html` 안의 S1~S4를 직접 편집합니다. 다른 파일은 수정 불필요.

---

## CDN 섹션 파일 추가 시 업데이트 체크리스트

섹션 파일(`NN_name.html`)을 **iWeb CDN용으로 새로 추가**할 때 아래 4곳을 업데이트합니다.  
(`index.html`은 self-contained이므로 별도 수정 불필요)

### 1. `README.md` — 파일 구조 트리

`## 파일 구조` 블록의 섹션 파일 목록에 번호 순서에 맞게 추가합니다.

```
├── NN_name.html        # 섹션 설명
```

### 2. `purge-cdn.sh` — FILES 배열

`FILES=(` 블록 안에 번호 순서에 맞게 추가합니다.

```bash
  "NN_name.html"
```

### 3. `test-cdn.html` — sections 배열 + 상태 패널

**sections 배열** (script 내부):
```js
{ file: 'NN_name.html', id: 'name' },
```

**상태 패널** (html 내부 `#cdn-status` div):
```html
<span id="s-name" class="loading">⏳ NN_name</span><br>
```

두 곳 모두 번호 순서에 맞게 추가합니다.

### 4. `iweb_template.html` — fetch 블록

기존 블록 번호(`block-NN`) 뒤에 추가합니다.

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

## CDN 섹션 파일 삭제 시 업데이트 체크리스트

위 4곳에서 해당 항목을 제거합니다.  
`iweb_template.html`의 `block-NN` 번호는 재번호 매기지 않아도 됩니다(gap 허용).

---

## 파일 이름 변경 시

- 위 4곳에서 구 파일명을 모두 신 파일명으로 교체합니다.
- `test-cdn.html`의 `id` 속성도 새 이름에 맞게 변경합니다.

---

## 비섹션 파일 추가 시

`NN_` prefix가 없는 파일(도구, 문서, 스크립트, 에셋 등)은 `README.md`의 파일 구조 트리 상단 블록에만 추가합니다. 나머지 4곳은 수정 불필요.

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

### index.html (메인 사이트) 수정 시

```
index.html 직접 편집
  → serve.sh 로 로컬 확인
  → git add . && git commit && git push
```

### CDN 섹션 파일 (iWeb 연동) 수정 시

```
NN_name.html 편집 + 위 체크리스트 4곳 업데이트
  → serve.sh 로 로컬 확인 (test-cdn.html 에서 CDN 확인)
  → git add . && git commit && git push
  → ./purge-cdn.sh 실행
  → test-cdn.html 에서 CDN 확인
```
