#!/bin/bash
# Script de configuración automática para Linux/Mac

echo "🔧 Configurando variables de entorno..."
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Backend services
echo -e "${YELLOW}📦 Configurando servicios de backend...${NC}"

cp SistemaRestaurantBackend/backend/api-gateway/.env.example SistemaRestaurantBackend/backend/api-gateway/.env && \
  echo -e "${GREEN}✓${NC} API Gateway configurado"

cp SistemaRestaurantBackend/backend/admin-service/.env.example SistemaRestaurantBackend/backend/admin-service/.env && \
  echo -e "${GREEN}✓${NC} Admin Service configurado"

cp SistemaRestaurantBackend/backend/orders-producer-node/.env.example SistemaRestaurantBackend/backend/orders-producer-node/.env && \
  echo -e "${GREEN}✓${NC} Node MS (Kitchen) configurado"

cp SistemaRestaurantBackend/backend/orders-producer-python/.env.example SistemaRestaurantBackend/backend/orders-producer-python/.env && \
  echo -e "${GREEN}✓${NC} Python MS (Orders) configurado"

echo ""
echo -e "${YELLOW}🎨 Configurando aplicaciones frontend...${NC}"

cp SistemaRestaurantFronted/frontend/admin-frontend/.env.example SistemaRestaurantFronted/frontend/admin-frontend/.env && \
  echo -e "${GREEN}✓${NC} Admin Frontend configurado"

cp SistemaRestaurantFronted/frontend/orders-producer-frontend/.env.example SistemaRestaurantFronted/frontend/orders-producer-frontend/.env && \
  echo -e "${GREEN}✓${NC} Orders Producer Frontend configurado"

echo ""
echo -e "${GREEN}✅ Configuración completada!${NC}"
echo ""
echo "Ahora puedes ejecutar:"
echo "  cd SistemaRestaurantBackend"
echo "  ./start-system.sh"
