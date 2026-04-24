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
