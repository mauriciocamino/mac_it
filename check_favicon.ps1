# Script para verificar si los favicons han sido reemplazados correctamente

$rootDir = "c:\Logs\portal\macsoftware\be-it.com.mx"
$newFaviconPath = "wp-content/uploads/elementor/thumbs/logo-beit-blanco-prh5ro17598lil95tigwxvh6h12mv7inly0bf22134.png"

# Verificar el archivo index.html
$indexPath = Join-Path -Path $rootDir -ChildPath "index.html"
$content = Get-Content -Path $indexPath -Raw

# Buscar las etiquetas de favicon
$iconTags = [regex]::Matches($content, '<link\s+rel="icon"[^>]*>')

Write-Host "Verificando archivo: $indexPath"
Write-Host "Etiquetas de favicon encontradas: $($iconTags.Count)"

foreach ($tag in $iconTags) {
    Write-Host "\nEtiqueta: $($tag.Value)"
    
    # Verificar si contiene la nueva ruta
    if ($tag.Value -like "*$newFaviconPath*") {
        Write-Host "✓ La etiqueta contiene la nueva ruta del favicon" -ForegroundColor Green
    } else {
        Write-Host "✗ La etiqueta NO contiene la nueva ruta del favicon" -ForegroundColor Red
    }
}

# Verificar también un archivo en un subdirectorio
$subDirFile = Join-Path -Path $rootDir -ChildPath "servicios\fabrica-de-software\index.html"
$subDirContent = Get-Content -Path $subDirFile -Raw

# Buscar las etiquetas de favicon
$subDirIconTags = [regex]::Matches($subDirContent, '<link\s+rel="icon"[^>]*>')

Write-Host "\n\nVerificando archivo: $subDirFile"
Write-Host "Etiquetas de favicon encontradas: $($subDirIconTags.Count)"

foreach ($tag in $subDirIconTags) {
    Write-Host "\nEtiqueta: $($tag.Value)"
    
    # Verificar si contiene la nueva ruta
    if ($tag.Value -like "*$newFaviconPath*") {
        Write-Host "✓ La etiqueta contiene la nueva ruta del favicon" -ForegroundColor Green
    } else {
        Write-Host "✗ La etiqueta NO contiene la nueva ruta del favicon" -ForegroundColor Red
    }
}