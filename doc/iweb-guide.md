# 아임웹 적용 가이드

## 구조 개요

아임웹은 HTML 코드 블록을 지원합니다.  
각 섹션을 jsDelivr CDN에서 동적으로 불러오는 방식으로 운영합니다.

```
아임웹 페이지
  └── HTML 코드 블록 (iweb_template.html 내용 복붙)
        └── fetch → jsDelivr CDN → GitHub 소스 파일
```

## 적용 순서

1. **GitHub에 소스 push** (파일 수정 후 push 필수)
2. **아임웹 편집기** 접속
3. 원하는 위치에 **HTML 코드 블록** 추가
4. `iweb_template.html`에서 해당 섹션 코드 복사 → 붙여넣기
5. 저장 후 미리보기 확인

## 섹션별 코드 위치

| 섹션 | 파일 | 블록 ID |
|------|------|---------|
| 메뉴 | `iweb_template.html` 1번 블록 | `block-01` |
| 히어로 | `iweb_template.html` 2번 블록 | `block-02` |
| 회사소개 | `iweb_template.html` 3번 블록 | `block-03` |
| 서비스 | `iweb_template.html` 4번 블록 | `block-04` |
| 문의하기 | `iweb_template.html` 5번 블록 | `block-05` |
| 푸터 | `iweb_template.html` 6번 블록 | `block-06` |

## 주의사항

- **CDN 캐시**: push 후 최대 24시간 캐시 유지. 즉시 반영 필요 시 아래 URL로 퍼지
  ```
  https://purge.jsdelivr.net/gh/norahyodesign/geniecellbio@main/파일명.html
  ```
- **스크립트 실행**: `innerHTML`로 주입된 `<script>`는 브라우저가 자동 실행하지 않음.  
  `execScripts()` 함수로 재실행 처리되어 있으므로 별도 조치 불필요.
- **아임웹 CSP**: 아임웹 보안 정책에 따라 외부 fetch가 차단될 수 있음. 이 경우 아임웹 고객센터 문의.

## CDN URL 패턴

```
https://cdn.jsdelivr.net/gh/norahyodesign/geniecellbio@main/{파일명}
```
