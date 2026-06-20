#!/bin/bash
# ============================================================
#  build-imweb.sh — 아임웹 "코드" 위젯 네이티브 서빙용 빌드
# ------------------------------------------------------------
#  목적: GitHub Pages iframe 임베드(iweb_template.html)를 버리고,
#        실제 HTML/CSS/JS를 아임웹 코드 위젯에 직접 붙여넣어
#        아임웹 도메인에서 네이티브로 서빙 → SEO를 아임웹으로 귀속.
#
#  각 페이지마다 self-contained 위젯 블롭을 iweb-dist/ 에 생성한다:
#    - tokens.css + 페이지 CSS 를 #gcb-root 로 스코프 인라인
#    - nav.js / footer.js HTML 을 정적으로 펼쳐 넣음 (document.write 의존 제거)
#    - 자산(geniecell_imge·geniecell_video·hero 미디어) → jsDelivr CDN 절대 URL
#    - 내부 *.html 링크 → 아임웹 페이지 슬러그 (/about, /cdmo …)
#    - position:fixed 풀화면 오버레이 래퍼로 현재 디자인 100% 유지
#
#  사용법:  bash build-imweb.sh
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

DIST="iweb-dist"
rm -rf "$DIST"
mkdir -p "$DIST"

echo "🔧 아임웹 코드 위젯 빌드 시작 → $DIST/"
python3 - "$DIST" <<'PYEOF'
import os, re, sys

DIST = sys.argv[1]
CDN  = "https://cdn.jsdelivr.net/gh/norahyodesign/geniecellbio@main/"

# ── 페이지 → (아임웹 슬러그, nav 활성 키) ──
PAGES = {
    "index.html":           ("/home",             None),
    "about.html":           ("/about",           "about"),
    "cdmo.html":            ("/cdmo",            "cdmo"),
    "cell-management.html": ("/cell-management", "cell-management"),
    "cell-facility.html":   ("/cell-facility",   "cell-facility"),
    "support.html":         ("/support",         "support"),
    "privacy.html":         ("/privacy",         None),
}
SLUG = {f: s for f, (s, _) in PAGES.items()}


def read(p):
    with open(p, encoding="utf-8") as fh:
        return fh.read()


# ── nav.js / footer.js 의 HTML 배열을 정적 추출 (단일 소스 유지) ──
def extract_html_array(js_path):
    src = read(js_path)
    body = src[src.index("var html = [") + len("var html = ["):]
    body = body[:body.index("].join(")]
    parts = re.findall(r"'((?:[^'\\]|\\.)*)'", body)
    parts = [p.replace("\\'", "'").replace('\\\\', '\\') for p in parts]
    return "\n".join(parts)

NAV_HTML    = extract_html_array("nav.js")
FOOTER_HTML = extract_html_array("footer.js")


# ── 내부 *.html 링크 → 아임웹 슬러그 ──
def rewrite_links(html):
    def repl(m):
        base = m.group(1) + ".html"
        frag = m.group(2) or ""
        slug = SLUG.get(base)
        if slug is None:
            return m.group(0)
        return 'href="%s%s"' % (slug, frag)
    return re.sub(r'href="([a-z][a-z0-9-]*)\.html(#[^"]*)?"', repl, html)


# ── 상대 자산 경로 → jsDelivr CDN 절대 URL ──
def rewrite_assets(html):
    html = html.replace("geniecell_imge/", CDN + "geniecell_imge/")
    html = html.replace("geniecell_video/", CDN + "geniecell_video/")
    for f in ("hero-bg.webm", "hero-poster.jpg", "1080001154-preview.mp4"):
        html = html.replace('"%s"' % f, '"%s%s"' % (CDN, f))
    return html


# ── CSS 의 html/body 셀렉터 → #gcb-root (오버레이가 스크롤 컨테이너) ──
def scope_css(css):
    css = re.sub(r'(^|[}\n,;])(\s*)body\.subpage\b', r'\1\2#gcb-root', css)
    css = re.sub(r'(^|[}\n,;])(\s*)body\b',          r'\1\2#gcb-root', css)
    css = re.sub(r'(^|[}\n,;])(\s*)html\b',          r'\1\2#gcb-root', css)
    return css


TOKENS_SCOPED = scope_css(read("tokens.css"))

