# 🚀 Guía de Primer Commit a GitHub

Sigue estos pasos para subir el proyecto a GitHub por primera vez.

## ✅ Pre-requisitos

Antes de comenzar, asegúrate de que:
- [ ] Docker Desktop está corriendo
- [ ] Has probado el sistema y funciona correctamente
- [ ] Tienes una cuenta de GitHub
- [ ] Git está instalado en tu computadora

## 📋 Paso 1: Verificar que Todo Funciona

```powershell
# 1. Configurar variables de entorno sacar esto fuera de los repositorios y ejecutar o hacer docker-compose up -d en cada repositorio para levantar los contenedores 
.\setup-env.ps1

# 2. Levantar el sistema
cd SistemaRestaurantBackend
.\start-system.ps1

# 3. Esperar 60 segundos y verificar
docker ps
# Deberías ver 8 contenedores corriendo

# 4. Probar las aplicaciones
# - http://localhost:5173 (Meseros)
# - http://localhost:5174 (Admin)

# 5. Detener todo
cd backend
docker-compose down
cd ..\..\SistemaRestaurantFronted\frontend
docker-compose down
cd ..\..
```

## 📝 Paso 2: Verificar Archivos a Excluir

```powershell
# Verificar que los .env NO están en la lista de archivos
Get-ChildItem -Recurse -Filter ".env" | Where-Object { $_.Name -eq ".env" }

# Si aparecen archivos .env, verifica que cada servicio tenga .gitignore
```

## 🔧 Paso 3: Inicializar Git

```powershell
# En el directorio raíz del proyecto
cd "F:\Sistema de Pedidos Restaurante"

# Inicializar repositorio
git init

# Configurar tu información (si no lo has hecho)
git config user.name "Tu Nombre"
git config user.email "tu@email.com"
```

## 📤 Paso 4: Crear Repositorio en GitHub

1. Ve a https://github.com/new
2. Nombre del repositorio: `sistema-pedidos-restaurante`
3. Descripción: `Sistema completo de gestión de pedidos con microservicios`
4. **NO inicialices con README** (ya tenemos uno)
5. Click en "Create repository"

## ⬆️ Paso 5: Primer Commit

```powershell
# Agregar todos los archivos
git add .

# Verificar qué se va a subir
git status

# IMPORTANTE: Verifica que NO aparezcan archivos .env
# Solo deben aparecer .env.example

# Si ves archivos .env, elimínalos del staging:
# git rm --cached <ruta/al/archivo>/.env

# Hacer el commit inicial
git commit -m "feat: initial commit - Sistema de pedidos completo

- Backend con microservicios (Node.js, Python, API Gateway)
- Frontend para meseros y administración
- RabbitMQ para mensajería
- MongoDB para persistencia
- WebSockets para notificaciones en tiempo real
- Docker Compose para orquestación
- Documentación completa de setup"

# Agregar el repositorio remoto
git remote add origin https://github.com/TU_USUARIO/sistema-pedidos-restaurante.git

# Subir a GitHub
git branch -M main
git push -u origin main
```

## 🔍 Paso 6: Verificar en GitHub

1. Ve a tu repositorio en GitHub
2. Verifica que aparezcan todos los archivos
3. **MUY IMPORTANTE:** Busca `.env` en el repositorio
   - NO debería aparecer ningún archivo `.env`
   - Solo deben estar los `.env.example`

## 📝 Paso 7: Actualizar README con tu URL

```powershell
# Edita el README.md y reemplaza <url-del-repositorio> con tu URL real
# Por ejemplo: https://github.com/tu-usuario/sistema-pedidos-restaurante.git

# Commit el cambio
git add README.md
git commit -m "docs: actualizar URL del repositorio"
git push
```

## 🎉 Paso 8: Probar desde Otro Lugar

Para asegurarte de que todo funciona, prueba clonarlo en otra carpeta:

```powershell
# En otra ubicación
cd C:\temp
git clone https://github.com/TU_USUARIO/sistema-pedidos-restaurante.git
cd sistema-pedidos-restaurante

# Configurar y ejecutar
.\setup-env.ps1
cd SistemaRestaurantBackend
.\start-system.ps1

# Esperar 60 segundos y verificar
docker ps
```

## 📋 Checklist Final

Antes de considerarlo completo:

- [ ] El repositorio está en GitHub
- [ ] README.md tiene instrucciones claras
- [ ] Los archivos `.env.example` están incluidos
- [ ] Los archivos `.env` NO están en el repositorio
- [ ] El script `setup-env.ps1` funciona
- [ ] El script `start-system.ps1` funciona
- [ ] Puedes clonar y ejecutar en otra ubicación
- [ ] Todos los servicios levantan correctamente
- [ ] Las aplicaciones son accesibles en el navegador

## 🔒 Seguridad

### ⚠️ Si Accidentalmente Subiste Archivos .env

```powershell
# 1. Remover del repositorio pero mantener local
git rm --cached **/*.env

# 2. Agregar a .gitignore (si no está)
echo ".env" >> .gitignore

# 3. Commit
git add .gitignore
git commit -m "chore: remove .env files from repository"
git push

# 4. IMPORTANTE: Si había contraseñas reales:
#    - Cámbialas TODAS inmediatamente
#    - Considera usar git-filter-branch para limpiar el historial
```

## 📧 Paso 9: Invitar Colaboradores (Opcional)

Si trabajas en equipo:

1. Ve a Settings → Collaborators en GitHub
2. Agrega colaboradores por username o email
3. Comparte con ellos:
   - URL del repositorio
   - Instrucciones del README.md
   - Credenciales de prueba (si es necesario)

## 🎓 Paso 10: Configurar Branch Protection (Recomendado)

Para proyectos en equipo:

1. Ve a Settings → Branches
2. Add rule para `main`
3. Habilita:
   - Require pull request reviews before merging
   - Require status checks to pass
   - Include administrators (opcional)

## ✨ ¡Listo!

Tu proyecto ahora es completamente reproducible. Cualquiera puede:

1. Clonar el repositorio
2. Ejecutar `.\setup-env.ps1`
3. Ejecutar `.\start-system.ps1`
4. Acceder al sistema funcionando

## 🆘 Solución de Problemas

### "Permission denied" al hacer push

```powershell
# Configurar credenciales
git config credential.helper store
# Luego hacer push nuevamente y enter tus credenciales
```

### "Repository not found"

```powershell
# Verificar la URL remota
git remote -v

# Si es incorrecta, actualizar
git remote set-url origin https://github.com/TU_USUARIO/nombre-correcto.git
```

### Olvidé agregar algo

```powershell
# Hacer cambios
# Agregar archivos
git add .
git commit -m "chore: agregar archivos faltantes"
git push
```

---

**¡Felicidades!** 🎉 Tu proyecto está ahora en GitHub y completamente reproducible.
