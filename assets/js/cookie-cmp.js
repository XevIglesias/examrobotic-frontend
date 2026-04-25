document.addEventListener('DOMContentLoaded', function() {
    // Check if consent has already been given or rejected
    if (localStorage.getItem('cookie_consent')) {
        return;
    }

    // Create the CMP banner
    const banner = document.createElement('div');
    banner.id = 'cmp-banner';
    banner.className = 'fixed bottom-0 left-0 right-0 bg-white border-t border-border p-4 md:p-6 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.05)] z-[9999] flex flex-col md:flex-row items-center justify-between gap-4 font-sans transition-transform duration-500 transform translate-y-full';
    
    // Banner Content
    banner.innerHTML = `
        <div class="flex-grow max-w-4xl">
            <h3 class="text-foreground font-extrabold text-lg mb-2 flex items-center gap-2">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary"><path d="M12 2a10 10 0 1 0 10 10 4 4 0 0 1-5-5 4 4 0 0 1-5-5"></path><path d="M8.5 8.5v.01"></path><path d="M16 12.5v.01"></path><path d="M12 16v.01"></path><path d="M11 12.5v.01"></path></svg>
                Tu privacidad es importante
            </h3>
            <p class="text-sm text-muted leading-relaxed">
                Utilizamos cookies propias y de terceros para fines analíticos y para mostrarte publicidad personalizada en base a un perfil elaborado a partir de tus hábitos de navegación (por ejemplo, páginas visitadas). 
                Puedes aceptar todas las cookies haciendo clic en el botón "Aceptar todas", rechazarlas con "Rechazar" o obtener más información en nuestra 
                <a href="/politica-cookies.html" class="text-primary font-semibold hover:underline">Política de Cookies</a>.
            </p>
        </div>
        <div class="flex flex-col sm:flex-row gap-3 w-full md:w-auto shrink-0">
            <button id="cmp-reject" class="px-6 py-2.5 rounded-xl border-2 border-border text-foreground font-bold text-sm hover:bg-gray-50 transition-colors w-full sm:w-auto">
                Rechazar
            </button>
            <button id="cmp-accept" class="px-6 py-2.5 rounded-xl bg-primary text-white font-bold text-sm hover:bg-blue-700 transition-colors shadow-md w-full sm:w-auto">
                Aceptar todas
            </button>
        </div>
    `;

    document.body.appendChild(banner);

    // Slide up animation after a short delay
    setTimeout(() => {
        banner.classList.remove('translate-y-full');
    }, 100);

    // Handle Reject
    document.getElementById('cmp-reject').addEventListener('click', () => {
        localStorage.setItem('cookie_consent', 'rejected');
        closeBanner();
    });

    // Handle Accept
    document.getElementById('cmp-accept').addEventListener('click', () => {
        localStorage.setItem('cookie_consent', 'accepted');
        closeBanner();
        loadAdsense(); // Here is where AdSense would theoretically load
    });

    function closeBanner() {
        banner.classList.add('translate-y-full');
        setTimeout(() => {
            banner.remove();
        }, 500);
    }

    function loadAdsense() {
        // Placeholder for AdSense script injection
        console.log("Cookies aceptadas: Cargando scripts de Google AdSense...");
        // const script = document.createElement('script');
        // script.src = "https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js";
        // script.async = true;
        // script.crossOrigin = "anonymous";
        // document.head.appendChild(script);
    }
});
