# Script para hacer invisibles todos los enlaces que apuntan a conocenos/index.html y vacantes/index.html

$files = Get-ChildItem -Path "c:\Logs\portal\macsoftware\be-it.com.mx" -Recurse -File -Filter "*.html"

foreach ($file in $files) {
    Write-Host "Procesando: $($file.FullName)"
    
    # Leer el contenido del archivo
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    
    # Reemplazar los enlaces a conocenos/index.html con CSS para hacerlos invisibles
    $content = $content -replace '(<a\s+href="[^"]*conocenos/index.html"[^>]*>)(.*?)(</a>)', '<span style="display:none;">$2</span>'
    $content = $content -replace '(<A\s+HREF="[^"]*conocenos/index.html"[^>]*>)(.*?)(</A>)', '<span style="display:none;">$2</span>'
    
    # Reemplazar los enlaces a vacantes/index.html con CSS para hacerlos invisibles
    $content = $content -replace '(<a\s+href="[^"]*vacantes/index.html"[^>]*>)(.*?)(</a>)', '<span style="display:none;">$2</span>'
    $content = $content -replace '(<A\s+HREF="[^"]*vacantes/index.html"[^>]*>)(.*?)(</A>)', '<span style="display:none;">$2</span>'
    
    # Eliminar elementos de menú que contienen enlaces a conocenos/index.html
    $content = $content -replace '<li\s+id="menu-item-486"[^>]*>.*?</li>', ''
    
    # Eliminar elementos de menú que contienen enlaces a vacantes/index.html
    $content = $content -replace '<li\s+id="menu-item-485"[^>]*>.*?</li>', ''
    
    # Guardar el archivo solo si hubo cambios
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Force
        Write-Host "Modificado: $($file.FullName)"
    }
}

Write-Host "Proceso completado. Todos los enlaces a 'conocenos/index.html' y 'vacantes/index.html' han sido hechos invisibles."