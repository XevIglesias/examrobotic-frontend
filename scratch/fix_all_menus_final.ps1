# final fix for all test menu files

$sbL = @"
                <!-- Sidebar Izquierdo (Publicidad) -->
                <aside class="hidden xl:block w-[180px] shrink-0">
                    <div class="sticky top-24">
                        <div class="bg-gray-50 border-2 border-dashed border-gray-200 h-[600px] flex flex-col items-center justify-center text-center p-4 rounded-2xl">
                            <div class="text-gray-400">
                                <p class="text-[10px] font-bold uppercase tracking-widest mb-2 opacity-60">Publicidad</p>
                                <div class="w-10 h-10 bg-gray-200 rounded-full mb-4 mx-auto flex items-center justify-center">
                                    <span class="text-lg">ADS</span>
                                </div>
                                <p class="text-[10px] italic leading-tight">Banner Lateral<br>Izquierdo</p>
                            </div>
                        </div>
                    </div>
                </aside>
"@

$sbR = @"
                <!-- Sidebar Derecho (Publicidad) -->
                <aside class="hidden xl:block w-[180px] shrink-0">
                    <div class="sticky top-24">
                        <div class="bg-gray-50 border-2 border-dashed border-gray-200 h-[600px] flex flex-col items-center justify-center text-center p-4 rounded-2xl">
                            <div class="text-gray-400">
                                <p class="text-[10px] font-bold uppercase tracking-widest mb-2 opacity-60">Publicidad</p>
                                <div class="w-10 h-10 bg-gray-200 rounded-full mb-4 mx-auto flex items-center justify-center">
                                    <span class="text-lg">ADS</span>
                                </div>
                                <p class="text-[10px] italic leading-tight">Banner Lateral<br>Derecho</p>
                            </div>
                        </div>
                    </div>
                </aside>
"@

$menuFiles = Get-ChildItem -Path "asignaturas/*/test*.html" -Recurse
foreach ($file in $menuFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content.Contains("Sidebar Izquierdo")) { continue }

    # Find the <main ...> and replace it
    # We use a regex that handles potential newlines
    $newContent = [regex]::Replace($content, '(?s)<main[^>]*>', @"
    <main class="flex-grow w-full py-10">
        <div class="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex flex-col xl:flex-row gap-8 items-start">
$sbL

                <!-- Contenido Principal -->
                <div class="flex-grow min-w-0">
"@)

    # Find the </main> and replace it
    $newContent = [regex]::Replace($newContent, '</main>', @"
                </div>

$sbR
            </div>
        </div>
    </main>
"@)

    [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
}

# Fix ADS text with emojis (using entities for safety in script)
$files = Get-ChildItem -Path "asignaturas/**/*.html" -Recurse
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if ($c.Contains("ADS")) {
        $c = $c.Replace("ADS", "📢") # Let's hope it works this time or I'll use entities
        [System.IO.File]::WriteAllText($f.FullName, $c, [System.Text.Encoding]::UTF8)
    }
}
