# Script para reemplazar secciones en archivos HTML

$sourceFile = "c:\Repositorio\mac_ti\mac_it\be-it.com.mx\index.html"
$sourceContent = Get-Content -Path $sourceFile -Raw

# Extraer la sección con ID 1ee79b6d del archivo principal
$pattern = '(?s)<section class="elementor-section elementor-inner-section elementor-element elementor-element-1ee79b6d.*?</section>'
$sectionMatch = [regex]::Match($sourceContent, $pattern)

if ($sectionMatch.Success) {
    $sectionContent = $sectionMatch.Value
    
    # Obtener la lista de archivos index.html
    $files = Get-ChildItem -Path "c:\Repositorio\mac_ti\mac_it\be-it.com.mx" -Recurse -Filter "index.html"
    
    foreach ($file in $files) {
        $fileContent = Get-Content -Path $file.FullName -Raw
        
        # Verificar si el archivo contiene la sección con ID 1ee79b6d
        if ($fileContent -match $pattern) {
            Write-Host "Reemplazando sección en: $($file.FullName)"
            
            # Reemplazar la sección en el archivo
            $newContent = [regex]::Replace($fileContent, $pattern, $sectionContent)
            
            # Guardar el archivo modificado
            Set-Content -Path $file.FullName -Value $newContent -NoNewline
        }
    }
    
    Write-Host "Proceso completado."
} else {
    Write-Host "No se encontró la sección en el archivo principal."
}