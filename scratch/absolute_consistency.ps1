# Master script for absolute consistency

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
            {RIGHT}
        </div>
    </header>
"@

$backButton = @"
        <div class="mb-10 flex items-start sm:items-center gap-4 border-b border-border pb-6">
            <button onclick="window.history.back()" class="w-10 h-10 shrink-0 bg-white border border-border rounded-full flex items-center justify-center hover:bg-gray-50 transition-colors mt-1 sm:mt-0" title="Volver">
                <span class="text-xl leading-none font-bold text-muted">&larr;</span>
            </button>
            <div class="flex-grow">
"@

$files = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $rel = if ($file.FullName -match 'asignaturas') { '../../' } else { '' }
    
    # 1. Replace Header
    $right = if ($file.Name -match '\.PTT\.') { 
        @"
            <div class="flex items-center gap-6">
                <div class="hidden md:flex flex-col items-end">
                    <span id="q-progress" class="text-[10px] font-bold text-primary uppercase tracking-widest">Cargando...</span>
                    <div class="h-1.5 w-32 bg-gray-100 rounded-full mt-1 overflow-hidden">
                        <div id="progress-bar" class="h-full bg-primary transition-all duration-300" style="width: 0%"></div>
                    </div>
                </div>
                <div id="timer" class="timer-box px-4 py-2 bg-slate-900 text-white rounded-lg font-mono font-bold text-lg shadow-lg shadow-slate-200">50:00</div>
                <div id="auth-header-area"></div>
            </div>
"@
    } else {
        '<div id="auth-header-area"></div>'
    }
    
    $fullH = $header.Replace("{REL}", $rel).Replace("{RIGHT}", $right)
    if ($content -match '(?s)<header[^>]*>.*?</header>') {
        $content = [regex]::Replace($content, '(?s)<header[^>]*>.*?</header>', $fullH)
    }

    # 2. Unify Back Button (for menus and quizzes if they have one)
    if ($content -match '(?s)<div[^>]*class="[^"]*mb-10 flex[^"]*">.*?<button.*?history\.back\(\).*?<\/button>.*?<div class="flex-grow">') {
        $content = [regex]::Replace($content, '(?s)<div[^>]*class="[^"]*mb-10 flex[^"]*">.*?<button.*?history\.back\(\).*?<\/button>.*?<div class="flex-grow">', $backButton)
    }

    # 3. Fix Layout (close flex-grow div) - Targeted at quizzes
    if ($file.Name -match '\.PTT\.') {
        if ($content -match 'flex-grow min-w-0' -and $content -notmatch '<\/div>\s*<!-- Sidebar Derecho') {
             $content = $content -replace '<!-- Sidebar Derecho', "</div>`n            <!-- Sidebar Derecho"
        }
    }

    # 4. Final Arrow Cleanup
    $content = $content.Replace("â† ", "&larr;")
    $content = $content.Replace("â†’", "&rarr;")

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
