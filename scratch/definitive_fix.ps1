# DEFINITIVE fix script - No regex replacement on h1, only fix titles and arrows

$files = Get-ChildItem -Path "*.html", "asignaturas\*\*.html" -Recurse
foreach ($file in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $content = [System.Text.Encoding]::UTF8.GetString($bytes)
    
    # 1. FIX TITLE TAGS - Remove HTML span tags from inside <title>
    #    Replace: EXAM<span class="text-primary">ROBOTIC</span> inside title with EXAMROBOTIC
    $content = [regex]::Replace($content, '(<title>)(.*?)(</title>)', {
        param($m)
        $inner = $m.Groups[2].Value
        $inner = $inner -replace '<span[^>]*>', ''
        $inner = $inner -replace '</span>', ''
        $inner = $inner -replace 'EXAM\s*ROBOTIC', 'EXAMROBOTIC'
        return $m.Groups[1].Value + $inner + $m.Groups[3].Value
    })

    # 2. FIX BACK ARROWS - the corrupted left arrow character
    #    The byte sequence for corrupted arrow is: C3 A2 E2 80 A0 E2 84 A2 (or similar)
    #    Also fix: "â†" which is common corruption
    $content = $content -replace 'â†\s*</span>', '&larr;</span>'
    $content = $content -replace 'â†</span>', '&larr;</span>'
    # Also fix inline arrows that aren't in spans
    $content = $content -replace '>â†\s*<', '>&larr;<'
    $content = $content -replace '>â†<', '>&larr;<'

    # 3. FIX FAVICON - ensure all pages use robot-avatar.jpg
    $rel = if ($file.FullName -match '\\asignaturas\\') { '../../' } else { '' }
    $content = $content -replace '<link rel="icon" href="[^"]*favicon\.svg[^"]*"[^>]*>', "<link rel=`"icon`" href=`"${rel}assets/img/robot-avatar.jpg`" type=`"image/jpeg`">"

    [System.IO.File]::WriteAllBytes($file.FullName, [System.Text.Encoding]::UTF8.GetBytes($content))
}

Write-Host "Done. Fixed title tags, arrows, and favicons."