RESET = (
    "#gcb-root{position:fixed;inset:0;z-index:99990;overflow-y:auto;overflow-x:clip;"
    "background:#fff;-webkit-overflow-scrolling:touch}\n"
    "#gcb-root *,#gcb-root *::before,#gcb-root *::after{box-sizing:border-box}\n"
    "#gcb-root :where(h1,h2,h3,h4,h5,h6,p,ul,ol,li,figure,blockquote,dl,dd)"
    "{margin:0;padding:0}\n"
    "#gcb-root :where(ul,ol){list-style:none}\n"
    "#gcb-root :where(a){text-decoration:none;color:inherit}\n"
    "#gcb-root :where(button){font:inherit;background:none;border:0;cursor:pointer}\n"
    "#gcb-root :where(img){max-width:100%;display:block}\n"
)

# ── 모바일 드로어/드롭다운 인터랙션 (nav.js 의존 제거, #gcb-root 스코프) ──
INTERACTION_JS = """
(function () {
  var root = document.getElementById('gcb-root');
  if (!root) return;
  var ham    = root.querySelector('#gcb-ham');
  var drawer = root.querySelector('#gcb-drawer');
  if (ham && drawer) {
    ham.addEventListener('click', function () {
      var open = drawer.classList.toggle('open');
      ham.setAttribute('aria-expanded', String(open));
    });
    document.addEventListener('click', function (e) {
      if (drawer.classList.contains('open') &&
          !drawer.contains(e.target) && e.target !== ham && !ham.contains(e.target)) {
        drawer.classList.remove('open');
        ham.setAttribute('aria-expanded', 'false');
      }
    });
    drawer.addEventListener('click', function (e) {
      if (e.target.closest('a')) {
        drawer.classList.remove('open');
        ham.setAttribute('aria-expanded', 'false');
      }
    });
  }

  // 탭 안전망 — 페이지의 탭 스크립트가 첫 탭을 못 켜는 경우에도
  // 콘텐츠가 항상 보이도록 첫 섹션을 활성화한다 (코드 위젯 임베드 환경 보호).
  function ensureTab() {
    var secs = root.querySelectorAll('.tab-section');
    if (!secs.length || root.querySelector('.tab-section.is-active')) return;
    var firstId = secs[0].id;
    secs.forEach(function (s) {
      if (s.id === firstId || s.getAttribute('data-tab-parent') === firstId) {
        s.classList.add('is-active');
      }
    });
    var t = root.querySelector('.tab-item[data-target="' + firstId + '"]');
    if (t) t.classList.add('active');
  }
  ensureTab();
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', ensureTab);
  }
  window.addEventListener('load', ensureTab);
})();
"""


