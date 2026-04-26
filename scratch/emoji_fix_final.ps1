# Cleanup emojis using hex/utf32 to avoid script encoding issues

$files = Get-ChildItem -Path "asignaturas/**/*.html" -Recurse
$loud = [char]::ConvertFromUtf32(0x1F4E2)
$chart = [char]::ConvertFromUtf32(0x1F4C8)

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace anything in <span class="text-lg">...</span> that isn't already the correct emoji
    $content = $content -replace '<span class="text-lg">.*?Izquierdo.*?</span>', "<span class=`"text-lg`">$loud</span>"
    # Actually simpler: replace by searching for the broken spans
    $content = [regex]::Replace($content, '<span class="text-lg">[^<]*?</span>(?=\s*</div>\s*<p class="text-\[10px\] italic leading-tight">Banner Lateral<br>Izquierdo</p>)', "<span class=`"text-lg`">$loud</span>")
    $content = [regex]::Replace($content, '<span class="text-lg">[^<]*?</span>(?=\s*</div>\s*<p class="text-\[10px\] italic leading-tight">Banner Lateral<br>Derecho</p>)', "<span class=`"text-lg`">$chart</span>")

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
