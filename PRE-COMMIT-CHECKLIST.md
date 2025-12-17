# 📋 Checklist Pre-Commit

Antes de hacer commit y push al repositorio, verifica esta lista:

## ✅ Archivos de Configuración

- [ ] Todos los archivos `.env.example` están actualizados con las variables necesarias
- [ ] Los archivos `.env` NO están incluidos en el commit (verificar con `git status`)
- [ ] Todos los `.gitignore` incluyen `.env` en la lista

## ✅ Documentación

- [ ] README.md está actualizado con los cambios
- [ ] SETUP.md tiene instrucciones claras de instalación
- [ ] QUICK-START.md tiene los pasos resumidos

## ✅ Código

- [ ] El código compila sin errores
- [ ] Las pruebas pasan (si las hay)
- [ ] No hay console.log() o código de debug
- [ ] Los comentarios están actualizados

## ✅ Docker

- [ ] Los Dockerfile están optimizados
- [ ] docker-compose.yml tiene las configuraciones correctas
- [ ] Las redes Docker están correctamente configuradas
- [ ] Los volúmenes persisten los datos necesarios

## ✅ Funcionalidad

Antes de hacer commit, ejecuta el sistema localmente y verifica:

- [ ] El sistema levanta sin errores: `.\start-system.ps1`
- [ ] Todos los contenedores están corriendo: `docker ps`
- [ ] Frontend de meseros carga: http://localhost:5173
- [ ] Frontend de admin carga: http://localhost:5174
- [ ] Puedes crear una orden de prueba
- [ ] La orden llega a la cocina
- [ ] Las notificaciones WebSocket funcionan

## 🧪 Pruebas Mínimas

```powershell
# 1. Levantar el sistema
cd SistemaRestaurantBackend
.\start-system.ps1

# 2. Esperar 60 segundos

# 3. Verificar contenedores
docker ps
# Deberías ver 8 contenedores corriendo

# 4. Probar endpoints
Invoke-WebRequest http://localhost:3000/api/kitchen/orders
Invoke-WebRequest http://localhost:4001/health

# 5. Probar creación de orden
$body = @{customerName="Test"; table="Table 1"; items=@(@{productName="Test"; quantity=1; unitPrice=1000}); total=1000} | ConvertTo-Json
Invoke-WebRequest -Uri http://localhost:3000/api/orders -Method POST -Body $body -ContentType "application/json"

# 6. Verificar que llegó a cocina
Invoke-WebRequest http://localhost:3000/api/kitchen/orders
```

## 📝 Mensaje de Commit

Usa mensajes descriptivos:

### ✅ Buenos ejemplos:
- `feat: agregar validación de productos en órdenes`
- `fix: corregir timeout en creación de órdenes`
- `docs: actualizar guía de instalación`
- `refactor: mejorar manejo de errores en API Gateway`

### ❌ Malos ejemplos:
- `update`
- `fix bug`
- `changes`
- `wip`

## 🔒 Variables Sensibles

NUNCA hacer commit de:
- [ ] Archivos `.env`
- [ ] Contraseñas o secrets
- [ ] Tokens de API
- [ ] Certificados SSL
- [ ] Credenciales de base de datos

## 🌿 Branches

- `main` / `master`: Código estable en producción
- `develop`: Desarrollo activo
- `feature/<nombre>`: Nuevas características
- `fix/<nombre>`: Corrección de bugs
- `hotfix/<nombre>`: Correcciones urgentes en producción

## 📤 Antes de Push

```bash
# 1. Asegúrate de estar en la rama correcta
git branch

# 2. Actualiza desde remoto
git pull origin <rama>

# 3. Verifica los archivos a subir
git status

# 4. Revisa los cambios
git diff

# 5. Agrega solo lo necesario
git add <archivos>

# 6. Commit con mensaje descriptivo
git commit -m "tipo: descripción clara"

# 7. Push
git push origin <rama>
```

## 🚨 Si Algo Sale Mal

### Archivos .env se subieron por error

```bash
# Remover del índice pero mantener local
git rm --cached <archivo>.env

# Asegurar que está en .gitignore
echo ".env" >> .gitignore

# Commit
git add .gitignore
git commit -m "chore: agregar .env a .gitignore"
git push
```

### Secrets expuestos en el historial

Si subiste contraseñas o secrets:
1. Cambia TODOS los passwords/secrets inmediatamente
2. Considera usar `git filter-branch` o `BFG Repo-Cleaner` para limpiar el historial
3. Notifica al equipo

### Build falla en CI/CD

1. Prueba el build localmente primero
2. Verifica que todas las dependencias estén en package.json/requirements.txt
3. Revisa los logs de CI/CD
4. Verifica variables de entorno en el CI

## ✨ Buenas Prácticas

- Haz commits pequeños y frecuentes
- Un commit = una funcionalidad/fix
- Escribe tests para código nuevo
- Actualiza la documentación junto con el código
- Revisa tu código antes de hacer commit
- Usa herramientas de linting

## 🔄 Workflow Recomendado

1. Crear branch desde `develop`
2. Hacer cambios
3. Probar localmente (usar este checklist)
4. Commit y push al branch
5. Crear Pull Request
6. Esperar revisión de código
7. Hacer cambios solicitados si es necesario
8. Merge a `develop`
9. Deploy a staging para pruebas
10. Merge a `main` para producción
