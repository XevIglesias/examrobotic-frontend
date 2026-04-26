# Script to clean and unify all subject menu titles perfectly

$files = Get-ChildItem -Path "asignaturas/**/test*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Clean up the h2 title classes
    # We want: text-3xl md:text-5xl font-black text-foreground tracking-tight mb-1
    $pattern = '<h2[^>]*>(.*?)<\/h2>'
    if ($content -match $pattern) {
        $titleText = $matches[1]
        $newH2 = "<h2 class=`"text-3xl md:text-5xl font-black text-foreground tracking-tight mb-1`">$titleText</h2>"
        $content = [regex]::Replace($content, '<h2[^>]*>.*?<\/h2>', $newH2)
    }

    # Also ensure the header is updated with the latest branding
    $branding = '<h1 class="text-xl font-black tracking-tighter text-foreground leading-none">EXAM<span class="text-primary">ROBOTIC</span></h1>'
    $content = [regex]::Replace($content, '<h1[^>]*>.*?<\/h1>', $branding)

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
