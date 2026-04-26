$files = Get-ChildItem -Path . -Filter *.html -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Update favicon link with version parameter to force refresh
    $newContent = $content -replace 'href="([^"]*)favicon\.png"', 'href="$1favicon.png?v=3"'
    
    if ($content -ne $newContent) {
        $newContent | Set-Content $file.FullName
        Write-Host "Updated $($file.FullName)"
    }
}
