# Script para incluir el archivo CSS en todos los archivos HTML

$files = Get-ChildItem -Path "c:\Logs\portal\macsoftware\be-it.com.mx" -Recurse -File -Filter "*.html"

foreach ($file in $files) {
    Write-Host "Procesando: $($file.FullName)"
    
    # Leer el contenido del archivo
    $content = Get-Content -Path $file.FullName -Raw
    
    # Determinar la ruta relativa al CSS basada en la profundidad del archivo
    $relativePath = "wp-content/themes/hide-links.css"
    $depth = ($file.FullName.Split("\") | Where-Object { $_ -ne "" }).Count - ($file.FullName.Split("\") | Where-Object { $_ -eq "be-it.com.mx" }).Count
    
    if ($depth -gt 1) {
        $prefix = ""
        for ($i = 1; $i -lt $depth; $i++) {
            $prefix += "../"
        }
        $relativePath = "$prefix$relativePath"
    }
    
    # Verificar si el archivo ya tiene la referencia al CSS
    if ($content -notmatch "hide-links\.css") {
        # Buscar la etiqueta </head> y agregar la referencia al CSS justo antes
        if ($content -match "</head>") {
            $content = $content -replace "</head>", "<link rel='stylesheet' href='$relativePath' type='text/css' media='all' />\n</head>"
            
            # Guardar el archivo
            Set-Content -Path $file.FullName -Value $content -Force
            Write-Host "Modificado: $($file.FullName)"
        }
    } else {
        # Si ya existe la referencia al CSS, actualizar la ruta
        $pattern = "href=['\"](.*?)hide-links\.css['\"].*?"
        $replacement = "href='$relativePath' type='text/css' media='all'"
        $content = $content -replace $pattern, $replacement
        
        # Guardar el archivo
        Set-Content -Path $file.FullName -Value $content -Force
        Write-Host "Actualizado: $($file.FullName)"
    }
}

Write-Host "Proceso completado. El archivo CSS ha sido incluido en todos los archivos HTML."