def build_page(fname, active_key):
    src = read(fname)

    # 페이지 전용 <style> 추출 (head 내 1개)
    m = re.search(r'<style>(.*?)</style>', src, re.S)
    page_css = scope_css(m.group(1)) if m else ""

    # body 내부 추출
    bm = re.search(r'<body[^>]*>(.*?)</body>', src, re.S)
    body = bm.group(1)
    body_class = ""
    bc = re.search(r'<body[^>]*class="([^"]*)"', src)
    if bc:
        body_class = bc.group(1)

    # nav.js / footer.js 스크립트 태그 → 정적 HTML 치환
    nav = NAV_HTML
    if active_key:
        # nav-item 은 이미 class="nav-item" 보유 → is-active 병합
        nav = nav.replace(
            'class="nav-item" data-nav="%s"' % active_key,
            'class="nav-item is-active" data-nav="%s"' % active_key,
        )

    body = re.sub(r'<script src="nav\.js"></script>',    lambda _: nav,    body)
    body = re.sub(r'<script src="footer\.js"></script>', lambda _: FOOTER_HTML, body)

    # 탭 시스템 페이지(about·cdmo·cell-*): JS 미실행 시에도 첫 탭 콘텐츠가
    # 보이도록 정적으로 is-active 부여 (코드 위젯에서 스크립트가 늦거나 막혀도 안전)
    if "tab-section" in body:
        first = re.search(r'<section\b[^>]*\bid="([^"]+)"[^>]*\bclass="[^"]*\btab-section\b', body)
        if not first:
            first = re.search(r'<section\b[^>]*\bclass="[^"]*\btab-section\b[^>]*\bid="([^"]+)"', body)
        if first:
            fid = first.group(1)

            def add_active(m):
                tag = m.group(0)
                if "is-active" in tag:
                    return tag
                if ('id="%s"' % fid) in tag or ('data-tab-parent="%s"' % fid) in tag:
                    return re.sub(r'class="([^"]*)"', r'class="\1 is-active"', tag, count=1)
                return tag
            body = re.sub(r'<section\b[^>]*>', add_active, body)

    # 링크·자산 치환
    page_css = rewrite_assets(page_css)
    body     = rewrite_links(rewrite_assets(body))

    # index.html 전용: window scroll → #gcb-root scroll 이벤트 폴리필 주입
    # 아임웹에서 스크롤 컨테이너가 window 가 아니라 #gcb-root 이므로
    # window 의 scroll 이벤트가 발생하지 않아 BUSINESS/NEWS 스크롤 스토리텔링,
    # nav 상태, 플로팅 버튼 가시성 등이 모두 동작하지 않는 문제 수정.
    # 폴리필: #gcb-root scroll → window 의 scroll 이벤트로 re-dispatch 하고,
    #          window.scrollY/scrollTo 를 #gcb-root 기준으로 재정의한다.
    if fname == "index.html":
        SCROLL_POLYFILL = """<script>
/* ── 아임웹 스크롤 폴리필 ──────────────────────────────────────────────
   아임웹에서 실제 스크롤 컨테이너는 window 가 아니라 #gcb-root 입니다.
   이 스크립트는 #gcb-root 의 scroll 이벤트를 window 로 re-dispatch 하고
   window.scrollY / window.scrollTo 를 #gcb-root 기준으로 재정의해
   기존 JS 코드(BUSINESS·NEWS 스토리텔링, nav 상태, 플로팅 버튼 등)가
   수정 없이 동작하도록 합니다.
─────────────────────────────────────────────────────────────────────── */
(function () {
  var root = document.getElementById('gcb-root');
  if (!root) return;

  /* scrollY 재정의 */
  try {
    Object.defineProperty(window, 'scrollY', {
      get: function () { return root.scrollTop; },
      configurable: true,
    });
    Object.defineProperty(window, 'pageYOffset', {
      get: function () { return root.scrollTop; },
      configurable: true,
    });
  } catch (e) {}

  /* scrollTo / scroll 재정의 */
  var origScrollTo = window.scrollTo.bind(window);
  window.scrollTo = function (x, y) {
    if (x && typeof x === 'object') {
      root.scrollTo(x);
    } else {
      root.scrollTop = y || 0;
    }
  };

  /* #gcb-root scroll → window 'scroll' 이벤트 re-dispatch */
  root.addEventListener('scroll', function () {
    window.dispatchEvent(new Event('scroll'));
  }, { passive: true });
})();
</script>"""
        body = SCROLL_POLYFILL + body

    out = []
    out.append("<!-- ============================================================ -->")
    out.append("<!--  지니셀바이오 — %s  (아임웹 '코드' 위젯에 통째로 붙여넣기) -->" % fname)
    out.append("<!--  자동 생성: build-imweb.sh — 직접 수정 금지 -->")
    out.append("<!-- ============================================================ -->")
    out.append('<meta charset="utf-8">')
    out.append("<style>")
    out.append(RESET)
    out.append("/* ── tokens.css (스코프 인라인) ── */")
    out.append(TOKENS_SCOPED)
    out.append("/* ── %s 전용 스타일 (스코프 인라인) ── */" % fname)
    out.append(page_css)
    out.append("</style>")
    cls = (' class="%s"' % body_class) if body_class else ""
    out.append('<div id="gcb-root"%s>' % cls)
    out.append(body)
    out.append("</div>")
    out.append("<script>%s</script>" % INTERACTION_JS)
    return "\n".join(out)


