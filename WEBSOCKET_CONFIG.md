# 🔌 Configuración de WebSocket - Sistema de Pedidos

## 📋 Descripción

El sistema utiliza **WebSocket** para comunicación en tiempo real entre el backend y el frontend, específicamente para la **vista de cocina** donde se muestran los pedidos actualizándose en tiempo real.

## 🏗️ Arquitectura WebSocket

```
┌─────────────────┐         WebSocket         ┌─────────────────┐
│                 │    ws://localhost:4000     │                 │
│  Frontend       │◄─────────────────────────►│  Backend        │
│  (Cocina)       │    Actualización en        │  (Node MS)      │
│  Port 5173      │    tiempo real             │  Port 4000      │
└─────────────────┘                            └─────────────────┘
```

## ⚙️ Configuración Backend

### 📁 Servicio: orders-producer-node

**Archivo:** `Backend-SistemaPedidos/orders-producer-node/.env`

```env
# Puerto HTTP API
PORT=3002

# Puerto WebSocket (IMPORTANTE)
WS_PORT=4000

# MongoDB
MONGO_URI=mongodb://mongo:27017/restaurant_orders

# RabbitMQ
AMQP_LOCAL_HOST=rabbitmq
AMQP_LOCAL_PORT=5672
```

### 🐳 Docker Compose

**Archivo:** `Backend-SistemaPedidos/docker-compose.yml`

```yaml
node-ms:
  build:
    context: ./orders-producer-node
  container_name: node-ms
  ports:
    - "3002:3002"   # API REST
    - "4000:4000"   # WebSocket ← IMPORTANTE
  networks:
    - sistema-pedidos-network
```

**✅ Verificación Backend:**
- Puerto 3002 expuesto para API REST
- Puerto 4000 expuesto para WebSocket
- Variable `WS_PORT=4000` configurada
- Network `sistema-pedidos-network` configurada

## ⚙️ Configuración Frontend

### 📁 Aplicación: orders-producer-frontend

**Archivo:** `Frontend-SistemaPedidos/.env`

```env
# Backend APIs
VITE_ADMIN_API_URL=http://localhost:4001/api
VITE_API_GATEWAY_URL=http://localhost:3000

# WebSocket URL (IMPORTANTE)
VITE_WS_URL=ws://localhost:4000
```

### 🐳 Docker Compose

**Archivo:** `Frontend-SistemaPedidos/docker-compose.yml`

```yaml
orders-frontend:
  build:
    context: ./orders-producer-frontend
    args:
      - VITE_WS_URL=${VITE_WS_URL:-ws://localhost:4000}  # ← IMPORTANTE
  ports:
    - "5173:5173"
  networks:
    - sistema-pedidos-network  # Misma red que el backend
```

**✅ Verificación Frontend:**
- Variable `VITE_WS_URL` configurada
- Build arg pasando la URL del WebSocket
- Network compartida con backend

## 🚀 Configuración por Entorno

### Desarrollo Local (Misma Máquina)

**Backend (.env):**
```env
WS_PORT=4000
```

**Frontend (.env):**
```env
VITE_WS_URL=ws://localhost:4000
```

**Características:**
- ✅ Backend y Frontend en la misma máquina
- ✅ Red Docker compartida
- ✅ WebSocket a través de localhost
- ✅ Sin configuración adicional

### Desarrollo Separado (Frontend local, Backend en Docker)

**Backend (.env):**
```env
WS_PORT=4000
```

**Frontend (.env):**
```env
VITE_WS_URL=ws://localhost:4000
```

**Nota:** El backend debe exponer el puerto 4000 al host.

### Producción (Servidores Separados)

**Backend (.env):**
```env
WS_PORT=4000
# Configurar firewall para permitir conexiones en el puerto 4000
```

**Frontend (.env):**
```env
# Usar WSS (WebSocket Secure) en producción
VITE_WS_URL=wss://api.tu-dominio.com/ws

# O si el WebSocket está en un subdominio:
# VITE_WS_URL=wss://ws.tu-dominio.com
```

**Configuración adicional necesaria:**
1. Certificado SSL para WSS
2. Reverse proxy (nginx/traefik) configurado para WebSocket
3. CORS permitiendo origen del frontend

#### Ejemplo Nginx (Producción)

```nginx
# Backend WebSocket
upstream websocket_backend {
    server backend-host:4000;
}

server {
    listen 443 ssl;
    server_name api.tu-dominio.com;

    # Configuración SSL
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    # WebSocket endpoint
    location /ws {
        proxy_pass http://websocket_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts para WebSocket
        proxy_read_timeout 86400;
        proxy_send_timeout 86400;
    }
}
```

## 🧪 Verificación de WebSocket

### 1. Verificar Backend

```powershell
# Iniciar backend
cd Backend-SistemaPedidos
docker-compose up -d

# Verificar que el puerto 4000 está escuchando
docker exec -it node-ms netstat -tuln | grep 4000

# O desde el host
netstat -ano | findstr :4000
```

**Salida esperada:** Puerto 4000 en LISTEN

### 2. Verificar Frontend

```powershell
# Ver variables de entorno del build
cd Frontend-SistemaPedidos
docker-compose config | findstr VITE_WS_URL

# Verificar logs del frontend
docker-compose logs orders-frontend | findstr -i websocket
```

### 3. Probar Conexión WebSocket

**Opción A: Desde el navegador (DevTools)**

1. Abrir http://localhost:5173/kitchen
2. Abrir DevTools (F12)
3. Ir a la pestaña "Network"
4. Filtrar por "WS" (WebSocket)
5. Debería ver conexión a `ws://localhost:4000`

**Estado esperado:** 
- Status: 101 Switching Protocols
- Connection: Upgrade

**Opción B: Con herramienta de testing**

