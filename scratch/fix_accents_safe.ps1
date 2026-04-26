# Script to fix broken accents (ASCII only)

$files = Get-ChildItem -Path "*.html", "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace common double-encoded UTF-8 patterns with HTML entities
    # Ã¡ -> &aacute;
    $content = $content.Replace("$([char]0xC3)$([char]0xA1)", "&aacute;")
    # Ã© -> &eacute;
    $content = $content.Replace("$([char]0xC3)$([char]0xA9)", "&eacute;")
    # Ã­ -> &iacute;
    $content = $content.Replace("$([char]0xC3)$([char]0xAD)", "&iacute;")
    # Ã³ -> &oacute;
    $content = $content.Replace("$([char]0xC3)$([char]0xB3)", "&oacute;")
    # Ãº -> &uacute;
    $content = $content.Replace("$([char]0xC3)$([char]0xBA)", "&uacute;")
    # Ã± -> &ntilde;
    $content = $content.Replace("$([char]0xC3)$([char]0xB1)", "&ntilde;")
    
    # Capital versions
    $content = $content.Replace("$([char]0xC3)$([char]0x81)", "&Aacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0x89)", "&Eacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0x8D)", "&Iacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0x93)", "&Oacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0x9A)", "&Uacute;")
    $content = $content.Replace("$([char]0xC3)$([char]0x91)", "&Ntilde;")

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
