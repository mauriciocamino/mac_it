# Script para incluir el archivo JavaScript en todas las páginas HTML

$files = Get-ChildItem -Path "c:\Logs\portal\macsoftware\be-it.com.mx" -Recurse -File -Filter "*.html"

foreach ($file in $files) {
    Write-Host "Procesando: $($file.FullName)"
    
    # Leer el contenido del archivo
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    
    # Calcular la profundidad del archivo para la ruta relativa
    $relativePath = $file.FullName.Replace("c:\Logs\portal\macsoftware\be-it.com.mx\", "")
    $depth = ($relativePath.Split("\") | Measure-Object).Count - 1
    
    # Construir la ruta relativa al archivo JS
    $jsPath = "";
    for ($i = 0; $i -lt $depth; $i++) {
        $jsPath += "../"
    }
    $jsPath += "wp-content/themes/hide-links.js"
    
    # Verificar si ya existe la referencia al archivo JS
    if ($content -notmatch "hide-links\.js") {
        # Agregar la referencia al archivo JS antes de </head>
        $content = $content -replace "</head>", "<script src=`"$jsPath`"></script>\n</head>"
        
        # Guardar el archivo solo si hubo cambios
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Force
            Write-Host "Modificado: $($file.FullName)"
        }
    }
}

Write-Host "Proceso completado. El archivo JavaScript ha sido incluido en todas las páginas HTML."