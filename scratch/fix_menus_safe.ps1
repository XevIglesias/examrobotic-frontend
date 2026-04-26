# safe string replace script for menus

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
foreach ($f in $menuFiles) {
    $c = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if ($c.Contains("Sidebar Izquierdo")) { continue }

    $startTag = "<main"
    $endTag = "</main>"
    
    $startIdx = $c.IndexOf($startTag)
    $endIdx = $c.IndexOf($endTag)
    
    if ($startIdx -ge 0 -and $endIdx -gt $startIdx) {
        $head = $c.Substring(0, $startIdx)
        $foot = $c.Substring($endIdx + $endTag.Length)
        
        # Get the inner content of main
        $mainTagFull = $c.Substring($startIdx, $c.IndexOf(">", $startIdx) - $startIdx + 1)
        $inner = $c.Substring($startIdx + $mainTagFull.Length, $endIdx - ($startIdx + $mainTagFull.Length))
        
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
        $final = $head + $newMain + $foot
        [System.IO.File]::WriteAllText($f.FullName, $final, [System.Text.Encoding]::UTF8)
    }
}
