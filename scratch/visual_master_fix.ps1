# Master script for absolute consistency and visual enhancement

$header = @"
    <header class="bg-white border-b border-border sticky top-0 z-50 shadow-sm">
        <div class="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8 h-20 flex items-center justify-between">
            <div class="flex items-center gap-3 cursor-pointer" onclick="window.location.href='/'">
                <div class="relative">
                    <img src="{REL}assets/img/robot-avatar.jpg" class="w-12 h-12 rounded-xl object-cover shadow-lg shadow-primary/20 border border-blue-100" alt="Logo">
                    <div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>
                </div>
                <div>
                    <h1 class="text-xl font-black tracking-tighter text-foreground leading-none">EXAM<span class="text-primary">ROBOTIC</span></h1>
                    <p class="text-[10px] font-bold text-muted uppercase tracking-widest mt-1">Plataforma Test</p>
                </div>
            </div>
            <div class="flex items-center gap-6">
                {EXTRA_RIGHT}
                <div id="auth-header-area"></div>
            </div>
        </div>
    </header>
"@

$files = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $rel = if ($file.FullName -match 'asignaturas') { '../../' } else { '' }
    
    # 1. Replace Header with consistent structure
    $extraRight = ""
    if ($file.Name -match '\.PTT\.') {
        $extraRight = @"
                <div class="hidden md:flex flex-col items-end">
                    <span id="q-progress" class="text-[10px] font-bold text-primary uppercase tracking-widest">Cargando...</span>
                    <div class="h-1.5 w-32 bg-gray-100 rounded-full mt-1 overflow-hidden">
                        <div id="progress-bar" class="h-full bg-primary transition-all duration-300" style="width: 0%"></div>
                    </div>
                </div>
                <div id="timer" class="timer-box px-4 py-2 bg-slate-900 text-white rounded-lg font-mono font-bold text-lg shadow-lg shadow-slate-200">50:00</div>
"@
    }
    $fullH = $header.Replace("{REL}", $rel).Replace("{EXTRA_RIGHT}", $extraRight)
    if ($content -match '(?s)<header[^>]*>.*?</header>') {
        $content = [regex]::Replace($content, '(?s)<header[^>]*>.*?</header>', $fullH)
    }

    # 2. Ensure Auth Scripts are loaded
    if ($content -notlike "*auth-ui.js*") {
        $content = $content -replace '(<\/body>)', "`n    <script src=`"${rel}assets/js/api.js`"></script>`n    <script src=`"${rel}assets/js/auth-ui.js`"></script>`n$1"
    }

    # 3. Enhance Module Card titles in Index.html
    if ($file.Name -eq "index.html") {
        $content = $content.Replace('class="text-xl font-bold mb-2', 'class="text-2xl font-black text-foreground mb-2')
    }

    # 4. Enhance Subject Menu titles in test*.html
    if ($file.Name -match '^test.*\.html$') {
         $content = $content.Replace('class="text-3xl md:text-4xl font-extrabold', 'class="text-3xl md:text-5xl font-black text-foreground tracking-tight')
    }

    # 5. Fix Arrows & Accents
    $content = $content.Replace("â† ", "&larr;")
    $content = $content.Replace("â†’", "&rarr;")

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
