#!/usr/bin/env pwsh
# Script maestro para iniciar todo el Sistema de Pedidos

param(
    [switch]$Stop,
    [switch]$Restart,
    [switch]$Status,
    [switch]$Logs
)

$BackendPath = "F:\Proyecto Juanes\Backend-SistemaPedidos"
$FrontendPath = "F:\Proyecto Juanes\Frontend-SistemaPedidos"

function Show-Header {
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "   🍔 Sistema de Pedidos de Restaurante" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Check-Docker {
    Write-Host "Verificando Docker..." -ForegroundColor Yellow
    $dockerRunning = docker info 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error: Docker no está corriendo." -ForegroundColor Red
        Write-Host "   Por favor inicia Docker Desktop y vuelve a intentar." -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✅ Docker está corriendo" -ForegroundColor Green
}

function Start-Backend {
    Write-Host ""
    Write-Host "━━━ Iniciando Backend ━━━" -ForegroundColor Magenta
    Push-Location $BackendPath
    
    if (-not (Test-Path ".env")) {
        Write-Host "⚠️  Creando archivo .env para backend..." -ForegroundColor Yellow
        Copy-Item ".env.example" ".env"
    }
    
    docker-compose up --build -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Backend iniciado correctamente" -ForegroundColor Green
    } else {
        Write-Host "❌ Error al iniciar backend" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    
    Pop-Location
}

function Start-Frontend {
    Write-Host ""
    Write-Host "━━━ Iniciando Frontend ━━━" -ForegroundColor Magenta
    
    # Esperar un poco para que el backend esté listo
    Write-Host "⏳ Esperando a que el backend esté listo..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    
    Push-Location $FrontendPath
    
    if (-not (Test-Path ".env")) {
        Write-Host "⚠️  Creando archivo .env para frontend..." -ForegroundColor Yellow
        Copy-Item ".env.example" ".env"
    }
    
    docker-compose up --build -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Frontend iniciado correctamente" -ForegroundColor Green
    } else {
        Write-Host "❌ Error al iniciar frontend" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    
    Pop-Location
}

function Stop-All {
    Write-Host ""
    Write-Host "━━━ Deteniendo todos los servicios ━━━" -ForegroundColor Magenta
    
    Write-Host "Deteniendo Frontend..." -ForegroundColor Yellow
    Push-Location $FrontendPath
    docker-compose down
    Pop-Location
    
    Write-Host "Deteniendo Backend..." -ForegroundColor Yellow
    Push-Location $BackendPath
    docker-compose down
    Pop-Location
    
    Write-Host "✅ Todos los servicios detenidos" -ForegroundColor Green
}

function Show-Status {
    Write-Host ""
    Write-Host "━━━ Estado del Sistema ━━━" -ForegroundColor Magenta
    
    Write-Host ""
    Write-Host "Backend:" -ForegroundColor Cyan
    Push-Location $BackendPath
    docker-compose ps
    Pop-Location
    
    Write-Host ""
    Write-Host "Frontend:" -ForegroundColor Cyan
    Push-Location $FrontendPath
    docker-compose ps
    Pop-Location
}

function Show-Logs {
    Write-Host ""
    Write-Host "━━━ Logs del Sistema ━━━" -ForegroundColor Magenta
    Write-Host "Presiona Ctrl+C para salir" -ForegroundColor Yellow
    Write-Host ""
    
    # Abrir logs de backend y frontend en paralelo
    Start-Job -ScriptBlock {
        Set-Location $using:BackendPath
        docker-compose logs -f
    } | Out-Null
    
    Start-Job -ScriptBlock {
        Set-Location $using:FrontendPath
        docker-compose logs -f
    } | Out-Null
    
    Get-Job | Receive-Job -Wait -AutoRemoveJob
}

function Show-Services {
    Write-Host ""
    Write-Host "📊 Servicios Disponibles:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Backend:" -ForegroundColor Yellow
    Write-Host "  • API Gateway:          http://localhost:3000" -ForegroundColor White
    Write-Host "  • Admin Service:        http://localhost:4001/api" -ForegroundColor White
    Write-Host "  • Python MS:            http://localhost:8000" -ForegroundColor White
    Write-Host "  • Node MS API:          http://localhost:3002" -ForegroundColor White
    Write-Host "  • Node MS WebSocket:    ws://localhost:4000" -ForegroundColor White
    Write-Host "  • RabbitMQ Management:  http://localhost:15672 (guest/guest)" -ForegroundColor White
    Write-Host "  • MongoDB:              mongodb://localhost:27017" -ForegroundColor White
    Write-Host ""
    Write-Host "Frontend:" -ForegroundColor Yellow
    Write-Host "  • Panel Admin:          http://localhost:5174" -ForegroundColor White
    Write-Host "  • Toma de Pedidos:      http://localhost:5173" -ForegroundColor White
    Write-Host ""
}

function Show-Help {
    Write-Host ""
    Write-Host "Uso: .\start-all.ps1 [opciones]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Opciones:" -ForegroundColor Yellow
    Write-Host "  (sin opciones)  Iniciar todo el sistema (Backend + Frontend)" -ForegroundColor White
    Write-Host "  -Stop           Detener todos los servicios" -ForegroundColor White
    Write-Host "  -Restart        Reiniciar todos los servicios" -ForegroundColor White
    Write-Host "  -Status         Ver estado de todos los servicios" -ForegroundColor White
    Write-Host "  -Logs           Ver logs en tiempo real" -ForegroundColor White
    Write-Host ""
    Write-Host "Ejemplos:" -ForegroundColor Yellow
    Write-Host "  .\start-all.ps1           # Iniciar todo" -ForegroundColor Gray
    Write-Host "  .\start-all.ps1 -Status   # Ver estado" -ForegroundColor Gray
    Write-Host "  .\start-all.ps1 -Stop     # Detener todo" -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════

Show-Header

if ($Stop) {
    Check-Docker
    Stop-All
    exit 0
}

if ($Status) {
    Check-Docker
    Show-Status
    Show-Services
    exit 0
}

if ($Logs) {
    Check-Docker
    Show-Logs
    exit 0
}

if ($Restart) {
    Check-Docker
    Stop-All
    Start-Sleep -Seconds 2
    Start-Backend
    Start-Frontend
    Show-Services
    Write-Host ""
    Write-Host "🎉 Sistema reiniciado completamente!" -ForegroundColor Green
    exit 0
}

# Inicio normal
Check-Docker
Start-Backend
Start-Frontend
Show-Services

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "🎉 Sistema iniciado completamente!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Crear usuario admin: docker exec -it admin-service sh" -ForegroundColor White
Write-Host "                          npm run create-admin" -ForegroundColor White
Write-Host "  2. Abrir Admin Panel:   http://localhost:5174" -ForegroundColor White
Write-Host "  3. Crear productos y mesas desde el panel" -ForegroundColor White
Write-Host "  4. Abrir App Mesero:    http://localhost:5173" -ForegroundColor White
Write-Host ""
Write-Host "📊 Ver estado:  .\start-all.ps1 -Status" -ForegroundColor Cyan
Write-Host "📋 Ver logs:    .\start-all.ps1 -Logs" -ForegroundColor Cyan
Write-Host "🛑 Detener:     .\start-all.ps1 -Stop" -ForegroundColor Cyan
Write-Host ""
