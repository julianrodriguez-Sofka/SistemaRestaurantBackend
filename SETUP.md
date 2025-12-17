# 🔧 Guía de Configuración Detallada

Esta guía proporciona instrucciones paso a paso para configurar el sistema desde cero.

## 📋 Requisitos del Sistema

### Mínimos
- **RAM:** 4 GB
- **Disco:** 10 GB libres
- **CPU:** Dual-core 2.0 GHz

### Recomendados
- **RAM:** 8 GB o más
- **Disco:** 20 GB libres (SSD preferible)
- **CPU:** Quad-core 2.5 GHz o superior

## 🖥️ Software Requerido

### 1. Docker Desktop

**Windows:**
1. Descarga Docker Desktop desde https://www.docker.com/products/docker-desktop
2. Ejecuta el instalador
3. Reinicia tu computadora
4. Abre Docker Desktop y espera a que inicie

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose

# Fedora
sudo dnf install docker docker-compose

# Iniciar Docker
sudo systemctl start docker
sudo systemctl enable docker
```

**Mac:**
1. Descarga Docker Desktop desde https://www.docker.com/products/docker-desktop
2. Arrastra Docker a tu carpeta de Aplicaciones
3. Abre Docker desde Aplicaciones

### 2. Git

**Windows:**
- Descarga desde https://git-scm.com/download/win
- Ejecuta el instalador con opciones por defecto

**Linux:**
```bash
sudo apt-get install git  # Ubuntu/Debian
sudo dnf install git       # Fedora
```

**Mac:**
```bash
brew install git
```

## 📥 Instalación Paso a Paso

### Paso 1: Clonar el Repositorio

```bash
# Clona el repositorio
git clone <url-del-repositorio>

# Navega al directorio
cd "Sistema de Pedidos Restaurante"
```

### Paso 2: Configurar Variables de Entorno

Necesitas copiar los archivos `.env.example` a `.env` para cada servicio.

#### En Windows PowerShell:

```powershell
# Navega al directorio del proyecto
cd "F:\Sistema de Pedidos Restaurante"

# Backend - API Gateway
Copy-Item "SistemaRestaurantBackend\backend\api-gateway\.env.example" "SistemaRestaurantBackend\backend\api-gateway\.env"

# Backend - Admin Service
Copy-Item "SistemaRestaurantBackend\backend\admin-service\.env.example" "SistemaRestaurantBackend\backend\admin-service\.env"

# Backend - Node MS (Kitchen)
Copy-Item "SistemaRestaurantBackend\backend\orders-producer-node\.env.example" "SistemaRestaurantBackend\backend\orders-producer-node\.env"

# Backend - Python MS (Orders)
Copy-Item "SistemaRestaurantBackend\backend\orders-producer-python\.env.example" "SistemaRestaurantBackend\backend\orders-producer-python\.env"

# Frontend - Admin
Copy-Item "SistemaRestaurantFronted\frontend\admin-frontend\.env.example" "SistemaRestaurantFronted\frontend\admin-frontend\.env"

# Frontend - Orders Producer
Copy-Item "SistemaRestaurantFronted\frontend\orders-producer-frontend\.env.example" "SistemaRestaurantFronted\frontend\orders-producer-frontend\.env"
```

#### En Linux/Mac (Bash):

```bash
# Navega al directorio del proyecto
cd "Sistema de Pedidos Restaurante"

# Backend
cp SistemaRestaurantBackend/backend/api-gateway/.env.example SistemaRestaurantBackend/backend/api-gateway/.env
cp SistemaRestaurantBackend/backend/admin-service/.env.example SistemaRestaurantBackend/backend/admin-service/.env
cp SistemaRestaurantBackend/backend/orders-producer-node/.env.example SistemaRestaurantBackend/backend/orders-producer-node/.env
cp SistemaRestaurantBackend/backend/orders-producer-python/.env.example SistemaRestaurantBackend/backend/orders-producer-python/.env

