# 지니셀바이오 웹사이트

첨단바이오의약품 CDMO 지니셀바이오 공식 웹사이트 소스코드입니다.

---

## 파일 구조

```
├── index.html          # 로컬 테스트용 메인 페이지
├── test-cdn.html       # CDN 로드 테스트 페이지
├── iweb_template.html  # 아임웹에 삽입할 코드 블록
├── serve.sh            # 로컬 서버 실행 스크립트
├── purge-cdn.sh        # jsDelivr CDN 캐시 퍼지 스크립트
│
├── 01_menu.html        # 메뉴 섹션
├── 02_hero.html        # 히어로 섹션
├── 03_about.html       # 회사소개 섹션
├── 04_services.html    # 서비스 섹션
├── 05_pipeline.html    # 파이프라인 섹션
├── 06_contact.html     # 문의하기 섹션
└── 07_footer.html      # 푸터 섹션
```

---

## 로컬 개발 서버 실행

```bash
./serve.sh
```

브라우저가 자동으로 열립니다.

| URL | 설명 |
|-----|------|
| http://localhost:8080/index.html | 로컬 파일 직접 로드 (즉시 확인) |
| http://localhost:8080/test-cdn.html | jsDelivr CDN 경유 로드 테스트 |

---

## 테스트 방법

### 1. 로컬 테스트
소스 파일을 수정한 뒤 `index.html`에서 바로 확인합니다.  
GitHub push 없이 즉시 반영됩니다.

### 2. CDN 테스트
아임웹에 실제로 적용되는 방식과 동일하게 테스트합니다.

1. 변경사항을 GitHub에 push
2. jsDelivr 캐시 퍼지 (선택사항, 아래 참고)
3. `test-cdn.html` 접속 → 오른쪽 하단 상태 패널에서 각 섹션 로드 확인

> **주의:** CDN은 최대 24시간 캐시됩니다. 즉시 반영이 필요하면 아래 스크립트로 캐시를 퍼지하세요.
> ```bash
> ./purge-cdn.sh
> ```

---

## 아임웹 적용 방법

1. 아임웹 편집기에서 **HTML 코드 블록** 추가
2. `iweb_template.html`의 각 섹션 코드를 복사해서 붙여넣기
3. 저장 후 미리보기로 확인

> 데이터는 jsDelivr CDN(`cdn.jsdelivr.net`)에서 불러옵니다.  
> GitHub 리포지토리에 파일이 push되어 있어야 정상 로드됩니다.

---

## 배포 플로우

```
코드 수정 → 로컬 테스트(index.html) → GitHub push → CDN 퍼지(purge-cdn.sh) → CDN 테스트(test-cdn.html) → 아임웹 확인
```
