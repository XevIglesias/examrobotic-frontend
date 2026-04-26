# Safe script to fix headers and branding without using literal emojis in the script

$menuHeader = @"
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
                    <p id="q-progress" class="text-[10px] font-bold text-muted uppercase tracking-widest mt-1">Preparando examen...</p>
                </div>
            </div>
            
            <div class="flex items-center gap-4">
                <div id="timer" class="timer-box px-4 py-2 bg-slate-900 text-white rounded-lg font-mono font-bold text-lg">50:00</div>
                <div id="auth-header-area"></div>
            </div>
        </div>
    </header>
"@

$files = Get-ChildItem -Path "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. Favicon and Title
    $content = $content -replace '<link rel="icon" href=".*?favicon\.svg(\?v=3)?" type="image/svg\+xml">', "<link rel=`"icon`" href=`"../../assets/img/robot-avatar.jpg`" type=`"image/jpeg`">"
    if ($content -match '<title>(.*?)<\/title>') {
        $t = $matches[1]
        if ($t -notlike "*EXAMROBOTIC*") {
            $content = $content -replace '<title>.*?<\/title>', "<title>EXAMROBOTIC - $t</title>"
        }
    }

    # 2. Header
    $h = if ($file.Name -like "test*") { $menuHeader } else { $quizHeader }
    $content = [regex]::Replace($content, '(?s)<header[^>]*>.*?</header>', $h)

    # 3. Tailwind in Quizzes
    if ($file.Name -notlike "test*") {
        if ($content -notlike "*cdn.tailwindcss.com*") {
            $content = $content -replace '</head>', "<script src=`"https://cdn.tailwindcss.com`"></script>`n</head>"
        }
    }

    # 4. Cleanup corrupted chars (regex with hex is safer)
    # This is a bit complex but let's try a simple string replace for the most common ones
    # We avoid using the literal corrupted chars in this script's SOURCE code.
    # Instead we'll use [regex]::Replace to find them.
    # Actually, the simplest way is to replace the whole sidebar block if it looks broken.
    
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}

# Root files
$rootFiles = Get-ChildItem -Path "*.html"
foreach ($file in $rootFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $content = $content.Replace("Grado Superior de Rob&oacute;tica y<br class=`"md:hidden`"> Automatizaci&oacute;n Industrial", "EXAMROBOTIC")
    $content = $content.Replace("Tests de Pr&aacute;ctica", "Plataforma Test")
    $content = $content.Replace("GRADO SUPERIOR", "PLATAFORMA TEST")
    $content = $content -replace '<link rel="icon" href=".*?favicon\.svg(\?v=3)?" type="image/svg\+xml">', "<link rel=`"icon`" href=`"assets/img/robot-avatar.jpg`" type=`"image/jpeg`">"
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
