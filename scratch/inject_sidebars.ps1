# super safe script to inject sidebars

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

# --- Update Menus (test*.html) ---
$menuFiles = Get-ChildItem -Path "asignaturas/*/test*.html" -Recurse
foreach ($file in $menuFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content.Contains("Sidebar Izquierdo")) { continue }

    if ($content -match '(?s)<main[^>]*>(.*)</main>') {
        $inner = $matches[1]
        $newMain = @"
    <main class="flex-grow w-full py-10">
        <div class="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex flex-col xl:flex-row gap-8 items-start">
$sbL

                <!-- Contenido Principal -->
                <div class="flex-grow min-w-0">
$inner
                </div>

$sbR
            </div>
        </div>
    </main>
"@
        $newContent = [regex]::Replace($content, '(?s)<main[^>]*>.*</main>', $newMain)
        [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
    }
}

# --- Update Quizzes (*.PTT.*.html) ---
$quizFiles = Get-ChildItem -Path "asignaturas/*/*.html" -Recurse | Where-Object { $_.Name -notlike "test*" }
foreach ($file in $quizFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Simple extraction of quiz and results blocks
    $qMatch = [regex]::Match($content, '(?s)<div id="quiz">.*?</div>\s*(?=</div>|$)').Value
    # Results usually ends with <div style="display: flex; gap: 15px; ... </div> </div>
    $rMatch = [regex]::Match($content, '(?s)<div id="results">.*?</div>\s*</div>\s*</div>').Value
    
    # If it's already updated, we don't want to re-wrap. 
    # But if it's broken, qMatch and rMatch will still find the parts.
    
    if ($qMatch -and $rMatch) {
        $inner = "$qMatch`n`n$rMatch"
        $head = [regex]::Match($content, '(?s).*?(?=<main|<div id="quiz")').Value
        $scripts = [regex]::Match($content, '(?s)<script.*').Value
        
        $new = @"
$head
    <main class="flex-grow w-full py-10">
        <div class="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex flex-col xl:flex-row gap-8 items-start">
$sbL

                <!-- Contenido Principal -->
                <div class="flex-grow min-w-0">
$inner
                </div>

$sbR
            </div>
        </div>
    </main>

$scripts
"@
        [System.IO.File]::WriteAllText($file.FullName, $new, [System.Text.Encoding]::UTF8)
    }
}
