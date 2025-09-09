# Script para eliminar completamente los enlaces a vacantes/index.html

$files = Get-ChildItem -Path "c:\Logs\portal\macsoftware\be-it.com.mx" -Recurse -File -Filter "*.html"

foreach ($file in $files) {
    Write-Host "Procesando: $($file.FullName)"
    
    # Leer el contenido del archivo
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    
    # Eliminar completamente los enlaces a vacantes/index.html
    $content = $content -replace '<a\s+href="[^"]*vacantes/index.html"[^>]*>.*?</a>', ''
    $content = $content -replace '<A\s+HREF="[^"]*vacantes/index.html"[^>]*>.*?</A>', ''
    
    # Eliminar elementos de menú que contienen enlaces a vacantes/index.html
    $content = $content -replace '<li\s+id="menu-item-485"[^>]*>.*?</li>', ''
    $content = $content -replace '<li\s+class="[^"]*menu-item-485[^"]*"[^>]*>.*?</li>', ''
    
    # Guardar el archivo solo si hubo cambios
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Force
        Write-Host "Modificado: $($file.FullName)"
    }
}

Write-Host "Proceso completado. Todos los enlaces a 'vacantes/index.html' han sido eliminados."