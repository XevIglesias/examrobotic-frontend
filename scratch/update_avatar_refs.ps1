$files = Get-ChildItem -Path . -Filter *.html -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $newContent = $content -replace 'robot-avatar\.jpg', 'robot-avatar.png'
    $newContent = $newContent -replace 'type="image/jpeg"', 'type="image/png"'
    
    if ($content -ne $newContent) {
        $newContent | Set-Content $file.FullName
        Write-Host "Updated $($file.FullName)"
    }
}
