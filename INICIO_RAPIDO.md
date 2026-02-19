# 🚀 GUÍA DE INICIO RÁPIDO - Para Principiantes

## ⏱️ 5 Minutos para Empezar

Esta guía te llevará paso a paso para usar el sistema de base de datos de la veterinaria. **No necesitas conocimientos previos de bases de datos.**

---

## 📋 Paso 1: Verificar que MySQL está instalado

Abre PowerShell en esta carpeta y escribe:

```powershell
mysql --version
```

Si ves algo como "mysql Ver 8.4.8", ✅ **MySQL está instalado**.

Si ves un error, necesitas ejecutar primero la instalación completa desde [GUIA_MYSQL_VETERINARIA.md](GUIA_MYSQL_VETERINARIA.md).

---

## 📋 Paso 2: Iniciar MySQL (CADA VEZ que reinicies tu PC)

**IMPORTANTE**: MySQL no arranca automáticamente al iniciar Windows.

### Opción A - Script Automático (RECOMENDADO) 🌟

Haz doble clic en el archivo:
```
Iniciar_MySQL.ps1
```

O desde PowerShell:
```powershell
.\Iniciar_MySQL.ps1
```

Verás un mensaje confirmando que MySQL está listo. **¡Deja esta ventana abierta!**

### Opción B - Línea de Comandos

Si prefieres hacerlo manual:

```powershell
# 1. Agregar MySQL al PATH
$env:Path += ";C:\Program Files\MySQL\MySQL Server 8.4\bin"

# 2. Iniciar MySQL
Start-Process -FilePath "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" -ArgumentList "--datadir=`"C:\ProgramData\MySQL\MySQL Server 8.4\data`"" -WindowStyle Hidden

# 3. Esperar 5 segundos
Start-Sleep -Seconds 5

# 4. Verificar que está corriendo
Get-Process mysqld
```

---

## 📋 Paso 3: Conectarte a la Base de Datos

Una vez que MySQL está corriendo, puedes conectarte de dos formas:

### Opción A - Script de Conexión Rápida 🌟

Ejecuta:
```powershell
.\Conectar_MySQL.ps1
```

### Opción B - Manualmente

```powershell
# Agregar MySQL al PATH (si no lo hiciste)
$env:Path += ";C:\Program Files\MySQL\MySQL Server 8.4\bin"

# Conectarte
mysql -u root veterinaria_db
```

Verás que cambia a `mysql>` - ¡ya estás dentro!

---

## 📋 Paso 4: Tus Primeras Consultas

Una vez dentro de MySQL (cuando veas `mysql>`), prueba estos comandos:

### Ver todas las tablas
```sql
SHOW TABLES;
```

Deberías ver:
- duenos
- mascotas
- servicios
- historial_servicios
- productos
- ventas

### Ver todos los dueños
```sql
SELECT * FROM duenos;
```

### Ver todas las mascotas
```sql
SELECT * FROM mascotas;
```

### Ver dueños con sus mascotas
```sql
SELECT 
    d.nombre AS dueno, 
    m.nombre AS mascota, 
    m.especie 
FROM duenos d 
LEFT JOIN mascotas m ON d.id_dueno = m.id_dueno;
```

### Ver cuánto dinero has ganado
```sql
SELECT 
    'Servicios' AS concepto, 
    SUM(precio_cobrado) AS total 
FROM historial_servicios
UNION ALL
SELECT 
    'Productos', 
    SUM(total) 
FROM ventas;
```

### Para salir de MySQL
```sql
exit
```

---

## 📋 Paso 5: Agregar Tus Propios Datos

### Agregar un nuevo dueño

```sql
INSERT INTO duenos (nombre, apellido, telefono, email, direccion) 
VALUES ('Maria', 'Lopez', '555-1234', 'maria@email.com', 'Mi Direccion 123');
```

### Ver el ID del dueño que acabas de crear

```sql
SELECT LAST_INSERT_ID();
```

Supongamos que el ID es 5.

### Agregar una mascota para ese dueño

```sql
INSERT INTO mascotas (id_dueno, nombre, especie, raza, fecha_nacimiento, sexo, peso_kg) 
VALUES (5, 'Firulais', 'Perro', 'Golden Retriever', '2023-05-15', 'Macho', 25.5);
```

### Verificar que se agregó

```sql
SELECT 
    d.nombre AS dueno, 
    m.nombre AS mascota 
