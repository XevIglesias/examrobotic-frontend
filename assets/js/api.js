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
  if (data.token) { localStorage.setItem('token', data.token); localStorage.setItem('user', JSON.stringify(data.user)); }
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
  // Requisito: todos los anteriores aprobados con 10
  for (let i = 1; i < themeNumber; i++) {
    if (!progress[i]) return true;
  }
  return false;
}

function applyProgression(subjectSlug) {
  const cards = Array.from(document.querySelectorAll('.list-card'));
  const progress = getSubjectProgress(subjectSlug);
  
  // Contar cuántos temas numéricos hay
  const totalThemes = cards.filter(c => {
    const b = c.querySelector('.number-badge');
    return b && !isNaN(parseInt(b.innerText));
  }).length;

  let completedCount = 0;
  for (let i = 1; i <= totalThemes; i++) {
    if (progress[i]) completedCount++;
  }

  const allThemesDone = completedCount === totalThemes;

  cards.forEach(card => {
    const badge = card.querySelector('.number-badge');
    if (!badge) return;
    
    const badgeText = badge.innerText.trim();
    const themeNum = parseInt(badgeText);
    
    let locked = false;
    let lockReason = '';

    if (!isNaN(themeNum)) {
      // Es un tema numérico
      if (isThemeLocked(subjectSlug, themeNum)) {
        locked = true;
        lockReason = 'Consigue un 10 en el tema anterior para desbloquear';
      }
    } else if (badgeText === 'E') {
      // Es el examen REAL
      if (!allThemesDone) {
        locked = true;
        lockReason = 'Consigue un 10 en TODOS los temas para desbloquear el examen real';
      }
    }

    if (locked) {
      card.classList.add('locked-card');
      card.style.opacity = '0.5';
      card.style.filter = 'grayscale(1)';
      card.style.pointerEvents = 'none';
      card.style.cursor = 'not-allowed';
      card.title = lockReason;
      
      const title = card.querySelector('h3');
      if (title && !title.innerHTML.includes('🔒')) title.innerHTML += ' 🔒';

      const btn = card.querySelector('.hidden.sm\\:flex span');
      if (btn) {
        btn.innerText = 'Bloqueado';
        btn.classList.remove('text-primary');
        btn.classList.add('text-gray-400');
      }
    }
  });
}
