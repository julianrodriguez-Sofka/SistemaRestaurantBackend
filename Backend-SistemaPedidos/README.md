# Backend - Sistema de Pedidos de Restaurante

## 📋 Descripción

Este repositorio contiene todos los servicios backend del sistema de gestión de pedidos para restaurante, implementado con arquitectura de microservicios.

## 🏗️ Arquitectura

El backend está compuesto por los siguientes servicios:

### Servicios de Aplicación

1. **API Gateway** (Port 3000)
   - Framework: Express + TypeScript
   - Función: Enrutamiento centralizado de todas las peticiones
   - Endpoints principales:
     - `POST /api/orders` → Python MS
     - `GET /api/kitchen/orders` → Node MS
     - `PUT /api/kitchen/orders/:id` → Node MS

2. **Admin Service** (Port 4001)
   - Framework: Express + TypeScript
   - Función: Gestión de usuarios, productos, categorías y mesas
   - Base de datos: MongoDB
   - Autenticación: JWT
   - Endpoints: `/api/auth`, `/api/users`, `/api/products`, `/api/categories`, `/api/tables`

3. **Orders Producer Python** (Port 8000)
   - Framework: FastAPI
   - Función: Validación de pedidos y publicación en RabbitMQ
   - Endpoint: `POST /api/v1/orders/`
   - Características:
     - Validación con Pydantic
     - Publica mensajes en cola `orders.new`
     - Actualiza estado de mesas

4. **Orders Producer Node** (Ports 3002, 4000)
   - Framework: Express + TypeScript + WebSocket
   - Función: Procesamiento de pedidos y notificaciones en tiempo real
   - Características:
     - Consume mensajes de RabbitMQ
     - Gestiona estados: pending → preparing → ready
     - WebSocket para cocina en tiempo real
     - Calcula tiempos de preparación

### Infraestructura

5. **RabbitMQ** (Ports 5672, 15672)
   - Message Broker para comunicación asíncrona
   - Management UI: http://localhost:15672
   - Credenciales por defecto: guest/guest

6. **MongoDB** (Port 27017)
   - Base de datos NoSQL
   - Almacena: usuarios, productos, categorías, mesas, pedidos

## 🚀 Inicio Rápido

### Prerrequisitos

- Docker y Docker Compose instalados
- Puertos disponibles: 3000, 3002, 4000, 4001, 5672, 8000, 15672, 27017

### Instalación y Ejecución

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd Backend-SistemaPedidos
```

2. **Configurar variables de entorno**
```bash
# Copiar archivo de ejemplo
cp .env.example .env

# Editar .env con tus valores (opcional para desarrollo)
```

3. **Levantar todos los servicios**
```bash
docker-compose up --build
```

4. **Verificar que todos los servicios estén corriendo**
```bash
docker-compose ps
```

### Servicios Disponibles

Una vez levantados todos los contenedores:

- **API Gateway**: http://localhost:3000
- **Admin Service**: http://localhost:4001/api
- **Python MS**: http://localhost:8000
- **Node MS API**: http://localhost:3002
- **Node MS WebSocket**: ws://localhost:4000
- **RabbitMQ Management**: http://localhost:15672
- **MongoDB**: mongodb://localhost:27017

## 📝 Scripts Útiles

### Detener todos los servicios
```bash
docker-compose down
```

### Detener y eliminar volúmenes (limpieza completa)
```bash
docker-compose down -v
```

### Ver logs de un servicio específico
```bash
docker-compose logs -f [nombre-servicio]
# Ejemplo: docker-compose logs -f api-gateway
```

### Reconstruir un servicio específico
```bash
docker-compose up --build [nombre-servicio]
```

## 🔧 Configuración

### Variables de Entorno

Revisa el archivo `.env.example` para todas las variables disponibles. Las principales son:

- `MONGO_URI`: URI de conexión a MongoDB
- `RABBITMQ_URL`: URL de conexión a RabbitMQ
- `JWT_SECRET`: Secreto para tokens JWT (¡CAMBIAR EN PRODUCCIÓN!)
- `NODE_ENV`: Entorno de ejecución (development/production)

### Crear Usuario Administrador

Para crear el primer usuario administrador:

```bash
# Acceder al contenedor de admin-service
docker exec -it admin-service sh

# Ejecutar script de creación
npm run create-admin
```

## 🧪 Testing

### Tests E2E

El repositorio incluye tests end-to-end con Playwright:

```bash
cd e2e-tests
npm install
npm test
```

### Tests Unitarios

Cada servicio tiene sus propios tests:

```bash
# API Gateway
cd api-gateway
npm test

# Orders Producer Node
cd orders-producer-node
npm test
```

## 📊 Flujo de Pedidos

1. El frontend envía un pedido al API Gateway
2. API Gateway enruta la petición al Python MS
3. Python MS valida el pedido con Pydantic
4. Python MS publica mensaje en RabbitMQ (cola `orders.new`)
5. Node MS consume el mensaje de RabbitMQ
6. Node MS procesa el pedido:
   - Calcula tiempo de preparación
   - Cambia estados: pending → preparing → ready
   - Guarda en MongoDB
7. Node MS notifica cambios vía WebSocket a la cocina

## 🌐 Integración con Frontend

Este backend está diseñado para trabajar con el repositorio Frontend separado. El frontend debe configurar las siguientes URLs:

- `VITE_API_GATEWAY_URL=http://localhost:3000`
- `VITE_ADMIN_API_URL=http://localhost:4001/api`
- `VITE_WS_URL=ws://localhost:4000`

Para entornos de producción, estos servicios deben exponerse a través de un reverse proxy (nginx, traefik, etc.) con el network `sistema-pedidos-network`.

## 🐛 Troubleshooting

### Los servicios no se conectan

Verifica que todos los servicios estén en la misma red de Docker:
```bash
docker network inspect sistema-pedidos-network
```

### RabbitMQ no está listo

Espera a que el healthcheck pase:
```bash
docker-compose logs rabbitmq
```

### MongoDB no conecta

Verifica que el contenedor esté corriendo y saludable:
```bash
docker-compose ps mongo
docker-compose logs mongo
```

## 📚 Documentación Adicional

- [ARQUITECTURA_HEXAGONAL.md](./orders-producer-node/ARQUITECTURA_HEXAGONAL.md) - Arquitectura del Node MS
- [PREPARATION_TIMES.md](./orders-producer-node/PREPARATION_TIMES.md) - Tiempos de preparación
- [PRODUCTS.md](./orders-producer-node/PRODUCTS.md) - Catálogo de productos

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es privado y confidencial.

## 👥 Equipo

Desarrollado por el equipo de desarrollo de Sistema de Pedidos.
