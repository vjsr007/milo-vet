# 🐾 Sistema de Base de Datos para Veterinaria

## ⚡ INICIO RÁPIDO PARA PRINCIPIANTES

### 🎯 ¿Primera vez aquí? Comienza aquí:

1. **[INICIO_RAPIDO.md](INICIO_RAPIDO.md)** ← ⭐ **EMPIEZA AQUÍ** (5 minutos)
2. **[NOTAS_IMPORTANTES.md](NOTAS_IMPORTANTES.md)** ← ⚠️ Lee esto primero
3. Ejecuta: `.\Iniciar_MySQL.ps1` para arrancar MySQL
4. Ejecuta: `.\Conectar_MySQL.ps1` para conectarte

---

## 📁 Archivos del Proyecto

### 🌟 Para Principiantes (USA ESTOS)
- **[INICIO_RAPIDO.md](INICIO_RAPIDO.md)** - Guía rápida de 5 minutos
- **[NOTAS_IMPORTANTES.md](NOTAS_IMPORTANTES.md)** - Limitaciones y advertencias
- **[Iniciar_MySQL.ps1](Iniciar_MySQL.ps1)** - Script para iniciar MySQL automáticamente
- **[Conectar_MySQL.ps1](Conectar_MySQL.ps1)** - Script para conectarse rápidamente
- **[COMANDOS_TERMINAL.md](COMANDOS_TERMINAL.md)** - Comandos útiles para terminal

### 📚 Documentación Completa
- **[GUIA_MYSQL_VETERINARIA.md](GUIA_MYSQL_VETERINARIA.md)** - Guía completa paso a paso
- **[INSTALACION_COMPLETADA.md](INSTALACION_COMPLETADA.md)** - Resumen de instalación
- **[INSTRUCCIONES_DE_USO.md](INSTRUCCIONES_DE_USO.md)** - Instrucciones detalladas

### 🗄️ Scripts SQL
- **[setup_veterinaria.sql](setup_veterinaria.sql)** - Script completo (con ñ)
- **[setup_simple.sql](setup_simple.sql)** - Script sin caracteres especiales ✅
- **[consultas_prueba.sql](consultas_prueba.sql)** - 50+ consultas de ejemplo

---

## 🚀 Inicio Rápido (3 pasos)

### Paso 1: Instalar MySQL
Sigue la sección "Instalación de MySQL" en [GUIA_MYSQL_VETERINARIA.md](GUIA_MYSQL_VETERINARIA.md)

### Paso 2: Configurar la Base de Datos

**Opción A - Ejecutar desde Command Line:**
```bash
# Abre MySQL Command Line Client
# Ingresa tu contraseña de root
# Luego ejecuta:
source d:/MyProjects/veterinaria/setup_veterinaria.sql
```

**Opción B - Ejecutar desde terminal:**
```bash
mysql -u root -p < setup_veterinaria.sql
```

### Paso 3: Probar el Sistema
```bash
# En MySQL Command Line Client:
source d:/MyProjects/veterinaria/consultas_prueba.sql
```

---

## 📊 Estructura de la Base de Datos

### Tablas Principales

| Tabla | Descripción | Registros de Ejemplo |
|-------|-------------|---------------------|
| `dueños` | Información de los propietarios | 4 |
| `mascotas` | Información de las mascotas | 5 |
| `servicios` | Catálogo de servicios | 8 |
| `historial_servicios` | Registro de servicios prestados | 5 |
| `productos` | Catálogo de productos | 6 |
| `ventas` | Registro de ventas | 5 |

### Relaciones
```
dueños (1) ----< (N) mascotas
mascotas (1) ----< (N) historial_servicios >---- (1) servicios
ventas >---- (1) mascotas
ventas >---- (1) productos
```

---

## 💡 Consultas Más Útiles

### Ver todos los dueños con sus mascotas
```sql
SELECT 
    d.nombre AS dueño,
    d.telefono,
    m.nombre AS mascota,
    m.especie
FROM dueños d
LEFT JOIN mascotas m ON d.id_dueño = m.id_dueño;
```

### Ver historial de una mascota
```sql
SELECT 
    m.nombre AS mascota,
    s.nombre AS servicio,
    hs.fecha_servicio,
    hs.veterinario,
    hs.precio_cobrado
FROM historial_servicios hs
JOIN mascotas m ON hs.id_mascota = m.id_mascota
JOIN servicios s ON hs.id_servicio = s.id_servicio
WHERE m.nombre = 'Max'
ORDER BY hs.fecha_servicio DESC;
```

