# Script para encontrar todas las referencias a iconos en el sitio

$rootDir = "c:\Logs\portal\macsoftware\be-it.com.mx"

# Buscar todos los archivos HTML
$htmlFiles = Get-ChildItem -Path $rootDir -Filter "*.html" -Recurse

# Patrones a buscar
$patterns = @(
    '<link[^>]*rel="icon"[^>]*>',
    '<link[^>]*rel="apple-touch-icon"[^>]*>',
    '<meta[^>]*msapplication-TileImage[^>]*>'
)

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $found = $false
    
    foreach ($pattern in $patterns) {
        $matches = [regex]::Matches($content, $pattern)
        
        if ($matches.Count -gt 0) {
            if (-not $found) {
                Write-Host "\nArchivo: $($file.FullName)" -ForegroundColor Cyan
                $found = $true
            }
            
            foreach ($match in $matches) {
                Write-Host "  $($match.Value)" -ForegroundColor Yellow
            }
        }
    }
}