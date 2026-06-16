/* ──────────────────────────────────────────
   footer.js — 공통 푸터 (모든 페이지 공유)
   사용법: </body> 직전에 <script src="footer.js"></script>
────────────────────────────────────────── */
(function () {
  'use strict';

  var html = [
    '<footer class="main-footer">',
    '  <div class="footer-inner">',
    '    <div class="footer-brand">',
    '      <a href="index.html" class="footer-logo">',
    '        <img src="geniecell_imge/%EC%A7%80%EB%8B%88%EC%85%80%EB%B0%94%EC%9D%B4%EC%98%A4%20%EB%A1%9C%EA%B3%A0.png" alt="지니셀바이오">',
    '        <span>GeniecellBio</span>',
    '      </a>',
    '      <div class="footer-info">',
    '        <div><strong>대표자</strong> 이 준</div>',
    '        <div><strong>TEL</strong> 031-602-0701</div>',
    '        <div><strong>FAX</strong> 031-602-0707</div>',
    '        <div><strong>E-mail</strong> geniecellbio@geniecellbio.com</div>',
    '        <div><strong>본사</strong> 경기도 성남시 중원구 갈마치로 314, 3층 301~306호 (성남 센트럴비즈타워 1)</div>',
    '      </div>',
    '    </div>',
    '    <div class="footer-links-col">',
    '      <a href="about.html#location">오시는 길</a>',
    '      <a href="privacy.html">개인정보처리방침</a>',
    '    </div>',
    '  </div>',
    '  <div class="footer-bottom">',
    '    <span>&copy; 2026 GeniecellBio. All rights reserved.</span>',
    '  </div>',
    '</footer>'
  ].join('\n');

  document.write(html);
})();