for fname, (slug, active) in PAGES.items():
    if not os.path.exists(fname):
        print("  ⚠  %s 없음 — 건너뜀" % fname)
        continue
    html = build_page(fname, active)
    with open(os.path.join(DIST, fname), "w", encoding="utf-8") as fh:
        fh.write(html)
    # 미치환 잔재 검사: 슬러그로 안 바뀐 *.html 링크 + CDN 안 붙은 상대 자산
    leftover = re.findall(r'href="[a-z0-9-]+\.html', html)
    leftover += re.findall(r'(?:src|href|content|poster)="geniecell_(?:imge|video)/', html)
    flag = ("  ⚠ 잔재 %d" % len(leftover)) if leftover else ""
    print("  ✅  %-22s → %-16s (%d KB)%s" % (fname, slug, len(html) // 1024, flag))


# ── 공통 Header Code (환경설정 > SEO > Header Code 에 1회 삽입) ──
HEAD = """<!-- ============================================================
     지니셀바이오 공통 Header Code
     아임웹 관리자 > 환경설정 > SEO(검색엔진최적화) > Header Code 에 붙여넣기
     (모든 페이지 <head> 에 공통 삽입됨 — 폰트 1회 로드용)
     ============================================================ -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="preload" as="style"
  href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable.css"
  onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet"
  href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable.css"></noscript>
<link rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&family=DM+Sans:ital,opsz,wght@0,9..40,400;0,9..40,500;0,9..40,700;1,9..40,400&display=swap">
"""
with open(os.path.join(DIST, "_head-code.html"), "w", encoding="utf-8") as fh:
    fh.write(HEAD)
print("  ✅  _head-code.html  (환경설정 > SEO > Header Code 용)")


# ── 붙여넣기 가이드 ──
GUIDE = """# 아임웹 코드 위젯 붙여넣기 가이드

이 폴더(`iweb-dist/`)의 파일들은 **아임웹 코드 위젯에 그대로 붙여넣어** 아임웹
도메인에서 네이티브로 서빙하기 위한 빌드 산출물입니다. (기존 iframe 방식 폐기)

> ⚠️ 직접 수정 금지 — 원본(`index.html`, `tokens.css`, `nav.js` 등)을 고친 뒤
> `bash build-imweb.sh` 로 재생성하세요.

## 1) 공통 폰트 — 1회만
`_head-code.html` 내용을 복사 → 아임웹 관리자
**환경설정 > SEO(검색엔진최적화) > Header Code** 에 붙여넣고 저장.
(모든 페이지 `<head>` 에 공통 삽입되어 폰트가 1회 로드됩니다.)

## 2) 페이지별 본문 — 페이지마다 코드 위젯 1개
아임웹에서 아래 매핑대로 페이지를 만들고, 각 페이지에 **코드 위젯**을 하나 넣은 뒤
해당 파일 내용을 통째로 붙여넣습니다.

| 이 파일 | 아임웹 페이지 슬러그 |
|---|---|
| `index.html`           | `/home` |
| `about.html`           | `/about` |
| `cdmo.html`            | `/cdmo` |
| `cell-management.html` | `/cell-management` |
| `cell-facility.html`   | `/cell-facility` |
| `support.html`         | `/support` |
| `privacy.html`         | `/privacy` |

> 내부 링크는 위 슬러그(`/about` 등) 기준으로 미리 변환되어 있습니다.
> 아임웹 실제 슬러그가 다르면 `build-imweb.sh` 상단 `PAGES` 의 슬러그를 고쳐 재빌드하세요.

## 3) 페이지별 SEO 메타
title / description / canonical 등은 위젯이 아니라 아임웹 **페이지별 SEO 설정**에서
입력합니다. (각 원본 HTML `<head>` 의 메타값을 참고)

## 동작 방식 (참고)
- 위젯은 `#gcb-root` 풀화면 오버레이로 현재 디자인을 100% 유지하며, 아임웹 기본
  헤더/푸터를 덮습니다. 콘텐츠가 실제 DOM 에 존재하므로 아임웹 도메인 기준으로 색인됩니다.
- 이미지·영상은 jsDelivr CDN(`cdn.jsdelivr.net/gh/norahyodesign/geniecellbio@main/…`)
  에서 로드됩니다. 미디어를 바꾸면 GitHub push 후 `purge-cdn.sh` 로 캐시를 비우세요.
- 미리보기: 코드 위젯은 디자인 모드가 아니라 **미리보기 모드**에서만 렌더됩니다(아임웹 사양).

## 확인 체크리스트
- [ ] 폰트(Pretendard/DM Sans)가 적용되는가
- [ ] 상단 네비/모바일 햄버거 드로어가 열리는가
- [ ] 이미지·영상이 보이는가
- [ ] 내부 링크 클릭 시 아임웹 페이지로 이동하는가
- [ ] about/CDMO 등 탭 페이지에서 첫 탭 콘텐츠가 보이고 탭 전환이 되는가
"""
with open(os.path.join(DIST, "_PASTE-GUIDE.md"), "w", encoding="utf-8") as fh:
    fh.write(GUIDE)
print("  ✅  _PASTE-GUIDE.md")
PYEOF

echo "✅ 빌드 완료 → $DIST/   (붙여넣기 안내: $DIST/_PASTE-GUIDE.md)"
