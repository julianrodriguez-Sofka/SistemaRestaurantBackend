# ⚡ Quick Start - 5 Minutos

Guía ultra-rápida para levantar el sistema.

## ✅ Pre-requisitos

- [ ] Docker Desktop instalado y corriendo
- [ ] Git instalado

## 🚀 Pasos

### 1. Clonar

```bash
git clone <repo-url>
cd "Sistema de Pedidos Restaurante"
```

### 2. Copiar Variables de Entorno

**Windows:**
```powershell
# Backend
Copy-Item SistemaRestaurantBackend\backend\api-gateway\.env.example SistemaRestaurantBackend\backend\api-gateway\.env
Copy-Item SistemaRestaurantBackend\backend\admin-service\.env.example SistemaRestaurantBackend\backend\admin-service\.env
Copy-Item SistemaRestaurantBackend\backend\orders-producer-node\.env.example SistemaRestaurantBackend\backend\orders-producer-node\.env
Copy-Item SistemaRestaurantBackend\backend\orders-producer-python\.env.example SistemaRestaurantBackend\backend\orders-producer-python\.env

# Frontend
Copy-Item SistemaRestaurantFronted\frontend\admin-frontend\.env.example SistemaRestaurantFronted\frontend\admin-frontend\.env
Copy-Item SistemaRestaurantFronted\frontend\orders-producer-frontend\.env.example SistemaRestaurantFronted\frontend\orders-producer-frontend\.env
```

**Linux/Mac:**
```bash
# Backend
cp SistemaRestaurantBackend/backend/*/.env.example SistemaRestaurantBackend/backend/*/.env 2>/dev/null || true

# Mejor hacerlo uno por uno:
for dir in api-gateway admin-service orders-producer-node orders-producer-python; do
  cp "SistemaRestaurantBackend/backend/$dir/.env.example" "SistemaRestaurantBackend/backend/$dir/.env"
done

for dir in admin-frontend orders-producer-frontend; do
  cp "SistemaRestaurantFronted/frontend/$dir/.env.example" "SistemaRestaurantFronted/frontend/$dir/.env"
done
```

### 3. Iniciar

**Windows:**
```powershell
cd SistemaRestaurantBackend
.\start-system.ps1
```

**Linux/Mac:**
```bash
cd SistemaRestaurantBackend
chmod +x start-system.sh
./start-system.sh
```

### 4. Esperar ~60 segundos ⏳

### 5. Abrir en el navegador

- **Meseros:** http://localhost:5173
- **Admin:** http://localhost:5174

## 🔑 Credenciales

**Admin:**
- Usuario: `Admin`
- Contraseña: `admin123`

**Mesero:**
- Usuario: `Julian`
- Contraseña: `mesero123`

**Chef:**
- Usuario: `Eduardo`
- Contraseña: `chef123`

## ✅ Verificar

```bash
docker ps
```

Deberías ver 8 contenedores corriendo.

## 🛑 Detener

```bash
cd SistemaRestaurantBackend/backend
docker-compose down

cd ../../SistemaRestaurantFronted/frontend
docker-compose down
```

## ❌ Si algo falla

```bash
# Ver logs
docker logs api-gateway
docker logs python-ms
docker logs node-ms
docker logs admin-service

# Reiniciar todo
cd SistemaRestaurantBackend/backend
docker-compose down
docker-compose up -d

cd ../../SistemaRestaurantFronted/frontend
docker-compose down
docker-compose up -d
```

---

Para más detalles, ver [README.md](../README.md) o [SETUP.md](SETUP.md)