# Frontend
cp SistemaRestaurantFronted/frontend/admin-frontend/.env.example SistemaRestaurantFronted/frontend/admin-frontend/.env
cp SistemaRestaurantFronted/frontend/orders-producer-frontend/.env.example SistemaRestaurantFronted/frontend/orders-producer-frontend/.env
```

### Paso 3: Iniciar Docker Desktop

1. Abre Docker Desktop
2. Espera a que aparezca "Docker is running" en la esquina inferior izquierda
3. Verifica que Docker esté funcionando:

```powershell
docker ps
```

Deberías ver una tabla vacía (sin errores).

### Paso 4: Levantar el Sistema

#### Windows:

```powershell
cd SistemaRestaurantBackend
.\start-system.ps1
```

#### Linux/Mac:

```bash
cd SistemaRestaurantBackend
chmod +x start-system.sh
./start-system.sh
```

### Paso 5: Esperar a que Todo Inicie

El script automáticamente:
1. Levanta los servicios de backend (30 segundos)
2. Levanta los servicios de frontend
3. Espera a que RabbitMQ esté saludable
4. Espera a que MongoDB esté saludable

**Tiempo estimado:** 1-2 minutos

### Paso 6: Verificar que Todo Esté Funcionando

```powershell
docker ps
```

Deberías ver 8 contenedores corriendo:
- `api-gateway`
- `admin-service`
- `python-ms`
- `node-ms`
- `rabbitmq`
- `mongo`
- `admin-frontend`
- `orders-producer-frontend`

### Paso 7: Acceder a las Aplicaciones

Abre tu navegador y visita:

1. **Panel de Meseros:** http://localhost:5173
2. **Panel de Administración:** http://localhost:5174

## 🔐 Primer Acceso

### Login como Administrador

1. Ve a http://localhost:5174
2. Ingresa credenciales:
   - **Usuario:** `Admin`
   - **Contraseña:** `admin123`
3. Serás redirigido al dashboard

### Configuración Inicial

1. **Crear Productos:**
   - Ve a "Productos" en el menú lateral
   - Click en "Agregar Producto"
   - Llena el formulario y guarda

2. **Crear Mesas:**
   - Ve a "Mesas" en el menú lateral
   - Click en "Agregar Mesa"
   - Define número, capacidad y ubicación

3. **Crear Usuarios (Opcional):**
   - Ve a "Usuarios" en el menú lateral
   - Click en "Agregar Usuario"
   - Asigna roles: admin, waiter, o chef

## 🧪 Prueba del Sistema

### Crear una Orden de Prueba

1. **Como Mesero:**
   - Ve a http://localhost:5173
   - Login como `Julian` / `mesero123`
   - Selecciona una mesa
   - Agrega productos al pedido
   - Confirma el pedido

2. **Como Chef:**
   - Ve a http://localhost:5173
   - Login como `Eduardo` / `chef123`
   - Verás el pedido aparecer automáticamente
   - Cambia el estado del pedido

3. **Verificar Notificaciones:**
   - Ambas pantallas deberían actualizarse en tiempo real

## 🔧 Configuración Avanzada

### Cambiar Puertos

Si algún puerto está ocupado, edita los archivos `.env`:

**Backend:**
- API Gateway: `SistemaRestaurantBackend/backend/api-gateway/.env` → `PORT=3000`
- Admin Service: `SistemaRestaurantBackend/backend/admin-service/.env` → `PORT=4000`

**Frontend:**
- Edita `docker-compose.yml` en cada carpeta de frontend

### Aumentar Timeout

Si las órdenes fallan por timeout:

1. Edita `SistemaRestaurantBackend/backend/api-gateway/.env`
2. Cambia `REQUEST_TIMEOUT=60000` a `REQUEST_TIMEOUT=120000`
3. Reinicia: `docker restart api-gateway`

### Cambiar JWT Secret

1. Edita `SistemaRestaurantBackend/backend/admin-service/.env`
2. Cambia `JWT_SECRET=your_super_secret_jwt_key_change_in_production`
3. Usa un secret seguro generado con:
```powershell
[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((New-Guid).ToString()))
```

## 🧹 Limpieza y Mantenimiento

### Detener el Sistema

```powershell
# Backend
cd SistemaRestaurantBackend/backend
docker-compose down

# Frontend
cd ../../SistemaRestaurantFronted/frontend
docker-compose down
```

### Limpiar Datos (Resetear Base de Datos)

```powershell
# ADVERTENCIA: Esto borrará todos los datos
cd SistemaRestaurantBackend/backend
docker-compose down -v

cd ../../SistemaRestaurantFronted/frontend
docker-compose down -v
```

### Ver Espacio Usado por Docker

```powershell
docker system df
```

### Limpiar Imágenes y Contenedores No Usados

```powershell
docker system prune -a
```

## ❓ FAQ

### ¿Puedo usar npm/yarn en lugar de Docker?

Sí, pero necesitarás:
1. Instalar Node.js 18+
2. Instalar Python 3.10+
3. Instalar y configurar MongoDB localmente
4. Instalar y configurar RabbitMQ localmente
5. Instalar todas las dependencias manualmente

Docker es **altamente recomendado** para evitar problemas de configuración.

### ¿Cómo actualizo el código?

```bash
# Detén el sistema
cd SistemaRestaurantBackend/backend
docker-compose down

cd ../../SistemaRestaurantFronted/frontend
docker-compose down

# Actualiza el código
cd ../..
git pull

# Reconstruye y levanta
cd SistemaRestaurantBackend
.\start-system.ps1
```

### ¿Los datos persisten después de reiniciar?

Sí, MongoDB usa volúmenes de Docker que persisten los datos. Solo se pierden con `docker-compose down -v`.

### ¿Puedo acceder desde otra computadora en mi red?

Sí, reemplaza `localhost` con la IP de tu computadora:
- Frontend Meseros: `http://<tu-ip>:5173`
- Frontend Admin: `http://<tu-ip>:5174`
- API Gateway: `http://<tu-ip>:3000`

También necesitarás actualizar las variables de entorno en los frontends para apuntar a la IP correcta.

## 📞 Soporte

Si encuentras problemas:
1. Revisa la sección [Troubleshooting](../README.md#troubleshooting) en el README principal
2. Verifica los logs: `docker logs <nombre-servicio>`
3. Abre un issue en el repositorio con los logs y descripción del problema
