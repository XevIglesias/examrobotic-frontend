# Final cleanup script to fix emojis and layout tweaks without special characters in script

$sbL = @"
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
"@

$sbR = @"
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
"@

# Fix ads in all files using a block-based replacement
$files = Get-ChildItem -Path "asignaturas/**/*.html" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace the left sidebar block if it exists
    if ($content -match '(?s)<!-- Sidebar Izquierdo.*?<\/aside>') {
        $content = [regex]::Replace($content, '(?s)<!-- Sidebar Izquierdo.*?<\/aside>', $sbL)
    }
    
    # Replace the right sidebar block if it exists
    if ($content -match '(?s)<!-- Sidebar Derecho.*?<\/aside>') {
        $content = [regex]::Replace($content, '(?s)<!-- Sidebar Derecho.*?<\/aside>', $sbR)
    }

    # Fix tildes and other common corrupted chars
    $content = $content.Replace("Ã³", "ó").Replace("Ã¡", "á").Replace("Ã©", "é").Replace("Ã­", "í").Replace("Ãº", "ú").Replace("Ã±", "ñ").Replace("Ã³", "ó")
    
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
