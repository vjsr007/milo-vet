# 🐾 Comandos MySQL desde Terminal - Veterinaria

## ✅ INSTALACIÓN COMPLETADA

MySQL fue instalado y configurado exitosamente desde terminal usando:
```powershell
winget install Oracle.MySQL
```

## 🚀 Inicio Rápido

### Arrancar MySQL (si no está corriendo)
```powershell
Start-Process -FilePath "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" -ArgumentList "--datadir=`"C:\ProgramData\MySQL\MySQL Server 8.4\data`"" -WindowStyle Hidden
```

### Conectarse a MySQL
```powershell
# Agregar MySQL al PATH de la sesión actual
$env:Path += ";C:\Program Files\MySQL\MySQL Server 8.4\bin"

# Conectarse sin contraseña (configuración actual)
mysql -u root

# Conectarse a una base de datos específica
mysql -u root veterinaria_db
```

## 📊 Consultas desde Terminal

### Ver todas las bases de datos
```powershell
mysql -u root -e "SHOW DATABASES;"
```

### Ver todas las tablas
```powershell
mysql -u root veterinaria_db -e "SHOW TABLES;"
```

### Ver estructura de una tabla
```powershell
mysql -u root veterinaria_db -e "DESCRIBE mascotas;"
```

### Consultar dueños y mascotas
```powershell
mysql -u root veterinaria_db -e "SELECT d.nombre AS dueno, m.nombre AS mascota, m.especie FROM duenos d LEFT JOIN mascotas m ON d.id_dueno = m.id_dueno;"
```

### Ver historial de servicios
```powershell
mysql -u root veterinaria_db -e "SELECT m.nombre AS mascota, s.nombre AS servicio, hs.fecha_servicio, hs.precio_cobrado FROM historial_servicios hs JOIN mascotas m ON hs.id_mascota = m.id_mascota JOIN servicios s ON hs.id_servicio = s.id_servicio ORDER BY hs.fecha_servicio DESC;"
```

### Reporte de ingresos totales
```powershell
mysql -u root veterinaria_db -e "SELECT 'Servicios' AS concepto, SUM(precio_cobrado) AS total FROM historial_servicios UNION ALL SELECT 'Productos', SUM(total) FROM ventas;"
```

### Productos con stock
```powershell
mysql -u root veterinaria_db -e "SELECT nombre, categoria, stock, precio FROM productos ORDER BY stock;"
```

### Próximas citas
```powershell
mysql -u root veterinaria_db -e "SELECT m.nombre AS mascota, d.telefono, hs.proximo_control FROM historial_servicios hs JOIN mascotas m ON hs.id_mascota = m.id_mascota JOIN duenos d ON m.id_dueno = d.id_dueno WHERE hs.proximo_control >= CURDATE() ORDER BY hs.proximo_control;"
```

## 💾 Respaldo desde Terminal

### Crear respaldo completo
```powershell
# Respaldo de toda la base de datos
mysqldump -u root veterinaria_db > "D:\MyProjects\veterinaria\backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql"

# Respaldo solo de la estructura (sin datos)
mysqldump -u root --no-data veterinaria_db > "D:\MyProjects\veterinaria\structure_only.sql"

