import os
import re

dt_dir = 'asignaturas/dt'
files = [f for f in os.listdir(dt_dir) if f.endswith('.html') and f != 'testDT.D.01.html']

header_old = r'<div class="flex items-center gap-6">\s*<div id="auth-header-area"></div>\s*</div>'
header_new = """<!-- Progreso (centro) -->
            <div class="flex flex-col items-center justify-center gap-1.5">
                <span id="q-progress" class="text-[11px] font-extrabold text-primary uppercase tracking-widest">Cargando...</span>
                <div class="h-2 w-52 bg-gray-100 rounded-full overflow-hidden">
                    <div id="progress-bar" class="h-full bg-primary transition-all duration-500 rounded-full" style="width: 0%"></div>
                </div>
            </div>

            <!-- Timer (derecha) -->
            <div class="flex items-center justify-end">
                <div id="timer" class="timer-box">50:00</div>
                <div id="auth-header-area"></div>
            </div>"""

for filename in files:
    path = os.path.join(dt_dir, filename)
    with open(path, 'rb') as f:
        content = f.read()
    
    # Try to decode, if fails, use latin-1 as fallback which is common for broken Spanish text
    try:
        text = content.decode('utf-8')
    except UnicodeDecodeError:
        text = content.decode('latin-1')
    
    # Replace header
    text = re.sub(header_old, header_new, text, flags=re.DOTALL)
    
    # Replace main padding
    text = text.replace('<main class="flex-grow w-full py-10">', '<main class="flex-grow w-full pt-0 pb-10">')
    
    # Fix common broken characters if found (optional but good)
    # text = text.replace('', 'é') # risky
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)

print(f"Fixed {len(files)} files.")
