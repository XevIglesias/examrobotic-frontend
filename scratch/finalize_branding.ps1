$files = Get-ChildItem -Path . -Filter *.html -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # 1. Update favicon to favicon.png
    $newContent = $content -replace 'href="([^"]*)robot-avatar\.png"', 'href="$1favicon.png"'
    
    # 2. Remove green circle
    $newContent = $newContent -replace '<div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>', ''
    
    if ($content -ne $newContent) {
        $newContent | Set-Content $file.FullName
        Write-Host "Updated $($file.FullName)"
    }
}