FROM duenos d 
JOIN mascotas m ON d.id_dueno = m.id_dueno 
WHERE d.id_dueno = 5;
```

---

## 🆘 Solución de Problemas Comunes

### ❌ "mysql no se reconoce como comando"

**Solución**: MySQL no está en el PATH.

```powershell
$env:Path += ";C:\Program Files\MySQL\MySQL Server 8.4\bin"
```

Luego vuelve a intentar.

---

### ❌ "Can't connect to MySQL server"

**Problema**: MySQL no está corriendo.

**Solución**: Ejecuta el script de inicio:
```powershell
.\Iniciar_MySQL.ps1
```

---

### ❌ MySQL deja de funcionar después de reiniciar la PC

**Esto es normal**. MySQL no arranca automáticamente.

**Solución**: Cada vez que reinicies tu PC, ejecuta:
```powershell
.\Iniciar_MySQL.ps1
```

---

### ❌ "Access denied for user 'root'"

**Problema**: Hay contraseña configurada.

**Solución**: Actualmente root NO tiene contraseña. Si alguien configuró una, usa:
```powershell
mysql -u root -p veterinaria_db
```

Te pedirá la contraseña.

---

## 🎯 Comandos Más Útiles (Cheat Sheet)

| Lo que quieres hacer | Comando |
|---------------------|---------|
| Ver todas las tablas | `SHOW TABLES;` |
| Ver estructura de una tabla | `DESCRIBE mascotas;` |
| Ver todos los registros | `SELECT * FROM duenos;` |
| Contar registros | `SELECT COUNT(*) FROM mascotas;` |
| Buscar por nombre | `SELECT * FROM duenos WHERE nombre = 'Juan';` |
| Ver últimos 5 registros | `SELECT * FROM historial_servicios ORDER BY fecha_servicio DESC LIMIT 5;` |
| Salir de MySQL | `exit` |

---

## 📚 Siguientes Pasos

Una vez que te sientas cómodo con los comandos básicos:

1. **Revisa más consultas**: Abre [consultas_prueba.sql](consultas_prueba.sql) para ver ejemplos más avanzados

2. **Aprende comandos de terminal**: Lee [COMANDOS_TERMINAL.md](COMANDOS_TERMINAL.md) para ejecutar consultas sin entrar a MySQL

3. **Explora la guía completa**: [GUIA_MYSQL_VETERINARIA.md](GUIA_MYSQL_VETERINARIA.md) tiene información detallada

---

## 💡 Consejos para Principiantes

### ✅ Buenas Prácticas

1. **Siempre termina los comandos SQL con punto y coma (;)**
   ```sql
   SELECT * FROM duenos;  ← ¡No olvides el punto y coma!
   ```

2. **Usa mayúsculas para palabras clave de SQL** (no es obligatorio, pero ayuda a leer)
   ```sql
   SELECT nombre FROM duenos WHERE id_dueno = 1;
   ```

3. **Haz respaldos regularmente**
   ```powershell
   mysqldump -u root veterinaria_db > backup.sql
   ```

4. **Deja la ventana de MySQL abierta** mientras trabajas (no cierres PowerShell)

### ⚠️ Cosas que NUNCA hagas

1. ❌ **NO ejecutes `DROP DATABASE`** a menos que estés 100% seguro
2. ❌ **NO ejecutes `DELETE FROM tabla`** sin un WHERE (borrará TODO)
3. ❌ **NO cierres MySQL** mientras está en medio de una operación
4. ❌ **NO olvides hacer respaldos** antes de modificaciones grandes

---

## 🎓 Recursos de Aprendizaje

- **SQL Básico**: https://www.w3schools.com/sql/
- **MySQL Documentación**: https://dev.mysql.com/doc/
- **Tutorial interactivo**: https://sqlbolt.com/

---

## 🎉 ¡Ya estás listo!

Con esta guía tienes todo lo necesario para:
- ✅ Iniciar MySQL
- ✅ Conectarte a la base de datos
- ✅ Ver y consultar información
- ✅ Agregar nuevos registros
- ✅ Resolver problemas comunes

**¿Dudas?** Revisa la sección de [Solución de Problemas](#-solución-de-problemas-comunes) o consulta los otros archivos de documentación.

---

**¡Suerte con tu sistema de veterinaria!** 🐾
