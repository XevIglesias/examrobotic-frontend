# cleanup corrupted characters in all html files

$files = Get-ChildItem -Path "asignaturas/**/*.html" -Recurse
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $c = $c.Replace("â ±", "⏱").Replace("ðŸ“¢", "📢").Replace("ðŸ“ˆ", "📈").Replace("ðŸ’¡", "💡").Replace("MenÃº", "Men&uacute;")
    [System.IO.File]::WriteAllText($f.FullName, $c, [System.Text.Encoding]::UTF8)
}
