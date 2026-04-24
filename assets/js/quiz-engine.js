let activeQs = [];
let userAns = [];
let current = 0;
let timeLeft = 3000; // 50 minutos
let timerID;
let isFinished = false;

function escHtml(s) {
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#039;');
}

try {
    startExam();
} catch(e) {
    document.getElementById('q-text').innerText = 'Error al cargar: ' + e.message;
}

function startExam() {
    // Escoge 40 preguntas aleatorias de la base de 80
    let pool = [...EXAM_DATA];
    activeQs = pool.sort(() => Math.random() - 0.5).slice(0, 40);
    
    userAns = new Array(40).fill(null);
    current = 0; 
    isFinished = false; 
    timeLeft = 3000;
    
    document.getElementById('quiz').style.display = 'block';
    document.getElementById('results').style.display = 'none';
    
    clearInterval(timerID);
    timerID = setInterval(updateTime, 1000);
    showQ();
}

function updateTime() {
    if(isFinished) return;
    timeLeft--;
    let m = Math.floor(timeLeft/60);
    let s = timeLeft%60;
    document.getElementById('timer').innerText = `${m.toString().padStart(2,'0')}:${s.toString().padStart(2,'0')}`;
    if(timeLeft <= 0) finish();
}

function showQ() {
    const q = activeQs[current];
    document.getElementById('q-progress').innerText = `Pregunta ${current+1} de 40`;
    document.getElementById('q-unit').innerText = q.u;
    document.getElementById('q-text').innerText = q.q; 
    
    const area = document.getElementById('options-area');
    area.innerHTML = '';
    
    q.opts.forEach((opt, i) => {
        let cls = 'option';
        if(isFinished) {
            if(i === q.ans) cls += ' correct';
            else if(userAns[current] === i) cls += ' incorrect';
        } else {
            if(userAns[current] === i) cls += ' selected';
        }
        
        let icon = '';
        if(isFinished) {
            if(i === q.ans) icon = '<span style="margin-left:auto;font-weight:900">✓</span>';
            else if(userAns[current] === i) icon = '<span style="margin-left:auto;font-weight:900">✗</span>';
        }
        
        area.innerHTML += `<div class="${cls}" onclick="pick(${i})" onkeydown="if(event.key==='Enter'||event.key===' '){pick(${i});event.preventDefault()}" tabindex="0" role="button" aria-pressed="${userAns[current]===i}">
            <span style="opacity:0.3; margin-right:15px; font-weight:800" aria-hidden="true">${String.fromCharCode(65+i)}</span>
            ${escHtml(opt)} ${icon}
        </div>`;
    });

    const exp = document.getElementById('explanation');
    if(isFinished) {
        exp.style.display = 'block';
        exp.innerHTML = `<strong>EXPLICACIÓN:</strong> ${escHtml(q.exp)}`;
    } else {
        exp.style.display = 'none';
    }

    document.getElementById('btn-finish').style.display = (!isFinished) ? 'block' : 'none';
    document.getElementById('btn-menu-review').style.display = (isFinished) ? 'block' : 'none';
    renderDots();
}

function pick(i) {
    if(isFinished) return;
    userAns[current] = (userAns[current] === i) ? null : i;
    showQ();
}

function move(d) {
    let next = current + d;
    if(next >= 0 && next < 40) { current = next; showQ(); }
}

function renderDots() {
    const grid = document.getElementById('dot-grid');
    grid.innerHTML = '';
    activeQs.forEach((_, i) => {
        let cls = 'dot';
        if(i === current) cls += ' active';
        if(userAns[i] !== null) cls += ' done';
        grid.innerHTML += `<div class="${cls}" onclick="current=${i};showQ()" onkeydown="if(event.key==='Enter'||event.key===' '){current=${i};showQ();event.preventDefault()}" tabindex="0" role="button" aria-label="Pregunta ${i+1}">${i+1}</div>`;
    });
}

function finish() {
    clearInterval(timerID);
    isFinished = true;
    let score = 0;
    userAns.forEach((a, i) => {
        if(a === activeQs[i].ans) score += 1;
        else if(a !== null) score -= 0.333333; 
    });
    
    let final = Math.max(0, (score / 40) * 10).toFixed(2);

    const slug = document.querySelector('script[src*="data/"]')?.src.match(/data\/(\w+)\//)?.[1] || 'unknown';
    const timeSpent = 3000 - timeLeft;
    if (typeof saveAttempt === 'function') saveAttempt(slug, 'real', parseFloat(final), score, timeSpent, userAns);

    document.getElementById('quiz').style.display = 'none';
    document.getElementById('results').style.display = 'block';
    document.getElementById('res-score').innerText = final;
    document.getElementById('res-msg').innerText = final >= 5.00 ? "¡APTO! Has superado el umbral del 5." : "NO APTO. Repasa la teoría.";
}

function showReview() {
    current = 0;
    document.getElementById('results').style.display = 'none';
    document.getElementById('quiz').style.display = 'block';
    showQ();
}
