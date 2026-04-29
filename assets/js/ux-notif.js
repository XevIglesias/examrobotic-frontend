// ux-notif.js - Sistema de avisos de novedades (Solo Escritorio)
document.addEventListener('DOMContentLoaded', () => {
    // No mostrar si ya se cerró antes
    if (localStorage.getItem('shortcuts_notif_closed')) return;
    
    // NO mostrar en móviles (menos de 1024px de ancho)
    if (window.innerWidth < 1024) return;

    // Calcular ruta base para las imágenes
    const scripts = document.getElementsByTagName('script');
    let basePath = '/';
    for (let s of scripts) {
        if (s.src.includes('ux-notif.js')) {
            basePath = s.src.split('assets/js/ux-notif.js')[0];
            break;
        }
    }

    const notif = document.createElement('div');
    notif.id = 'shortcuts-notif';
    notif.style.cssText = `
        position: fixed; 
        bottom: 30px; 
        right: 30px; 
        width: 340px;
        background: #ffffff; 
        border: 1px solid #e2e8f0; 
        border-radius: 24px;
        padding: 24px; 
        box-shadow: 0 15px 50px rgba(15, 23, 42, 0.15);
        z-index: 9999; 
        font-family: 'Manrope', sans-serif;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        transform: translateY(0);
        opacity: 1;
    `;


    // Estilos de animación
    const style = document.createElement('style');
    style.innerHTML = `
        @keyframes slideInUp {
            from { transform: translateY(100px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        #shortcuts-notif { animation: slideInUp 0.6s ease-out; }
        .key-badge {
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-bottom-width: 3px;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-family: monospace;
            color: #475569;
        }
    `;
    document.head.appendChild(style);

    notif.innerHTML = `
        <button onclick="closeNotif()" style="position:absolute; top:16px; right:16px; background:#f8fafc; border:none; cursor:pointer; color:#94a3b8; width:28px; height:28px; border-radius:50%; display:flex; align-items:center; justify-content:center; transition:all 0.2s; font-weight:bold;">&times;</button>
        
        <div style="display:flex; align-items:center; gap:16px; margin-bottom:18px;">
            <div style="position:relative;">
                <img src="${basePath}assets/img/robot-avatar.png" style="width:56px; height:56px; border-radius:16px; border: 2px solid #eff6ff;">
                <div style="position:absolute; -right:4px; -bottom:4px; width:20px; height:20px; background:#22c55e; border:3px solid #fff; border-radius:50%;"></div>
            </div>
            <div>
                <h4 style="margin:0; font-weight:800; color:#0f172a; font-size:1rem; letter-spacing:-0.01em;">¡Nuevo: Atajos!</h4>
                <p style="margin:0; font-size:0.7rem; font-weight:800; color:#2563eb; text-transform:uppercase; letter-spacing:0.05em;">Modo Pro Activado</p>
            </div>
        </div>

        <p style="margin:0 0 20px 0; font-size:0.85rem; color:#64748b; line-height:1.6; font-weight:500;">
            Resuelve los tests mucho más rápido usando tu teclado:
        </p>

        <div style="display:grid; gap:10px;">
            <div style="display:flex; justify-content:space-between; align-items:center; background:#f8fafc; padding:10px 14px; border-radius:12px; border: 1px solid #f1f5f9;">
                <div style="display:flex; gap:4px;">
                    <span class="key-1 key-badge">1</span>
                    <span class="key-badge">2</span>
                    <span class="key-badge">3</span>
                    <span class="key-badge">4</span>
                </div>
                <span style="font-size:0.8rem; font-weight:700; color:#334155;">Opciones A-D</span>
            </div>
            <div style="display:flex; justify-content:space-between; align-items:center; background:#f8fafc; padding:10px 14px; border-radius:12px; border: 1px solid #f1f5f9;">
                <div style="display:flex; gap:4px;">
                    <span class="key-badge">&larr;</span>
                    <span class="key-badge">&rarr;</span>
                </div>
                <span style="font-size:0.8rem; font-weight:700; color:#334155;">Navegación</span>
            </div>
        </div>
        
        <button onclick="closeNotif()" style="width:100%; margin-top:20px; padding:12px; background:#2563eb; color:#fff; border:none; border-radius:12px; font-weight:800; font-size:0.85rem; cursor:pointer; transition:all 0.2s; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);" onmouseover="this.style.background='#1d4ed8'" onmouseout="this.style.background='#2563eb'">
            Entendido
        </button>
    `;

    document.body.appendChild(notif);
});

window.closeNotif = function() {
    const el = document.getElementById('shortcuts-notif');
    if (el) {
        el.style.transform = 'translateY(20px)';
        el.style.opacity = '0';
        setTimeout(() => {
            el.remove();
            localStorage.setItem('shortcuts_notif_closed', 'true');
        }, 400);
    }
}
