# Script to fix ALL arrows and enforce EXAMROBOTIC branding

$files = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. Fix Left Arrows (Back button)
    # â† is common corruption of ←
    $content = $content.Replace("â† ", "&larr;")
    $content = $content.Replace("â†", "&larr;")
    $content = $content.Replace("←", "&larr;")

    # 2. Fix Right Arrows (Next/Iniciar buttons)
    $content = $content.Replace("â†’", "&rarr;")
    $content = $content.Replace("→", "&rarr;")

    # 3. Enforce Branding formatting in Header
    $branding = 'EXAM<span class="text-primary">ROBOTIC</span>'
    $content = [regex]::Replace($content, 'EXAM\s*<span[^>]*>\s*ROBOTIC\s*<\/span>', $branding)
    $content = [regex]::Replace($content, 'EXAM\s*ROBOTIC', $branding)

    # 4. Enforce Uppercase in Titles
    if ($content -match '<title>(.*?)<\/title>') {
        $t = $matches[1]
        $t = $t.Replace("ExamRobotic", "EXAMROBOTIC")
        $t = $t.Replace("examrobotic", "EXAMROBOTIC")
        $content = $content -replace '<title>.*?<\/title>', "<title>$t</title>"
    }

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
