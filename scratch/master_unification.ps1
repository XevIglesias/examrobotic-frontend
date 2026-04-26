# Master script for total consistency and encoding fixes

$leftHeader = @"
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
"@

$rightHeaderQuiz = @"
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

$rightHeaderStandard = @"
            <div id="auth-header-area"></div>
"@

$files = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    $rel = if ($file.FullName -match 'asignaturas') { '../../' } else { '' }
    $l = $leftHeader.Replace("{REL}", $rel)
    $r = if ($file.Name -notlike "test*" -and $file.FullName -match 'asignaturas') { $rightHeaderQuiz } else { $rightHeaderStandard }
    
    $fullH = @"
    <header class="bg-white border-b border-border sticky top-0 z-50 shadow-sm">
        <div class="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8 h-20 flex items-center justify-between">
$l
$r
        </div>
    </header>
"@

    # 1. Replace Header
    if ($content -match '(?s)<header[^>]*>.*?</header>') {
        $content = [regex]::Replace($content, '(?s)<header[^>]*>.*?</header>', $fullH)
    }

    # 2. Fix Favicon
    $content = $content -replace '<link rel="icon" href=".*?favicon\.svg(\?v=3)?" type="image/svg\+xml">', "<link rel=`"icon`" href=`"${rel}assets/img/robot-avatar.jpg`" type=`"image/jpeg`">"
    $content = $content -replace '<link rel="icon" href=".*?favicon\.svg(\?v=3)?" type="image/svg\\+xml">', "<link rel=`"icon`" href=`"${rel}assets/img/robot-avatar.jpg`" type=`"image/jpeg`">"

    # 3. Fix Title
    if ($content -match '<title>(.*?)<\/title>') {
        $t = $matches[1]
        if ($t -notlike "*EXAMROBOTIC*") {
            $content = $content -replace '<title>.*?<\/title>', "<title>EXAMROBOTIC - $t</title>"
        }
    }

    # 4. Fix Arrows and Accents (ASCII codes)
    # â†’ or similar corrupted arrows
    $content = $content.Replace("$([char]0xC3)$([char]0xA2)$([char]0xE2)$([char]0x80)$([char]0xA0)$([char]0xE2)$([char]0x84)$([char]0xA2)", "&rarr;")
    $content = $content.Replace("$([char]0xC3)$([char]0xA2)$([char]0xC2)$([char]0x86)$([char]0xC2)$([char]0x92)", "&rarr;")
    $content = $content.Replace("$([char]0xE2)$([char]0x86)$([char]0x92)", "&rarr;") # Literal arrow to entity
    $content = $content.Replace("â†’", "&rarr;")
    $content = $content.Replace("â†", "&rarr;")

    # Common corrupted accents (one more pass)
    $content = $content.Replace("$([char]0xC3)$([char]0xA1)", "&aacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xA9)", "&eacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xAD)", "&iacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xB3)", "&oacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xBA)", "&uacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xB1)", "&ntilde;")

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
