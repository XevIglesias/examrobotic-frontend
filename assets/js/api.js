const API = 'https://api.examrobotic.com/api';

function apiToken() { return localStorage.getItem('token'); }

async function apiPost(path, body, auth = false) {
  const headers = { 'Content-Type': 'application/json' };
  if (auth) headers['Authorization'] = 'Bearer ' + apiToken();
  const r = await fetch(API + path, { method: 'POST', headers, body: JSON.stringify(body) });
  return r.json();
}

async function apiGet(path) {
  const r = await fetch(API + path, { headers: { 'Authorization': 'Bearer ' + apiToken() } });
  return r.json();
}

async function saveAttempt(subjectSlug, examType, score, rawScore, timeSpentSec, answers) {
  if (!apiToken()) return;
  try {
    await apiPost('/attempts', { subjectSlug, examType, score, rawScore, timeSpentSec, answers }, true);
  } catch (e) {
    console.warn('No se pudo guardar el intento:', e);
  }
}

async function login(email, password) {
  const data = await apiPost('/auth/login', { email, password });
  if (data.token) { 
    localStorage.setItem('token', data.token); 
    localStorage.setItem('user', JSON.stringify(data.user)); 
    // Sincronizar progreso tras login
    await syncProgress();
  }
  return data;
}

async function register(name, email, password) {
  const data = await apiPost('/auth/register', { name, email, password });
  if (data.token) { localStorage.setItem('token', data.token); localStorage.setItem('user', JSON.stringify(data.user)); }
  return data;
}

function logout() { localStorage.removeItem('token'); localStorage.removeItem('user'); }
function currentUser() {
  try {
    const u = localStorage.getItem('user');
    if (!u) return null;
    const parsed = JSON.parse(u);
    if (!parsed || !parsed.id || !parsed.name) { localStorage.removeItem('user'); return null; }
    return parsed;
  } catch { localStorage.removeItem('user'); return null; }
}

async function syncProgress() {
  if (!apiToken()) return;
  try {
    const attempts = await apiGet('/attempts/me');
    const subjects = {};
    
    attempts.forEach(a => {
      const slug = a.subject?.slug;
      if (!slug) return;
      if (!subjects[slug]) subjects[slug] = {};
      
      // Si el examType es 'tema_X' y la nota >= 9.0, lo marcamos como completado
      if (a.examType && a.examType.startsWith('tema_') && a.score >= 9.0) {
        const themeNum = parseInt(a.examType.replace('tema_', ''));
        if (!isNaN(themeNum)) {
          subjects[slug][themeNum] = true;
        }
      }
    });

    // Guardar en localStorage lo recuperado
    Object.keys(subjects).forEach(slug => {
      const localProgress = getSubjectProgress(slug);
      const merged = { ...localProgress, ...subjects[slug] };
      localStorage.setItem(`progress_${slug}`, JSON.stringify(merged));
    });
    
    return true;
  } catch (e) {
    console.warn('Error sincronizando progreso:', e);
    return false;
  }
}

function getSubjectProgress(subjectSlug) {
  const progress = localStorage.getItem(`progress_${subjectSlug}`);
  return progress ? JSON.parse(progress) : {};
}

function markThemeCompleted(subjectSlug, themeNumber) {
  const progress = getSubjectProgress(subjectSlug);
  progress[themeNumber] = true;
  localStorage.setItem(`progress_${subjectSlug}`, JSON.stringify(progress));
}

function isThemeLocked(subjectSlug, themeNumber) {
  if (themeNumber <= 1) return false;
  const progress = getSubjectProgress(subjectSlug);
  // Requisito: todos los anteriores aprobados con 9
  for (let i = 1; i < themeNumber; i++) {
    if (!progress[i]) return true;
  }
  return false;
}

async function applyProgression(subjectSlug) {
  // Intentar sincronizar si hay usuario
  if (apiToken()) {
    await syncProgress();
  }

  const cards = Array.from(document.querySelectorAll('.list-card'));
  const progress = getSubjectProgress(subjectSlug);
  
  // Contar cuántos temas numéricos hay
  const totalThemes = cards.filter(c => {
    const b = c.querySelector('.number-badge');
    if (!b) return false;
    const text = b.innerText.trim();
    return !isNaN(parseInt(text));
  }).length;

  let completedCount = 0;
  for (let i = 1; i <= totalThemes; i++) {
    if (progress[i]) completedCount++;
  }

  const allThemesDone = completedCount >= totalThemes;

  cards.forEach(card => {
    const badge = card.querySelector('.number-badge');
    if (!badge) return;
    
    const badgeText = badge.innerText.trim();
    const themeNum = parseInt(badgeText);
    
    let locked = false;
    let lockReason = '';

    if (!isNaN(themeNum)) {
      if (isThemeLocked(subjectSlug, themeNum)) {
        locked = true;
        lockReason = 'Consigue un 9 en el tema anterior para desbloquear';
      }
    } else if (badgeText === 'E') {
      if (!allThemesDone) {
        locked = true;
        lockReason = 'Consigue un 9 en TODOS los temas para desbloquear el examen real';
      }
    }

    if (locked) {
      card.classList.add('locked-card');
      card.style.opacity = '0.6';
      card.style.filter = 'grayscale(1)';
      card.style.pointerEvents = 'none';
      card.style.cursor = 'not-allowed';
      card.setAttribute('title', lockReason);
      
      // Añadir candado al título si no existe
      const title = card.querySelector('h3');
      if (title && !title.querySelector('.lock-icon')) {
        title.innerHTML += ` <span class="lock-icon" style="color: #f59e0b; margin-left: 8px;">🔒</span>`;
      }

      // Cambiar texto del botón "Iniciar"
      const btnContainer = card.querySelector('.hidden.sm\\:flex') || card.querySelector('.flex.shrink-0');
      if (btnContainer) {
        const btnText = btnContainer.querySelector('span');
        if (btnText) {
          btnText.innerHTML = 'Bloqueado';
          btnText.style.color = '#9ca3af'; // Gris
        }
      }
    }
  });
}
