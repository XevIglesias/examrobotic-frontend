# Global branding and quiz fix script

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

$quizHeader = @"
    <header class="bg-white border-b border-border sticky top-0 z-50 shadow-sm">
        <div class="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8 h-20 flex items-center justify-between">
            <div class="flex items-center gap-3 cursor-pointer" onclick="window.location.href='/'">
                <div class="relative">
                    <img src="../../assets/img/robot-avatar.jpg" class="w-12 h-12 rounded-xl object-cover shadow-lg shadow-primary/20 border border-blue-100" alt="Logo">
                    <div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>
                </div>
                <div class="hidden sm:block">
                    <h1 class="text-xl font-black tracking-tighter text-foreground leading-none">EXAM<span class="text-primary">ROBOTIC</span></h1>
                    <p id="q-progress" class="text-[10px] font-bold text-muted uppercase tracking-widest mt-1">Preparando...</p>
                </div>
            </div>
            
            <div class="flex items-center gap-4">
                <div id="timer" class="timer-box px-4 py-2 bg-slate-900 text-white rounded-lg font-mono font-bold text-lg">50:00</div>
                <div id="auth-header-area"></div>
            </div>
        </div>
    </header>
"@

# --- 1. Update Favicons and Titles globally ---
$allHtmlFiles = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $allHtmlFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Change favicon link
    $content = $content -replace '<link rel="icon" href=".*?favicon\.svg(\?v=3)?" type="image/svg\+xml">', "<link rel=`"icon`" href=`"$(if ($file.FullName -match 'asignaturas') { '../../' } else { '' })assets/img/robot-avatar.jpg`" type=`"image/jpeg`">"
    
    # Update Page Title
    if ($content -match '<title>(.*?)<\/title>') {
        $oldTitle = $matches[1]
        if ($oldTitle -notlike "*EXAMROBOTIC*") {
            $content = $content -replace '<title>.*?<\/title>', "<title>EXAMROBOTIC - $oldTitle</title>"
        }
    }

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}

# --- 2. Update Headers and Inject Tailwind ---
$subFiles = Get-ChildItem -Path "asignaturas/**/*.html" -Recurse
foreach ($file in $subFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Choose header type
    $h = if ($file.Name -like "test*") { $newHeaderMenu } else { $quizHeader }
    
    # Replace header
    if ($content -match '(?s)<header[^>]*>.*?</header>') {
        $content = [regex]::Replace($content, '(?s)<header[^>]*>.*?</header>', $h)
    }

    # Inject Tailwind and Manrope font in quizzes
    if ($file.Name -notlike "test*") {
        if ($content -notlike "*cdn.tailwindcss.com*") {
            $content = $content -replace '</head>', "<script src=`"https://cdn.tailwindcss.com`"></script>`n<link href=`"https://fonts.googleapis.com/css2?family=Manrope:wght@400;700;800&display=swap`" rel=`"stylesheet`">`n</head>"
        }
    }

    # Safe Emoji/Character fix
    # Using hex codes for characters to avoid PowerShell encoding mess
    $content = $content.Replace("ðŸ“¢", "📢").Replace("ðŸ“ˆ", "📈").Replace("â ±", "⏱").Replace("â†’", "→").Replace("Ã³", "ó").Replace("Ã¡", "á").Replace("Ã©", "é").Replace("Ã­", "í").Replace("Ãº", "ú").Replace("Ã±", "ñ")

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}

# Root files branding fix (subtitle)
$rootFiles = Get-ChildItem -Path "*.html"
foreach ($file in $rootFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $content = $content.Replace("Grado Superior de Rob&oacute;tica y<br class=`"md:hidden`"> Automatizaci&oacute;n Industrial", "EXAMROBOTIC")
    $content = $content.Replace("Tests de Pr&aacute;ctica", "Plataforma Test")
    $content = $content.Replace("GRADO SUPERIOR", "PLATAFORMA TEST")
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
