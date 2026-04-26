# Script to unify headers and branding perfectly

$standardHeaderLeft = @"
            <div class="flex items-center gap-3 cursor-pointer" onclick="window.location.href='/'">
                <div class="relative">
                    <img src="{PATH}assets/img/robot-avatar.jpg" class="w-12 h-12 rounded-xl object-cover shadow-lg shadow-primary/20 border border-blue-100" alt="Logo">
                    <div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>
                </div>
                <div>
                    <h1 class="text-xl font-black tracking-tighter text-foreground leading-none">EXAM<span class="text-primary">ROBOTIC</span></h1>
                    <p class="text-[10px] font-bold text-muted uppercase tracking-widest mt-1">Plataforma Test</p>
                </div>
            </div>
"@

$quizHeaderRight = @"
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

$standardHeaderRight = @"
            <div id="auth-header-area"></div>
"@

$allHtmlFiles = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $allHtmlFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Determine relative path
    $rel = if ($file.FullName -match 'asignaturas') { '../../' } else { '' }
    $left = $standardHeaderLeft.Replace("{PATH}", $rel)
    
    # Choose right side
    $right = if ($file.Name -notlike "test*" -and $file.FullName -match 'asignaturas') { $quizHeaderRight } else { $standardHeaderRight }
    
    # Construct full header content
    $fullHeader = @"
    <header class="bg-white border-b border-border sticky top-0 z-50 shadow-sm">
        <div class="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8 h-20 flex items-center justify-between">
$left
$right
        </div>
    </header>
"@

    # Replace header
    if ($content -match '(?s)<header[^>]*>.*?</header>') {
        $content = [regex]::Replace($content, '(?s)<header[^>]*>.*?</header>', $fullHeader)
    }

    # Ensure body classes
    if ($content -match '<body[^>]*>') {
        $content = $content -replace '<body[^>]*>', '<body class="bg-background text-foreground min-h-screen flex flex-col">'
    }

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