```powershell
# Instalar wscat globalmente (si no lo tienes)
npm install -g wscat

# Probar conexión
wscat -c ws://localhost:4000
```

**Salida esperada:** Conexión establecida

### 4. Probar Flujo Completo

1. Abrir vista de cocina: http://localhost:5173/kitchen
2. Crear un pedido desde: http://localhost:5173
3. **Verificar que el pedido aparece en cocina SIN refrescar**
4. Cambiar estado del pedido
5. **Verificar actualización en tiempo real**

## 🐛 Problemas Comunes y Soluciones

### Problema 1: "WebSocket connection failed"

**Síntomas:**
- Error en consola: `WebSocket connection to 'ws://localhost:4000' failed`
- Vista de cocina no actualiza

**Causas posibles:**
1. Backend no está corriendo
2. Puerto 4000 no está expuesto
3. URL incorrecta en frontend

**Soluciones:**

```powershell
# 1. Verificar que backend está corriendo
cd Backend-SistemaPedidos
docker-compose ps

# Debería mostrar node-ms como "Up"

# 2. Verificar puerto 4000
netstat -ano | findstr :4000

# 3. Verificar variable de entorno
cd ..\Frontend-SistemaPedidos
cat .env | findstr VITE_WS_URL

# Debería ser: VITE_WS_URL=ws://localhost:4000

# 4. Reconstruir frontend con variable correcta
docker-compose down
docker-compose up --build
```

### Problema 2: "Connection refused" en Docker

**Causa:** Red Docker no configurada correctamente

**Solución:**

```powershell
# Verificar que la red existe
docker network ls | findstr sistema-pedidos

# Si no existe, crearla (el backend debería crearla automáticamente)
cd Backend-SistemaPedidos
docker-compose up -d

# Reiniciar frontend para conectarse a la red
cd ..\Frontend-SistemaPedidos
docker-compose down
docker-compose up -d
```

### Problema 3: WebSocket se desconecta constantemente

**Causas:**
1. Proxy/firewall bloqueando la conexión
2. Timeout muy corto
3. Certificado SSL inválido (en producción)

**Soluciones:**

**Desarrollo:**
```powershell
# Verificar logs del backend
cd Backend-SistemaPedidos
docker-compose logs -f node-ms

# Buscar errores de WebSocket
```

**Producción:**
- Aumentar timeouts en nginx/reverse proxy
- Verificar certificado SSL
- Configurar keep-alive

### Problema 4: CORS en WebSocket

**Error:** `Cross-Origin Request Blocked`

**Solución en Backend:**

Asegurarse de que el servidor WebSocket permite el origen del frontend:

```javascript
// En orders-producer-node
const wss = new WebSocket.Server({
  port: WS_PORT,
  // Permitir origen del frontend
  verifyClient: (info) => {
    const origin = info.origin;
    const allowedOrigins = [
      'http://localhost:5173',
      'https://tu-dominio.com'
    ];
    return allowedOrigins.includes(origin);
  }
});
```

## 📊 Checklist de Configuración

### Backend
- [ ] Puerto 4000 expuesto en docker-compose.yml
- [ ] Variable `WS_PORT=4000` en .env
- [ ] Network `sistema-pedidos-network` configurada
- [ ] Servidor WebSocket iniciando correctamente (revisar logs)
- [ ] Puerto 4000 accesible desde el host

### Frontend
- [ ] Variable `VITE_WS_URL=ws://localhost:4000` en .env
- [ ] Build arg pasado en docker-compose.yml
- [ ] Network `sistema-pedidos-network` configurada (misma que backend)
- [ ] Build compilando con la variable correcta
- [ ] Código frontend usando la variable `VITE_WS_URL`

### Verificación
- [ ] Backend iniciado sin errores
- [ ] Frontend iniciado sin errores
- [ ] Puerto 4000 escuchando (netstat)
- [ ] Vista cocina carga sin errores
- [ ] Conexión WebSocket establecida (DevTools)
- [ ] Pedidos aparecen en tiempo real
- [ ] Cambios de estado actualizan en tiempo real

## 📝 Archivos a Revisar

Si hay problemas con WebSocket, revisar estos archivos:

**Backend:**
1. `Backend-SistemaPedidos/orders-producer-node/.env` → WS_PORT
2. `Backend-SistemaPedidos/docker-compose.yml` → Puertos 4000
3. `Backend-SistemaPedidos/orders-producer-node/src/server.ts` → Código WebSocket

**Frontend:**
4. `Frontend-SistemaPedidos/.env` → VITE_WS_URL
5. `Frontend-SistemaPedidos/docker-compose.yml` → Build args
6. `Frontend-SistemaPedidos/orders-producer-frontend/src/...` → Código cliente WebSocket

## 🎯 Resumen de URLs

| Entorno | Backend WS | Frontend Conexión |
|---------|------------|-------------------|
| Desarrollo Local | `0.0.0.0:4000` | `ws://localhost:4000` |
| Desarrollo Separado | `0.0.0.0:4000` | `ws://localhost:4000` |
| Producción | `0.0.0.0:4000` | `wss://api.domain.com/ws` |

## ✅ Estado Actual

La configuración actual en ambos repositorios:

✅ **Backend configurado correctamente:**
- Puerto 4000 expuesto
- Variable WS_PORT documentada
- Network configurada

✅ **Frontend configurado correctamente:**
- Variable VITE_WS_URL con valor por defecto
- Build arg configurado
- Network compartida

✅ **Documentación completa:**
- Este archivo explica todo el setup
- .env.example con valores correctos
- READMEs actualizados

**🎉 WebSocket listo para usar sin problemas!**

---

**Última actualización:** 18 de Diciembre de 2025
**Configuración verificada:** ✅ Backend + Frontend
