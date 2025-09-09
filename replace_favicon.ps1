# Script para reemplazar el favicon en todos los archivos HTML

$newFaviconPath = "wp-content/uploads/elementor/thumbs/logo-beit-blanco-prh5ro17598lil95tigwxvh6h12mv7inly0bf22134.png"
$rootDir = "c:\Logs\portal\macsoftware\be-it.com.mx"

# Función para obtener la ruta relativa desde un archivo HTML a la raíz del sitio
function Get-RelativePath {
    param (
        [string]$htmlFilePath,
        [string]$rootDir
    )
    
    $relativePath = ""
    $htmlDir = Split-Path -Parent $htmlFilePath
    $relativeDirCount = ($htmlDir.Substring($rootDir.Length) -split '\\').Where({$_ -ne ""}).Count
    
    if ($relativeDirCount -gt 0) {
        $relativePath = "../" * $relativeDirCount
    }
    
    return $relativePath
}

# Buscar todos los archivos HTML
$htmlFiles = Get-ChildItem -Path $rootDir -Filter "*.html" -Recurse

$totalFiles = $htmlFiles.Count
$processedFiles = 0
$modifiedFiles = 0

Write-Host "Encontrados $totalFiles archivos HTML para procesar."

foreach ($file in $htmlFiles) {
    $processedFiles++
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    $relativePath = Get-RelativePath -htmlFilePath $file.FullName -rootDir $rootDir
    
    # Reemplazar las referencias al favicon de 32x32
    $pattern32 = '<link\s+rel="icon"\s+href="[^"]*cropped-icono_Be_IT_Principal-32x32\.jpg"\s+sizes="32x32"\s*/>'    
    $newPath = $relativePath + $newFaviconPath
    $replacement32 = '<link rel="icon" href="' + $newPath + '" sizes="32x32" />'
    $content = $content -replace $pattern32, $replacement32
    
    # Reemplazar las referencias al favicon de 192x192
    $pattern192 = '<link\s+rel="icon"\s+href="[^"]*cropped-icono_Be_IT_Principal-192x192\.jpg"\s+sizes="192x192"\s*/>'    
    $replacement192 = '<link rel="icon" href="' + $newPath + '" sizes="192x192" />'
    $content = $content -replace $pattern192, $replacement192
    
    # Guardar el archivo si se hicieron cambios
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content
        $modifiedFiles++
        Write-Host "[$processedFiles/$totalFiles] Modificado: $($file.FullName)"
    } else {
        Write-Host "[$processedFiles/$totalFiles] Sin cambios: $($file.FullName)"
    }
}

Write-Host "\nProceso completado. Se modificaron $modifiedFiles de $totalFiles archivos."