### Ingresos del mes
```sql
SELECT 
    SUM(precio_cobrado) AS total
FROM historial_servicios
WHERE MONTH(fecha_servicio) = MONTH(CURDATE())
    AND YEAR(fecha_servicio) = YEAR(CURDATE());
```

---

## 🔧 Operaciones Comunes

### Registrar una nueva visita
```sql
-- 1. Buscar IDs
SELECT id_mascota FROM mascotas WHERE nombre = 'Max';
SELECT id_servicio, precio FROM servicios WHERE nombre = 'Consulta General';

-- 2. Registrar servicio
INSERT INTO historial_servicios 
    (id_mascota, id_servicio, veterinario, diagnostico, precio_cobrado)
VALUES 
    (1, 1, 'Dr. Ramírez', 'Chequeo de rutina', 250.00);
```

### Registrar una venta
```sql
-- 1. Ver producto
SELECT id_producto, precio, stock FROM productos WHERE nombre LIKE '%Alimento%';

-- 2. Registrar venta
INSERT INTO ventas 
    (id_mascota, id_producto, cantidad, precio_unitario, subtotal, total)
VALUES 
    (1, 1, 1, 850.00, 850.00, 850.00);

-- 3. Actualizar stock
UPDATE productos SET stock = stock - 1 WHERE id_producto = 1;
```

### Agregar nuevo cliente y mascota
```sql
-- 1. Agregar dueño
INSERT INTO dueños (nombre, apellido, telefono)
VALUES ('Pedro', 'López', '555-0200');

-- 2. Agregar mascota
INSERT INTO mascotas (id_dueño, nombre, especie, raza, sexo)
VALUES (LAST_INSERT_ID(), 'Firulais', 'Perro', 'Mestizo', 'Macho');
```

---

## 📱 Comandos Útiles de MySQL

```sql
-- Ver todas las tablas
SHOW TABLES;

-- Ver estructura de una tabla
DESCRIBE mascotas;

-- Ver base de datos actual
SELECT DATABASE();

-- Cambiar a otra base de datos
USE veterinaria_db;

-- Contar registros
SELECT COUNT(*) FROM mascotas;
```

---

## 💾 Respaldo y Restauración

### Crear Respaldo
```bash
# En la terminal de Windows (no en MySQL):
mysqldump -u root -p veterinaria_db > backup_veterinaria.sql
```

### Restaurar Respaldo
```bash
mysql -u root -p veterinaria_db < backup_veterinaria.sql
```

---

## 🆘 Solución de Problemas

### Error: "Access denied for user 'root'"
- Verifica tu contraseña
- Asegúrate de que el servicio MySQL esté corriendo

### Error: "Unknown database 'veterinaria_db'"
- Ejecuta primero: `CREATE DATABASE veterinaria_db;`
- Luego: `USE veterinaria_db;`

### Error: "Table doesn't exist"
- Ejecuta el archivo `setup_veterinaria.sql`

### No puedo ejecutar el archivo .sql
```bash
# Opción 1: Desde MySQL Command Line Client
source ruta/del/archivo.sql

# Opción 2: Desde terminal de Windows
mysql -u root -p < ruta/del/archivo.sql
```

---

## 📚 Recursos Adicionales

- **Guía Completa**: [GUIA_MYSQL_VETERINARIA.md](GUIA_MYSQL_VETERINARIA.md)
- **Documentación MySQL**: https://dev.mysql.com/doc/
- **Tutorial SQL**: https://www.w3schools.com/sql/

---

## ✅ Verificación de Instalación

Ejecuta este comando para verificar que todo está funcionando:

```sql
SELECT 'Dueños' AS tabla, COUNT(*) AS registros FROM dueños
UNION ALL SELECT 'Mascotas', COUNT(*) FROM mascotas
UNION ALL SELECT 'Servicios', COUNT(*) FROM servicios
UNION ALL SELECT 'Historial', COUNT(*) FROM historial_servicios
UNION ALL SELECT 'Productos', COUNT(*) FROM productos
UNION ALL SELECT 'Ventas', COUNT(*) FROM ventas;
```

Deberías ver:
- Dueños: 4
- Mascotas: 5
- Servicios: 8
- Historial: 5
- Productos: 6
- Ventas: 5

---

**¡Éxito!** 🎉 Tu sistema de base de datos para veterinaria está listo para usar.
