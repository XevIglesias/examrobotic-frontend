# Script to fix missing closing tags in quiz files and ensure consistency

$files = Get-ChildItem -Path "asignaturas/**/*.PTT.*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. Fix the unclosed flex-grow div before the right sidebar
    if ($content -match '<div class="flex-grow min-w-0">') {
        if ($content -notmatch '<\/div>\s*<!-- Sidebar Derecho') {
            $content = $content -replace '(<!-- Sidebar Derecho)', "</div>`n            $1"
        }
    }

    # 2. Re-verify Arrows (Left & Right)
    $content = $content.Replace("â† ", "&larr;")
    $content = $content.Replace("â†’", "&rarr;")

    # 3. Re-verify Branding
    $branding = '<h1 class="text-xl font-black tracking-tighter text-foreground leading-none">EXAM<span class="text-primary">ROBOTIC</span></h1>'
    $content = [regex]::Replace($content, '<h1[^>]*>.*?<\/h1>', $branding)

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
