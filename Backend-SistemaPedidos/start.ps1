#!/usr/bin/env pwsh
# Script para iniciar todos los servicios backend

Write-Host "🚀 Iniciando Backend - Sistema de Pedidos..." -ForegroundColor Green
Write-Host ""

# Verificar que Docker esté corriendo
Write-Host "Verificando Docker..." -ForegroundColor Yellow
$dockerRunning = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error: Docker no está corriendo. Por favor inicia Docker Desktop." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Docker está corriendo" -ForegroundColor Green
Write-Host ""

# Verificar si existe .env
if (-not (Test-Path ".env")) {
    Write-Host "⚠️  Archivo .env no encontrado. Creando desde .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "✅ Archivo .env creado. Revisa y ajusta las variables si es necesario." -ForegroundColor Green
    Write-Host ""
}

# Detener contenedores previos si existen
Write-Host "Deteniendo contenedores previos..." -ForegroundColor Yellow
docker-compose down
Write-Host ""

# Levantar servicios
Write-Host "🐳 Levantando servicios con Docker Compose..." -ForegroundColor Cyan
docker-compose up --build -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Todos los servicios están levantando..." -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Servicios disponibles:" -ForegroundColor Cyan
    Write-Host "  - API Gateway:          http://localhost:3000" -ForegroundColor White
    Write-Host "  - Admin Service:        http://localhost:4001/api" -ForegroundColor White
    Write-Host "  - Python MS:            http://localhost:8000" -ForegroundColor White
    Write-Host "  - Node MS API:          http://localhost:3002" -ForegroundColor White
    Write-Host "  - Node MS WebSocket:    ws://localhost:4000" -ForegroundColor White
    Write-Host "  - RabbitMQ Management:  http://localhost:15672 (guest/guest)" -ForegroundColor White
    Write-Host "  - MongoDB:              mongodb://localhost:27017" -ForegroundColor White
    Write-Host ""
    Write-Host "📝 Ver logs: docker-compose logs -f [servicio]" -ForegroundColor Yellow
    Write-Host "🛑 Detener:  docker-compose down" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "❌ Error al levantar los servicios" -ForegroundColor Red
    exit 1
}
