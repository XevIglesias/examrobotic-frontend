# Final Final consistency script with ultra-bold font and pure colors

$manropeLink = '<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">'

$files = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. Update Font Link to include 900 weight
    if ($content -match 'Manrope') {
        $content = $content -replace '<link href=".*?Manrope.*?">', $manropeLink
    } else {
        $content = $content -replace '</head>', "$manropeLink`n</head>"
    }

    # 2. Re-enforce Header Branding with font-black and correct spans
    $branding = '<h1 class="text-xl font-black tracking-tighter text-foreground leading-none">EXAM<span class="text-primary">ROBOTIC</span></h1>'
    $content = [regex]::Replace($content, '<h1[^>]*>.*?<\/h1>', $branding)

    # 3. Ensure Tailwind Config is loaded
    $rel = if ($file.FullName -match 'asignaturas') { '../../' } else { '' }
    $cl = "<script src=`"${rel}assets/js/tailwind-config.js`"></script>"
    if ($content -notlike "*tailwind-config.js*") {
        $content = $content -replace '(<script src=".*?cdn.tailwindcss.com.*?"><\/script>)', "`$1`n    $cl"
    }

    # 4. Fix Arrows and Accents (using entities for safety as requested by "tildes que no aparecen")
    $content = $content.Replace("â†’", "&rarr;")
    $content = $content.Replace("→", "&rarr;")
    
    # Final cleanup of common corrupted chars to entities
    $content = $content.Replace("$([char]0xC3)$([char]0xA1)", "&aacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xA9)", "&eacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xAD)", "&iacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xB3)", "&oacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xBA)", "&uacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0xB1)", "&ntilde;")

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
