# 지니셀바이오 AI 에이전트 지침

이 파일은 GitHub Copilot 등 AI 도구가 이 프로젝트를 일관되게 유지·관리하기 위한 공통 지침입니다.

> 동일한 내용이 루트의 `AGENTS.md`에도 존재합니다 (Claude 등 다른 AI 도구용).

---

## 현재 아키텍처

프로젝트는 **단일 파일** 구조입니다.

| 파일 | 용도 |
|------|------|
| `index.html` | 메인 사이트 — 4개 scroll-snap 섹션 완전 내장, 단독 배포 가능 |
| `iweb_template.html` | 아임웹에 삽입할 코드 — CDN의 `index.html`을 iframe으로 임베드 |

> 별도 섹션 파일(`NN_name.html`)은 더 이상 존재하지 않습니다.  
> `index.html` 하나를 수정하면 메인 사이트와 아임웹 모두 자동 반영됩니다.

---

## index.html 섹션 구조

`index.html`은 scroll-snap 레이아웃으로 아래 4개 섹션을 포함합니다.

| ID | 내용 |
|----|------|
| `#s1` | Hero — MP4 영상 배경, 타이틀, CTA |
| `#s2` | About — 회사 소개, 개발 4단계 스텝 카드 |
| `#s3` | Services — CDMO·인체세포관리업·세포처리시설 카드 |
| `#s4` | Contact — 문의 CTA, 연락처, 푸터 |

---

## 파일 구조 변경 시 업데이트 체크리스트

파일을 **추가·삭제·이름 변경**할 때 아래 문서들을 함께 업데이트합니다.

| 문서 | 업데이트 내용 |
|------|--------------|
| `README.md` | `## 파일 구조` 트리에 항목 추가/제거 |
| `AGENTS.md` | `## 파일 목록 (현행)` 표에 항목 추가/제거 |
| `.github/copilot-instructions.md` | `## 파일 목록 (현행)` 표에 항목 추가/제거 |
| `purge-cdn.sh` | `FILES=(` 배열에 HTML 파일 추가/제거 |

> 영상(`mp4`, `webm`), 이미지, 스크립트 등 **비HTML 자산**은 `purge-cdn.sh`에는 추가하지 않아도 됩니다.

> **자율 탐색 원칙**: 위 목록은 최소 기준입니다. 작업 전 워크스페이스를 탐색하여 파일명·경로·설명을 포함하는 문서(`.md`, `.html`, `.sh` 등)를 직접 찾아 함께 업데이트하세요. 명시되지 않은 파일이라도 관련성이 있으면 수정 대상입니다.

---

## 수정 흐름

```
index.html 직접 편집
  → ./serve.sh 로 로컬 확인 (http://localhost:8080/index.html)
  → git add . && git commit && git push
  → ./purge-cdn.sh 실행
  → http://localhost:8080/test-cdn.html 에서 CDN 확인
```

---

## CDN 정보

| 항목 | 값 |
|------|-----|
| 리포지토리 | `norahyodesign/geniecellbio` |
| 브랜치 | `main` |
| CDN URL | `https://cdn.jsdelivr.net/gh/norahyodesign/geniecellbio@main/index.html` |
| Purge URL | `https://purge.jsdelivr.net/gh/norahyodesign/geniecellbio@main/index.html` |

---

## 파일 목록 (현행)

| 파일 | 설명 |
|------|------|
| `index.html` | 메인 사이트 (수정 대상) |
| `iweb_template.html` | 아임웹 삽입 코드 (index.html CDN iframe) |
| `test-cdn.html` | CDN 로드 테스트 |
| `serve.sh` | 로컬 서버 실행 |
| `purge-cdn.sh` | CDN 캐시 퍼지 |
| `AGENTS.md` | AI 에이전트 공통 지침 (Claude용) |
| `README.md` | 프로젝트 문서 |
| `doc/` | 디자인 가이드, 기획 문서 등 |
