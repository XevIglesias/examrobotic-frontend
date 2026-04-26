# script to fix headers, favicons and inject tailwind in quiz pages (safe version)

$newHeaderMenu = @"
    <header class="bg-white border-b border-border sticky top-0 z-50 shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-20 flex items-center justify-between">
            <div class="flex items-center gap-3 cursor-pointer" onclick="window.location.href='/'">
                <div class="relative">
                    <img src="../../assets/img/robot-avatar.jpg" class="w-12 h-12 rounded-xl object-cover shadow-lg shadow-primary/20 border border-blue-100" alt="Logo">
                    <div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>
                </div>
                <div>
                    <h1 class="text-xl font-black tracking-tighter text-foreground leading-none">EXAM<span class="text-primary">ROBOTIC</span></h1>
                    <p class="text-[10px] font-bold text-muted uppercase tracking-widest mt-1">Plataforma Test</p>
                </div>
            </div>
            <div id="auth-header-area"></div>
        </div>
    </header>
"@

# --- 1. Update Favicon Link globally ---
$allHtmlFiles = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $allHtmlFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Change favicon
    if ($content -match '<link rel="icon" href="(.*?)favicon\.svg(\?v=3)?" type="image/svg\+xml">') {
        $path = $matches[1]
        $content = $content -replace '<link rel="icon" href=".*?favicon\.svg(\?v=3)?" type="image/svg\+xml">', "<link rel=`"icon`" href=`"${path}robot-avatar.jpg`" type=`"image/jpeg`">"
    }
    
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}

# --- 2. Update Headers in Menus and Quizzes ---
$subFiles = Get-ChildItem -Path "asignaturas/**/*.html" -Recurse
foreach ($file in $subFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace header
    if ($content -match '(?s)<header[^>]*>.*?</header>') {
        $content = [regex]::Replace($content, '(?s)<header[^>]*>.*?</header>', $newHeaderMenu)
    }

    # Inject Tailwind in quizzes
    if ($file.Name -notlike "test*") {
        if ($content -notlike "*cdn.tailwindcss.com*") {
            $content = $content -replace '</head>', "<script src=`"https://cdn.tailwindcss.com`"></script>`n</head>"
        }
    }

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
