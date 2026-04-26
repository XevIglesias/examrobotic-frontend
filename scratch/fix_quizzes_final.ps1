# script to fix all quiz files using a template

$template = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Simulacro de examen del Grado Superior de Robótica y Automatización Industrial. 40 preguntas aleatorias con temporizador y corrección automática.">
    <link rel="icon" href="../../assets/img/favicon.svg?v=3" type="image/svg+xml">
<title>{{TITLE}}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../../assets/css/quiz.css">
</head>
<body class="bg-background text-foreground min-h-screen flex flex-col">

<header>
    <div>
        <h2 id="exam-title" style="font-size: 1.2rem;">{{H2}}</h2>
        <p id="q-progress" style="font-size: 0.8rem; color: #64748b;">Preparando examen...</p>
    </div>
    <div class="timer-box" id="timer">
        <span>⏱</span> <span id="time-val">50:00</span>
    </div>
</header>

<main class="flex-grow w-full py-10">
    <div class="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col xl:flex-row gap-8 items-start">
            
            <!-- Sidebar Izquierdo (Publicidad) -->
            <aside class="hidden xl:block w-[180px] shrink-0">
                <div class="sticky top-24">
                    <div class="bg-gray-50 border-2 border-dashed border-gray-200 h-[600px] flex flex-col items-center justify-center text-center p-4 rounded-2xl">
                        <div class="text-gray-400">
                            <p class="text-[10px] font-bold uppercase tracking-widest mb-2 opacity-60">Publicidad</p>
                            <div class="w-10 h-10 bg-gray-200 rounded-full mb-4 mx-auto flex items-center justify-center">
                                <span class="text-lg">📢</span>
                            </div>
                            <p class="text-[10px] italic leading-tight">Banner Lateral<br>Izquierdo</p>
                        </div>
                    </div>
                </div>
            </aside>

            <!-- Contenido Principal -->
            <div class="flex-grow min-w-0">
                <div id="quiz">
                    <div class="q-card">
                        <div id="q-unit" class="q-meta">{{UNIT}}</div>
                        <div id="q-text" class="q-text">Cargando...</div>
                        <div id="options-area" style="display: grid; gap: 10px;"></div>
                        <div id="explanation" class="exp-box"></div>
                    </div>
                    
                    <div class="nav-footer">
                        <button class="btn" style="background:#e2e8f0; color: #333;" onclick="move(-1)">Anterior</button>
                        <button class="btn btn-next" id="btn-next" onclick="move(1)">Siguiente</button>
                        <button class="btn btn-finish" id="btn-finish" style="display:none" onclick="finish()">Finalizar Examen</button>
                        <button class="btn" id="btn-menu-review" style="display:none; background: var(--primary); color: white;" onclick="window.history.back()">Volver al Menú</button>
                    </div>

                    <div class="dot-grid" id="dot-grid"></div>
                </div>

                <div id="results" style="display:none">
                    <p style="font-weight: 800; color: var(--accent); letter-spacing: 2px; text-align: center;">NOTA FINAL</p>
                    <div class="score-badge" id="res-score" style="text-align: center;">0.0</div>
                    <div class="score-sub" id="res-msg" style="text-align: center;">Resultado</div>
                    <div style="display: flex; gap: 15px; justify-content: center; margin-top: 40px; flex-wrap: wrap;">
                        <button class="btn btn-next" style="max-width:250px; background: var(--accent);" onclick="showReview()">Revisar Errores</button>
                        <button class="btn" style="max-width:250px; background:#e2e8f0; color: #333;" onclick="location.reload()">Generar Nuevo Test</button>
                        <button class="btn" style="max-width:250px; background: var(--primary); color: white;" onclick="window.history.back()">Volver al Menú</button>
                    </div>
                </div>
            </div>

            <!-- Sidebar Derecho (Publicidad) -->
            <aside class="hidden xl:block w-[180px] shrink-0">
                <div class="sticky top-24">
                    <div class="bg-gray-50 border-2 border-dashed border-gray-200 h-[600px] flex flex-col items-center justify-center text-center p-4 rounded-2xl">
                        <div class="text-gray-400">
                            <p class="text-[10px] font-bold uppercase tracking-widest mb-2 opacity-60">Publicidad</p>
                            <div class="w-10 h-10 bg-gray-200 rounded-full mb-4 mx-auto flex items-center justify-center">
                                <span class="text-lg">📈</span>
                            </div>
                            <p class="text-[10px] italic leading-tight">Banner Lateral<br>Derecho</p>
                        </div>
                    </div>
                </div>
            </aside>

        </div>
    </div>
</main>

{{DATA_SCRIPT}}
<script src="../../assets/js/api.js" defer></script>
<script src="../../assets/js/quiz-engine.js" defer></script>
<script src="../../assets/js/analytics.js"></script>
<script src="../../assets/js/cookie-cmp.js"></script>
</body>
</html>
"@

$quizFiles = Get-ChildItem -Path "asignaturas/*/*.html" -Recurse | Where-Object { $_.Name -notlike "test*" }
foreach ($file in $quizFiles) {
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Extract values
    $title = ""
    if ($c -match '<title>(.*?)</title>') { $title = $matches[1] }
    
    $h2 = ""
    if ($c -match '(?s)<h2 id="exam-title"[^>]*>(.*?)</h2>') { $h2 = $matches[1].Trim() }
    
    $unit = "UNIT"
    if ($c -match '<div id="q-unit"[^>]*>(.*?)</div>') { $unit = $matches[1] }
    
    $dataScript = ""
    if ($c -match '(<script src="../../data/.*?".*?></script>)') { $dataScript = $matches[1] }
    
    if ($title -and $h2 -and $dataScript) {
        $new = $template.Replace("{{TITLE}}", $title).Replace("{{H2}}", $h2).Replace("{{UNIT}}", $unit).Replace("{{DATA_SCRIPT}}", $dataScript)
        [System.IO.File]::WriteAllText($file.FullName, $new, [System.Text.Encoding]::UTF8)
    }
}
