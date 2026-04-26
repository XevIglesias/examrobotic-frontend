# very simple replace script

$sbL = @"
    <main class="flex-grow w-full py-10">
        <div class="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex flex-col xl:flex-row gap-8 items-start">
                
                <!-- Sidebar Izquierdo (Publicidad) -->
                <aside class="hidden xl:block w-[180px] shrink-0">
                    <div class="sticky top-24">
                        <div class="bg-gray-50 border-2 border-dashed border-gray-200 h-[600px] flex flex-col items-center justify-center text-center p-4 rounded-2xl">
                            <div class="text-gray-400">
                                <p class="text-[10px] font-bold uppercase tracking-widest mb-2 opacity-60">Publicidad</p>
                                <div class="w-10 h-10 bg-gray-200 rounded-full mb-4 mx-auto flex items-center justify-center">
                                    <span class="text-lg">📢</span>
                                </div>
                                <p class="text-[10px] italic leading-tight">Banner Lateral<br>Izquierdo</p>
                            </div>
                        </div>
                    </div>
                </aside>

                <!-- Contenido Principal -->
                <div class="flex-grow min-w-0">
"@

$sbR = @"
                </div>

                <!-- Sidebar Derecho (Publicidad) -->
                <aside class="hidden xl:block w-[180px] shrink-0">
                    <div class="sticky top-24">
                        <div class="bg-gray-50 border-2 border-dashed border-gray-200 h-[600px] flex flex-col items-center justify-center text-center p-4 rounded-2xl">
                            <div class="text-gray-400">
                                <p class="text-[10px] font-bold uppercase tracking-widest mb-2 opacity-60">Publicidad</p>
                                <div class="w-10 h-10 bg-gray-200 rounded-full mb-4 mx-auto flex items-center justify-center">
                                    <span class="text-lg">📈</span>
                                </div>
                                <p class="text-[10px] italic leading-tight">Banner Lateral<br>Derecho</p>
                            </div>
                        </div>
                    </div>
                </aside>

            </div>
        </div>
    </main>
"@

$menuFiles = Get-ChildItem -Path "asignaturas/*/test*.html" -Recurse
foreach ($f in $menuFiles) {
    $c = [System.IO.File]::ReadAllText($f.FullName)
    if ($c.Contains("Sidebar Izquierdo")) { continue }

    # Find the line that starts with <main
    $lines = Get-Content $f.FullName
    $newLines = @()
    foreach ($line in $lines) {
        if ($line.Trim().StartsWith("<main")) {
            $newLines += $sbL
        } elseif ($line.Trim() -eq "</main>") {
            $newLines += $sbR
        } else {
            $newLines += $line
        }
    }
    Set-Content -Path $f.FullName -Value $newLines -Encoding UTF8
}
