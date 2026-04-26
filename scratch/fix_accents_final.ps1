# Script to fix broken accents (UTF-8 corruption) globally

$map = @{
    "$([char]0xC3)$([char]0xA1)" = "á"
    "$([char]0xC3)$([char]0xA9)" = "é"
    "$([char]0xC3)$([char]0xAD)" = "í"
    "$([char]0xC3)$([char]0xB3)" = "ó"
    "$([char]0xC3)$([char]0xBA)" = "ú"
    "$([char]0xC3)$([char]0xB1)" = "ñ"
    "$([char]0xC3)$([char]0x81)" = "Á"
    "$([char]0xC3)$([char]0x89)" = "É"
    "$([char]0xC3)$([char]0x8D)" = "Í"
    "$([char]0xC3)$([char]0x93)" = "Ó"
    "$([char]0xC3)$([char]0x9A)" = "Ú"
    "$([char]0xC3)$([char]0x91)" = "Ñ"
    "RobÃ³tica" = "Robótica"
    "AutomatizaciÃ³n" = "Automatización"
    "automÃ¡tica" = "automática"
    "PrÃ¡ctica" = "Práctica"
}

$files = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    # Read as Latin1 to catch the raw bytes that were misinterpreted
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::GetEncoding("Windows-1252"))
    
    # If the file was double-encoded, it might look like ÃƒÂ³
    # But usually it's just misinterpreted UTF-8.
    
    # Try to fix the most common patterns
    foreach ($key in $map.Keys) {
        $content = $content.Replace($key, $map[$key])
    }

    # Save as UTF-8 WITH BOM to ensure Windows/Browsers detect it correctly
    $utf8NoBOM = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBOM)
}