# Respaldo solo de los datos
mysqldump -u root --no-create-info veterinaria_db > "D:\MyProjects\veterinaria\data_only.sql"
```

### Restaurar respaldo
```powershell
Get-Content "D:\MyProjects\veterinaria\backup.sql" -Raw | mysql -u root veterinaria_db
```

## ➕ Operaciones Comunes

### Agregar un nuevo dueño
```powershell
mysql -u root veterinaria_db -e "INSERT INTO duenos (nombre, apellido, telefono, email) VALUES ('Pedro', 'Lopez', '555-0105', 'pedro@email.com'); SELECT LAST_INSERT_ID();"
```

### Agregar una nueva mascota
```powershell
mysql -u root veterinaria_db -e "INSERT INTO mascotas (id_dueno, nombre, especie, raza, sexo, peso_kg) VALUES (1, 'Firulais', 'Perro', 'Mestizo', 'Macho', 15.5);"
```

### Registrar un servicio
```powershell
mysql -u root veterinaria_db -e "INSERT INTO historial_servicios (id_mascota, id_servicio, veterinario, diagnostico, precio_cobrado) VALUES (1, 1, 'Dr. Ramirez', 'Chequeo general', 250.00);"
```

### Actualizar stock de producto
```powershell
mysql -u root veterinaria_db -e "UPDATE productos SET stock = stock - 1 WHERE id_producto = 1;"
```

## 🔍 Búsquedas

### Buscar mascota por nombre
```powershell
mysql -u root veterinaria_db -e "SELECT m.*, d.nombre AS dueno_nombre, d.telefono FROM mascotas m JOIN duenos d ON m.id_dueno = d.id_dueno WHERE m.nombre LIKE '%Max%';"
```

### Buscar dueño por teléfono
```powershell
mysql -u root veterinaria_db -e "SELECT * FROM duenos WHERE telefono = '555-0101';"
```

### Ver historial de una mascota específica
```powershell
mysql -u root veterinaria_db -e "SELECT s.nombre, hs.fecha_servicio, hs.diagnostico, hs.precio_cobrado FROM historial_servicios hs JOIN servicios s ON hs.id_servicio = s.id_servicio WHERE hs.id_mascota = 1 ORDER BY hs.fecha_servicio DESC;"
```

## 📈 Reportes Avanzados

### Clientes más frecuentes
```powershell
mysql -u root veterinaria_db -e "SELECT CONCAT(d.nombre, ' ', d.apellido) AS cliente, COUNT(hs.id_historial) AS visitas, SUM(hs.precio_cobrado) AS total_gastado FROM duenos d LEFT JOIN mascotas m ON d.id_dueno = m.id_dueno LEFT JOIN historial_servicios hs ON m.id_mascota = hs.id_mascota GROUP BY d.id_dueno ORDER BY visitas DESC;"
```

### Servicios más rentables
```powershell
mysql -u root veterinaria_db -e "SELECT s.nombre, COUNT(hs.id_historial) AS veces, SUM(hs.precio_cobrado) AS ingresos FROM servicios s LEFT JOIN historial_servicios hs ON s.id_servicio = hs.id_servicio GROUP BY s.id_servicio ORDER BY ingresos DESC;"
```

### Productos más vendidos
```powershell
mysql -u root veterinaria_db -e "SELECT p.nombre, SUM(v.cantidad) AS unidades, SUM(v.total) AS ingresos FROM productos p LEFT JOIN ventas v ON p.id_producto = v.id_producto GROUP BY p.id_producto ORDER BY unidades DESC;"
```

## 🛠️ Mantenimiento

### Ver tamaño de la base de datos
```powershell
mysql -u root -e "SELECT table_schema AS 'Database', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.tables WHERE table_schema = 'veterinaria_db' GROUP BY table_schema;"
```

### Ver estadísticas de tablas
```powershell
mysql -u root veterinaria_db -e "SELECT table_name, table_rows, ROUND((data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.tables WHERE table_schema = 'veterinaria_db' ORDER BY table_rows DESC;"
```

### Optimizar tablas
```powershell
mysql -u root veterinaria_db -e "OPTIMIZE TABLE duenos, mascotas, servicios, historial_servicios, productos, ventas;"
```

## 🔐 Seguridad

### Cambiar contraseña de root (recomendado para producción)
```powershell
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'TuNuevaContraseñaSegura';"
```

### Después de cambiar la contraseña, conectarse así:
```powershell
mysql -u root -p
# Te pedirá la contraseña
```

## 🛑 Detener MySQL

### Ver procesos MySQL corriendo
```powershell
Get-Process -Name mysqld
```

### Detener MySQL limpiamente
```powershell
mysqladmin -u root shutdown
```

### Forzar cierre (solo si es necesario)
```powershell
Stop-Process -Name mysqld -Force
```

## 📝 Ejecutar Scripts SQL

### Desde archivo
```powershell
# Opción 1
Get-Content "archivo.sql" -Raw | mysql -u root veterinaria_db

# Opción 2 (dentro de MySQL)
mysql -u root
# Luego ejecutar:
# source D:/MyProjects/veterinaria/archivo.sql
```

### Comandos múltiples
```powershell
mysql -u root veterinaria_db -e "
SELECT COUNT(*) FROM duenos;
SELECT COUNT(*) FROM mascotas;
SELECT COUNT(*) FROM servicios;
"
```

## 🎯 Alias Útiles (opcional)

Agrega estos alias a tu perfil de PowerShell para mayor comodidad:

```powershell
# Editar perfil
notepad $PROFILE

# Agregar estos alias:
function Start-MySQL { 
    Start-Process -FilePath "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" -ArgumentList "--datadir=`"C:\ProgramData\MySQL\MySQL Server 8.4\data`"" -WindowStyle Hidden
}

function Connect-Veterinaria {
    mysql -u root veterinaria_db
}

function Backup-Veterinaria {
    $fecha = Get-Date -Format 'yyyyMMdd_HHmmss'
    mysqldump -u root veterinaria_db > "D:\MyProjects\veterinaria\backup_$fecha.sql"
    Write-Host "Respaldo creado: backup_$fecha.sql" -ForegroundColor Green
}

# Usar:
# Start-MySQL
# Connect-Veterinaria
# Backup-Veterinaria
```

## 📚 Recursos

- **Guía completa**: [GUIA_MYSQL_VETERINARIA.md](GUIA_MYSQL_VETERINARIA.md)
- **Scripts**: [setup_simple.sql](setup_simple.sql)
- **Consultas de ejemplo**: [consultas_prueba.sql](consultas_prueba.sql)

## ✅ Estado Actual

- ✅ MySQL 8.4.8 instalado y funcionando
- ✅ Base de datos `veterinaria_db` creada
- ✅ 6 tablas creadas (duenos, mascotas, servicios, historial_servicios, productos, ventas)
- ✅ Datos de ejemplo cargados
- ✅ Usuario root sin contraseña (para desarrollo)

## 🎉 ¡Sistema Listo para Usar!

Ahora puedes trabajar con tu base de datos completamente desde la terminal de PowerShell.
