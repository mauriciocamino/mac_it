# Script para verificar que todos los iconos se hayan reemplazado correctamente

$newFaviconPath = "wp-content/uploads/elementor/thumbs/logo-beit-blanco-prh5ro17598lil95tigwxvh6h12mv7inly0bf22134.png"
$rootDir = "c:\Logs\portal\macsoftware\be-it.com.mx"

# Buscar todos los archivos HTML
$htmlFiles = Get-ChildItem -Path $rootDir -Filter "*.html" -Recurse

# Patrones a buscar
$patterns = @(
    '<link[^>]*rel="icon"[^>]*>',
    '<link[^>]*rel="apple-touch-icon"[^>]*>',
    '<meta[^>]*msapplication-TileImage[^>]*>'
)

$totalFiles = $htmlFiles.Count
$processedFiles = 0
$oldIconsFound = 0

Write-Host "Verificando $totalFiles archivos HTML...\n"

foreach ($file in $htmlFiles) {
    $processedFiles++
    $content = Get-Content -Path $file.FullName -Raw
    $fileHasOldIcons = $false
    
    # Buscar referencias al icono antiguo
    if ($content -match "cropped-icono_Be_IT_Principal") {
        $oldIconsFound++
        $fileHasOldIcons = $true
        Write-Host "[$processedFiles/$totalFiles] ✗ Archivo con iconos antiguos: $($file.FullName)" -ForegroundColor Red
        
        # Mostrar las líneas con los iconos antiguos
        $matches = [regex]::Matches($content, '.*cropped-icono_Be_IT_Principal.*')
        foreach ($match in $matches) {
            Write-Host "  $($match.Value)" -ForegroundColor Yellow
        }
    } else {
        # Verificar que el nuevo icono esté presente
        if ($content -match $newFaviconPath) {
            Write-Host "[$processedFiles/$totalFiles] ✓ Archivo con iconos nuevos: $($file.FullName)" -ForegroundColor Green
        } else {
            # Si no tiene ni el viejo ni el nuevo, puede que no tenga iconos
            $hasAnyIcon = $false
            foreach ($pattern in $patterns) {
                if ([regex]::IsMatch($content, $pattern)) {
                    $hasAnyIcon = $true
                    break
                }
            }
            
            if ($hasAnyIcon) {
                Write-Host "[$processedFiles/$totalFiles] ? Archivo con iconos desconocidos: $($file.FullName)" -ForegroundColor Yellow
            } else {
                Write-Host "[$processedFiles/$totalFiles] - Archivo sin iconos: $($file.FullName)" -ForegroundColor Gray
            }
        }
    }
}

Write-Host "\nVerificación completada."
Write-Host "Archivos procesados: $processedFiles"
Write-Host "Archivos con iconos antiguos: $oldIconsFound"
Write-Host "Archivos con iconos actualizados: $($processedFiles - $oldIconsFound)"
