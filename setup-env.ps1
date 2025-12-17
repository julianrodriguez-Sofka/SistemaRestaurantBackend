# Script de configuración automática para Windows PowerShell

Write-Host "🔧 Configurando variables de entorno..." -ForegroundColor Cyan
Write-Host ""

# Backend services
Write-Host "📦 Configurando servicios de backend..." -ForegroundColor Yellow

try {
    Copy-Item "SistemaRestaurantBackend\backend\api-gateway\.env.example" "SistemaRestaurantBackend\backend\api-gateway\.env" -Force
    Write-Host "✓ API Gateway configurado" -ForegroundColor Green
} catch {
    Write-Host "✗ Error configurando API Gateway: $_" -ForegroundColor Red
}

try {
    Copy-Item "SistemaRestaurantBackend\backend\admin-service\.env.example" "SistemaRestaurantBackend\backend\admin-service\.env" -Force
    Write-Host "✓ Admin Service configurado" -ForegroundColor Green
} catch {
    Write-Host "✗ Error configurando Admin Service: $_" -ForegroundColor Red
}

try {
    Copy-Item "SistemaRestaurantBackend\backend\orders-producer-node\.env.example" "SistemaRestaurantBackend\backend\orders-producer-node\.env" -Force
    Write-Host "✓ Node MS (Kitchen) configurado" -ForegroundColor Green
} catch {
    Write-Host "✗ Error configurando Node MS: $_" -ForegroundColor Red
}

try {
    Copy-Item "SistemaRestaurantBackend\backend\orders-producer-python\.env.example" "SistemaRestaurantBackend\backend\orders-producer-python\.env" -Force
    Write-Host "✓ Python MS (Orders) configurado" -ForegroundColor Green
} catch {
    Write-Host "✗ Error configurando Python MS: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎨 Configurando aplicaciones frontend..." -ForegroundColor Yellow

try {
    Copy-Item "SistemaRestaurantFronted\frontend\admin-frontend\.env.example" "SistemaRestaurantFronted\frontend\admin-frontend\.env" -Force
    Write-Host "✓ Admin Frontend configurado" -ForegroundColor Green
} catch {
    Write-Host "✗ Error configurando Admin Frontend: $_" -ForegroundColor Red
}

try {
    Copy-Item "SistemaRestaurantFronted\frontend\orders-producer-frontend\.env.example" "SistemaRestaurantFronted\frontend\orders-producer-frontend\.env" -Force
    Write-Host "✓ Orders Producer Frontend configurado" -ForegroundColor Green
} catch {
    Write-Host "✗ Error configurando Orders Producer Frontend: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "✅ Configuración completada!" -ForegroundColor Green
Write-Host ""
Write-Host "Ahora puedes ejecutar:" -ForegroundColor White
Write-Host "  cd SistemaRestaurantBackend" -ForegroundColor Gray
Write-Host "  .\start-system.ps1" -ForegroundColor Gray
