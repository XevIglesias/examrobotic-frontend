# Script to enforce tailwind config and fix consistency

$configLink = '<script src="{REL}assets/js/tailwind-config.js"></script>'

$files = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $rel = if ($file.FullName -match 'asignaturas') { '../../' } else { '' }
    $cl = $configLink.Replace("{REL}", $rel)

    # 1. Ensure Tailwind Config is loaded after tailwind script
    if ($content -match 'cdn.tailwindcss.com') {
        if ($content -notlike "*tailwind-config.js*") {
            $content = $content -replace '(<script src=".*?cdn.tailwindcss.com.*?"><\/script>)', "`$1`n    $cl"
        }
    }

    # 2. Fix Header Branding - Ensure EXAM and ROBOTIC have correct classes
    # Some files might have different structures, let's unify the inner branding
    $brandingPattern = 'EXAM<span class="text-primary">ROBOTIC<\/span>'
    $content = [regex]::Replace($content, 'EXAM\s*<span[^>]*>\s*ROBOTIC\s*<\/span>', $brandingPattern)
    $content = [regex]::Replace($content, 'EXAMROBOTIC', $brandingPattern)

    # 3. Fix Arrows globally - use entity &rarr;
    $content = [regex]::Replace($content, '<span class="arrow-icon">.*?<\/span>', '<span class="arrow-icon">&rarr;</span>')

    # 4. Cleanup any corrupted arrow characters that escaped the span
    $content = $content.Replace("â†’", "&rarr;")

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
