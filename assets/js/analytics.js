// GA4 Measurement ID — replace with your real ID from Google Analytics
const GA_ID = 'G-XXXXXXXXXX';

const CONSENT_KEY = 'cookie_consent';

function loadGA() {
    if (document.getElementById('ga-script')) return;
    const s = document.createElement('script');
    s.id = 'ga-script';
    s.async = true;
    s.src = 'https://www.googletagmanager.com/gtag/js?id=' + GA_ID;
    document.head.appendChild(s);
    window.dataLayer = window.dataLayer || [];
    function gtag() { dataLayer.push(arguments); }
    window.gtag = gtag;
    gtag('js', new Date());
    gtag('config', GA_ID);
}

function cookieConsent() {
    return localStorage.getItem(CONSENT_KEY);
}

function acceptCookies() {
    localStorage.setItem(CONSENT_KEY, 'accepted');
    document.getElementById('cookie-banner').style.display = 'none';
    loadGA();
}

function rejectCookies() {
    localStorage.setItem(CONSENT_KEY, 'rejected');
    document.getElementById('cookie-banner').style.display = 'none';
}

function injectBanner() {
    const banner = document.createElement('div');
    banner.id = 'cookie-banner';
    banner.style.cssText = [
        'position:fixed', 'bottom:0', 'left:0', 'right:0', 'z-index:9999',
        'background:#1e293b', 'color:#f1f5f9', 'padding:16px 24px',
        'display:flex', 'flex-wrap:wrap', 'align-items:center', 'gap:12px',
        'font-family:inherit', 'font-size:14px', 'box-shadow:0 -2px 12px rgba(0,0,0,0.3)'
    ].join(';');
    banner.innerHTML = `
        <span style="flex:1;min-width:200px">
            Usamos cookies analíticas para mejorar tu experiencia.
            <a href="/politica-privacidad.html" style="color:#60a5fa;text-decoration:underline">Política de privacidad</a>
        </span>
        <button onclick="rejectCookies()" style="padding:8px 16px;border-radius:6px;border:1px solid #475569;background:transparent;color:#94a3b8;cursor:pointer;font-size:13px">Rechazar</button>
        <button onclick="acceptCookies()" style="padding:8px 20px;border-radius:6px;border:none;background:#3b82f6;color:#fff;cursor:pointer;font-weight:600;font-size:13px">Aceptar</button>
    `;
    document.body.appendChild(banner);
}

(function init() {
    const consent = cookieConsent();
    if (consent === 'accepted') { loadGA(); return; }
    if (consent === 'rejected') return;
    // No consent yet — show banner after DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', injectBanner);
    } else {
        injectBanner();
    }
})();
