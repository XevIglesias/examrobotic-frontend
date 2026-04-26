function authInit() {
    renderHeader();
    const overlay = document.getElementById('auth-overlay');
    if (overlay) {
        overlay.addEventListener('click', function(e) {
            if (e.target === this) closeAuth();
        });
    }
}

function renderHeader() {
    const user = currentUser();
    const area = document.getElementById('auth-header-area');
    if (!area) return;
    if (user) {
        const initials = user.name.split(' ').map(w => w[0]).join('').slice(0, 2).toUpperCase();
        const profileHref = window.location.pathname.includes('/asignaturas/') ? '../../perfil.html' : 'perfil.html';
        area.innerHTML = `
            <div class="flex items-center gap-3 shrink-0">
                <div class="hidden md:block text-right">
                    <a href="${profileHref}" class="text-sm font-bold text-foreground hover:text-primary transition-colors">${escHtml(user.name)}</a>
                    <button onclick="doLogout()" class="block text-xs text-muted font-semibold uppercase tracking-wider hover:text-red-500 transition-colors cursor-pointer">Cerrar sesión</button>
                </div>
                <a href="${profileHref}" class="w-10 h-10 rounded-full bg-blue-100 border-2 border-primary flex items-center justify-center text-primary font-bold text-sm hover:bg-blue-200 transition-colors">
                    ${initials}
                </a>
            </div>`;
    } else {
        area.innerHTML = `
            <button onclick="openAuth('login')" class="px-4 py-2 rounded-lg border border-primary text-primary text-sm font-semibold hover:bg-primary hover:text-white transition-colors">
                Iniciar sesión
            </button>`;
    }
}

function openAuth(tab) {
    const overlay = document.getElementById('auth-overlay');
    if (!overlay) {
        // Si no hay modal en esta página (ej. test), redirigimos al login principal o simplemente no hacemos nada
        window.location.href = window.location.pathname.includes('/asignaturas/') ? '../../index.html' : 'index.html';
        return;
    }
    overlay.style.display = 'flex';
    switchTab(tab || 'login');
    const emailField = document.getElementById('auth-email');
    if (emailField) emailField.focus();
}

function closeAuth() {
    const overlay = document.getElementById('auth-overlay');
    if (overlay) overlay.style.display = 'none';
    clearAuthError();
}

function switchTab(tab) {
    const tabLogin = document.getElementById('tab-login');
    const tabReg = document.getElementById('tab-register');
    const formLogin = document.getElementById('form-login');
    const formReg = document.getElementById('form-register');

    if (tabLogin) tabLogin.classList.toggle('tab-active', tab === 'login');
    if (tabReg) tabReg.classList.toggle('tab-active', tab === 'register');
    if (formLogin) formLogin.style.display = tab === 'login' ? 'flex' : 'none';
    if (formReg) formReg.style.display = tab === 'register' ? 'flex' : 'none';
    clearAuthError();
}

function clearAuthError() {
    const err = document.getElementById('auth-error');
    if (err) err.textContent = '';
}

function showAuthError(msg) {
    const err = document.getElementById('auth-error');
    if (err) err.textContent = msg;
}

async function doLogin(e) {
    e.preventDefault();
    const btn = document.getElementById('btn-login');
    const email = document.getElementById('auth-email').value.trim();
    const password = document.getElementById('auth-password').value;
    btn.disabled = true;
    btn.textContent = 'Entrando...';
    try {
        const data = await login(email, password);
        if (data.token) {
            closeAuth();
            renderHeader();
        } else {
            showAuthError(data.message || 'Credenciales incorrectas');
        }
    } catch {
        showAuthError('Error de conexión. Inténtalo de nuevo.');
    }
    btn.disabled = false;
    btn.textContent = 'Entrar';
}

async function doRegister(e) {
    e.preventDefault();
    const btn = document.getElementById('btn-register');
    const name = document.getElementById('reg-name').value.trim();
    const email = document.getElementById('reg-email').value.trim();
    const password = document.getElementById('reg-password').value;
    const password2 = document.getElementById('reg-password2').value;
    if (password !== password2) { showAuthError('Las contraseñas no coinciden.'); return; }
    if (password.length < 6) { showAuthError('La contraseña debe tener al menos 6 caracteres.'); return; }
    btn.disabled = true;
    btn.textContent = 'Creando cuenta...';
    try {
        const data = await register(name, email, password);
        if (data.token) {
            closeAuth();
            renderHeader();
        } else {
            showAuthError(data.message || 'No se pudo crear la cuenta.');
        }
    } catch {
        showAuthError('Error de conexión. Inténtalo de nuevo.');
    }
    btn.disabled = false;
    btn.textContent = 'Crear cuenta';
}

function doLogout() {
    logout();
    renderHeader();
}

function escHtml(str) {
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

document.addEventListener('DOMContentLoaded', authInit);
