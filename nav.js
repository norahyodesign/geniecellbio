/* ──────────────────────────────────────────
   nav.js — 공통 네비게이션 (모든 페이지 공유)
   사용법: <body> 직후에 <script src="nav.js"></script>
────────────────────────────────────────── */
(function () {
  'use strict';

  /* ── 1. SVG 스프라이트 + Nav HTML ── */
  var html = [
    // SVG 아이콘 스프라이트
    '<svg aria-hidden="true" focusable="false" style="display:none" xmlns="http://www.w3.org/2000/svg">',
    '  <symbol id="ico-check" viewBox="0 0 16 16" fill="none">',
    '    <path d="M13.25 4.75L6 12 2.75 8.75" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>',
    '  </symbol>',
    '  <symbol id="ico-arrow-right" viewBox="0 0 16 16" fill="none">',
    '    <path d="M3 8h10M9 4l4 4-4 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>',
    '  </symbol>',
    '  <symbol id="ico-chevron-down" viewBox="0 0 16 16" fill="none">',
    '    <path d="M4 6l4 4 4-4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>',
    '  </symbol>',
    '</svg>',

    // NAV
    '<header>',
    '<nav id="gcb-nav" aria-label="주 메뉴">',
    '  <div class="nav-inner">',
    '    <a href="index.html" class="nav-logo">',
    '      <img src="geniecell_imge/%EC%A7%80%EB%8B%88%EC%85%80%EB%B0%94%EC%9D%B4%EC%98%A4%20%EB%A1%9C%EA%B3%A0.png" alt="지니셀바이오" class="nav-logo-img">',
    '    </a>',

    '    <ul class="nav-menu">',
    // 기업소개
    '      <li class="nav-item" data-nav="about">',
    '        <button type="button" class="nav-link">기업소개 <svg aria-hidden="true" focusable="false" width="16" height="16"><use href="#ico-chevron-down"/></svg></button>',
    '        <div class="nav-drop">',
    '          <a href="about.html#greeting">인사말</a>',
    '          <a href="about.html#company">회사소개</a>',
    '          <a href="about.html#location">오시는길</a>',
    '        </div>',
    '      </li>',
    // CDMO 서비스
    '      <li class="nav-item" data-nav="cdmo">',
    '        <a href="cdmo.html" class="nav-link">CDMO 서비스 <svg aria-hidden="true" focusable="false" width="16" height="16"><use href="#ico-chevron-down"/></svg></a>',
    '        <div class="nav-drop">',
    '          <a href="cdmo.html#cmo">CMO · 위탁생산</a>',
    '          <a href="cdmo.html#qc">QC · 위탁품질시험</a>',
    '          <a href="cdmo.html#ra">RA · 인허가 컨설팅</a>',
    '        </div>',
    '      </li>',
    // 인체세포등 관리업
    '      <li class="nav-item" data-nav="cell-management">',
    '        <a href="cell-management.html" class="nav-link">인체세포등 관리업 <svg aria-hidden="true" focusable="false" width="16" height="16"><use href="#ico-chevron-down"/></svg></a>',
    '        <div class="nav-drop">',
    '          <a href="cell-management.html#supply">원료세포 공급</a>',
    '          <a href="cell-management.html#banking">자가세포 보관</a>',
    '        </div>',
    '      </li>',
    // 세포처리시설
    '      <li class="nav-item" data-nav="cell-facility">',
    '        <a href="cell-facility.html" class="nav-link">세포처리시설 <svg aria-hidden="true" focusable="false" width="16" height="16"><use href="#ico-chevron-down"/></svg></a>',
    '        <div class="nav-drop">',
    '          <a href="cell-facility.html#cmo">투여용 세포 공급</a>',
    '          <a href="cell-facility.html#doc">치료계획서 작성 지원</a>',
    '        </div>',
    '      </li>',
    // 고객지원
    '      <li class="nav-item" data-nav="support">',
    '        <button type="button" class="nav-link">고객지원 <svg aria-hidden="true" focusable="false" width="16" height="16"><use href="#ico-chevron-down"/></svg></button>',
    '        <div class="nav-drop">',
    '          <a href="support.html#qna">Q&amp;A</a>',
    '          <a href="support.html#contact">Contact Us</a>',
    '        </div>',
    '      </li>',
    '    </ul>',

    '    <a href="support.html#contact" class="nav-cta">상담 신청</a>',
    '    <button type="button" class="nav-ham" id="gcb-ham" aria-label="메뉴" aria-expanded="false" aria-controls="gcb-drawer">',
    '      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 7h16M4 12h16M4 17h16" stroke-linecap="round"/></svg>',
    '    </button>',
    '  </div>',
    '</nav>',

    // 모바일 드로어
    '<div class="nav-drawer" id="gcb-drawer">',
    '  <div class="nav-drawer-section">',
    '    <div class="nav-drawer-label">기업소개</div>',
    '    <a href="about.html#greeting">인사말</a>',
    '    <a href="about.html#company">회사소개</a>',
    '    <a href="about.html#location">오시는길</a>',
    '  </div>',
    '  <div class="nav-drawer-section">',
    '    <div class="nav-drawer-label">CDMO 서비스</div>',
    '    <a href="cdmo.html#cmo">CMO · 위탁생산</a>',
    '    <a href="cdmo.html#qc">QC · 위탁품질시험</a>',
    '    <a href="cdmo.html#ra">RA · 인허가 컨설팅</a>',
    '  </div>',
    '  <div class="nav-drawer-section">',
    '    <div class="nav-drawer-label">인체세포등 관리업</div>',
    '    <a href="cell-management.html#supply">원료세포 공급</a>',
    '    <a href="cell-management.html#banking">자가세포 보관</a>',
    '  </div>',
    '  <div class="nav-drawer-section">',
    '    <div class="nav-drawer-label">세포처리시설</div>',
    '    <a href="cell-facility.html#cmo">투여용 세포 공급</a>',
    '    <a href="cell-facility.html#doc">치료계획서 작성 지원</a>',
    '  </div>',
    '  <div class="nav-drawer-section">',
    '    <div class="nav-drawer-label">고객지원</div>',
    '    <a href="support.html#qna">Q&amp;A</a>',
    '    <a href="support.html#contact">Contact Us</a>',
    '  </div>',
    '</div>',
    '</header>'
  ].join('\n');

  /* ── 2. DOM에 삽입 (script 위치에) ── */
  var script = document.currentScript;
  var wrapper = document.createElement('div');
  wrapper.innerHTML = html;
  while (wrapper.firstChild) {
    script.parentNode.insertBefore(wrapper.firstChild, script);
  }

  /* ── 3. 현재 페이지 감지 → is-active 적용 ── */
  var path = window.location.pathname;
  var file = path.substring(path.lastIndexOf('/') + 1) || 'index.html';

  // 파일명 → data-nav 매핑
  var navMap = {
    'about.html':           'about',
    'cdmo.html':            'cdmo',
    'cell-management.html': 'cell-management',
    'cell-facility.html':   'cell-facility',
    'support.html':         'support'
  };

  var activeKey = navMap[file];
  if (activeKey) {
    var item = document.querySelector('.nav-item[data-nav="' + activeKey + '"]');
    if (item) item.classList.add('is-active');
  }

  /* ── 4. 드로어 토글 + aria-expanded + 바깥 클릭 닫기 ── */
  var ham    = document.getElementById('gcb-ham');
  var drawer = document.getElementById('gcb-drawer');
  if (ham && drawer) {
    ham.addEventListener('click', function () {
      var isOpen = drawer.classList.toggle('open');
      ham.setAttribute('aria-expanded', String(isOpen));
    });
    document.addEventListener('click', function (e) {
      if (drawer.classList.contains('open') &&
          !drawer.contains(e.target) && e.target !== ham && !ham.contains(e.target)) {
        drawer.classList.remove('open');
        ham.setAttribute('aria-expanded', 'false');
      }
    });
  }
})();
