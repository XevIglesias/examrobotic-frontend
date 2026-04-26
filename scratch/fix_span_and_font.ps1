# Script to fix the broken span close tag and enforce consistency

$files = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. Fix the escaped span tag from previous error
    $content = $content.Replace('ROBOTIC<\/span>', 'ROBOTIC</span>')

    # 2. Fix Arrows globally - use entity &rarr; (re-verify)
    $content = [regex]::Replace($content, '<span class="arrow-icon">.*?<\/span>', '<span class="arrow-icon">&rarr;</span>')

    # 3. Ensure Manrope font is used consistently
    if ($content -notlike "*Manrope*") {
        $content = $content -replace '</head>', "<link href=`"https://fonts.googleapis.com/css2?family=Manrope:wght@400;700;800&display=swap`" rel=`"stylesheet`">`n</head>"
    }

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
