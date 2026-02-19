# 🐾 Guía MySQL para Veterinaria - Paso a Paso

Esta guía te ayudará a instalar MySQL y crear una base de datos completa para gestionar tu veterinaria.

## 📋 Tabla de Contenidos
1. [Instalación de MySQL](#instalación-de-mysql)
2. [Configuración Inicial](#configuración-inicial)
3. [Diseño de la Base de Datos](#diseño-de-la-base-de-datos)
4. [Creación de Tablas](#creación-de-tablas)
5. [Datos de Ejemplo](#datos-de-ejemplo)
6. [Consultas Útiles](#consultas-útiles)

---

## 1. Instalación de MySQL

### Paso 1: Descargar MySQL
1. Ve a: https://dev.mysql.com/downloads/mysql/
2. Selecciona "Windows" como sistema operativo
3. Descarga el instalador "MySQL Installer for Windows"
4. Haz clic en "Download" (no necesitas crear cuenta, usa "No thanks, just start my download")

### Paso 2: Instalar MySQL
1. Ejecuta el instalador descargado
2. Selecciona "Developer Default" o "Server only"
3. Haz clic en "Next" y luego "Execute" para instalar
4. Espera a que se instalen todos los componentes

### Paso 3: Configurar MySQL Server
1. En "Type and Networking": deja los valores por defecto (Port: 3306)
2. En "Authentication Method": selecciona "Use Strong Password Encryption"
3. En "Accounts and Roles": 
   - Crea una contraseña para el usuario `root` (ejemplo: `Veterinaria2026`)
   - ⚠️ **IMPORTANTE**: Anota esta contraseña, la necesitarás siempre
4. En "Windows Service": deja marcado "Start MySQL Server at System Startup"
5. Haz clic en "Execute" y luego "Finish"

---

## 2. Configuración Inicial

### Paso 1: Abrir MySQL Command Line Client
1. Busca en el menú de inicio: "MySQL Command Line Client"
2. Abre la aplicación
3. Ingresa la contraseña de `root` que creaste

### Paso 2: Crear la Base de Datos
```sql
-- Crear la base de datos para la veterinaria
CREATE DATABASE veterinaria_db;

-- Usar la base de datos
USE veterinaria_db;

-- Verificar que estamos en la base de datos correcta
SELECT DATABASE();
```

---

## 3. Diseño de la Base de Datos

### Estructura de Tablas

Nuestra veterinaria tendrá las siguientes tablas:

1. **dueños**: Información de los dueños de mascotas
2. **mascotas**: Información de las mascotas
3. **servicios**: Catálogo de servicios (consultas, vacunas, cirugías, etc.)
4. **historial_servicios**: Registro de servicios prestados a cada mascota
5. **productos**: Catálogo de productos (medicamentos, alimentos, etc.)
6. **ventas**: Registro de ventas de productos

### Diagrama de Relaciones
```
dueños (1) ----< (N) mascotas
mascotas (1) ----< (N) historial_servicios >---- (1) servicios
ventas >---- (1) mascotas
ventas >---- (1) productos
```

---

## 4. Creación de Tablas

### Paso 1: Crear Tabla de Dueños
```sql
CREATE TABLE dueños (
    id_dueño INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion TEXT,
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    INDEX idx_nombre (nombre, apellido),
    INDEX idx_telefono (telefono)
);
```

### Paso 2: Crear Tabla de Mascotas
```sql
CREATE TABLE mascotas (
    id_mascota INT PRIMARY KEY AUTO_INCREMENT,
    id_dueño INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    raza VARCHAR(100),
    fecha_nacimiento DATE,
    sexo ENUM('Macho', 'Hembra') NOT NULL,
    color VARCHAR(50),
    peso_kg DECIMAL(5,2),
    observaciones TEXT,
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_dueño) REFERENCES dueños(id_dueño),
    INDEX idx_dueño (id_dueño),
    INDEX idx_nombre (nombre)
);
```

### Paso 3: Crear Tabla de Servicios
```sql
CREATE TABLE servicios (
    id_servicio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    duracion_minutos INT,
    activo BOOLEAN DEFAULT TRUE,
    INDEX idx_nombre (nombre)
);
```

### Paso 4: Crear Tabla de Historial de Servicios
```sql
CREATE TABLE historial_servicios (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_mascota INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha_servicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    veterinario VARCHAR(100),
    diagnostico TEXT,
    tratamiento TEXT,
    precio_cobrado DECIMAL(10,2) NOT NULL,
    observaciones TEXT,
    proximo_control DATE,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio),
    INDEX idx_mascota (id_mascota),
    INDEX idx_fecha (fecha_servicio)
);
```

### Paso 5: Crear Tabla de Productos
```sql
CREATE TABLE productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    categoria VARCHAR(50),
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    activo BOOLEAN DEFAULT TRUE,
    INDEX idx_nombre (nombre),
    INDEX idx_categoria (categoria)
);
```

### Paso 6: Crear Tabla de Ventas
```sql
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_mascota INT,
    id_producto INT NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia') DEFAULT 'Efectivo',
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    INDEX idx_fecha (fecha_venta),
    INDEX idx_mascota (id_mascota)
);
```

---

## 5. Datos de Ejemplo

### Insertar Dueños
```sql
INSERT INTO dueños (nombre, apellido, telefono, email, direccion) VALUES
('Juan', 'Pérez', '555-0101', 'juan.perez@email.com', 'Calle Principal 123'),
('María', 'González', '555-0102', 'maria.gonzalez@email.com', 'Avenida Central 456'),
('Carlos', 'Rodríguez', '555-0103', 'carlos.rodriguez@email.com', 'Boulevard Norte 789'),
('Ana', 'Martínez', '555-0104', 'ana.martinez@email.com', 'Calle Sur 321');
```

### Insertar Mascotas
```sql
INSERT INTO mascotas (id_dueño, nombre, especie, raza, fecha_nacimiento, sexo, color, peso_kg) VALUES
(1, 'Max', 'Perro', 'Labrador', '2020-03-15', 'Macho', 'Dorado', 28.5),
(1, 'Luna', 'Gato', 'Siamés', '2021-07-20', 'Hembra', 'Crema', 4.2),
(2, 'Rocky', 'Perro', 'Pastor Alemán', '2019-05-10', 'Macho', 'Negro y café', 35.0),
(3, 'Michi', 'Gato', 'Persa', '2022-01-05', 'Macho', 'Gris', 5.1),
(4, 'Toto', 'Perro', 'Chihuahua', '2021-11-30', 'Macho', 'Café', 2.8);
```

### Insertar Servicios
```sql
INSERT INTO servicios (nombre, descripcion, precio, duracion_minutos) VALUES
('Consulta General', 'Revisión general del estado de salud', 250.00, 30),
('Vacunación', 'Aplicación de vacunas según calendario', 180.00, 15),
('Desparasitación', 'Tratamiento antiparasitario interno', 150.00, 10),
('Baño y Corte', 'Baño completo y corte de pelo', 300.00, 90),
('Cirugía Menor', 'Procedimientos quirúrgicos menores', 1500.00, 120),
('Esterilización', 'Cirugía de esterilización', 2000.00, 180),
('Limpieza Dental', 'Limpieza y profilaxis dental', 500.00, 60),
('Radiografía', 'Estudio radiográfico', 400.00, 30);
```

### Insertar Productos
```sql
INSERT INTO productos (nombre, descripcion, categoria, precio, stock, stock_minimo) VALUES
('Alimento Premium Perro 15kg', 'Alimento balanceado para perros adultos', 'Alimento', 850.00, 50, 10),
('Alimento Premium Gato 7kg', 'Alimento balanceado para gatos adultos', 'Alimento', 600.00, 40, 8),
('Collar Antipulgas', 'Collar de protección contra pulgas y garrapatas', 'Higiene', 180.00, 100, 20),
('Shampoo Medicado', 'Shampoo para pieles sensibles', 'Higiene', 120.00, 60, 15),
('Vitaminas', 'Suplemento vitamínico multifuncional', 'Medicamento', 250.00, 30, 10),
('Antiparasitario Interno', 'Desparasitante en tabletas', 'Medicamento', 80.00, 80, 20);
```

### Insertar Historial de Servicios
```sql
INSERT INTO historial_servicios (id_mascota, id_servicio, veterinario, diagnostico, tratamiento, precio_cobrado, proximo_control) VALUES
(1, 1, 'Dr. Ramírez', 'Estado de salud óptimo', 'Mantenimiento preventivo', 250.00, '2026-08-18'),
(1, 2, 'Dr. Ramírez', 'Vacunación anual', 'Aplicación de vacuna múltiple', 180.00, '2027-02-18'),
(2, 1, 'Dra. López', 'Irritación ocular leve', 'Gotas oftálmicas', 250.00, '2026-03-04'),
(3, 6, 'Dr. Ramírez', 'Esterilización programada', 'Cirugía sin complicaciones', 2000.00, '2026-03-11'),
(5, 4, 'Asistente Pérez', 'Baño de rutina', 'Baño completo y corte de uñas', 300.00, NULL);
```

### Insertar Ventas
```sql
INSERT INTO ventas (id_mascota, id_producto, cantidad, precio_unitario, subtotal, descuento, total, metodo_pago) VALUES
(1, 1, 1, 850.00, 850.00, 0, 850.00, 'Tarjeta'),
(2, 2, 1, 600.00, 600.00, 50.00, 550.00, 'Efectivo'),
(1, 3, 2, 180.00, 360.00, 0, 360.00, 'Tarjeta'),
(3, 5, 1, 250.00, 250.00, 0, 250.00, 'Transferencia'),
(5, 4, 1, 120.00, 120.00, 0, 120.00, 'Efectivo');
```

---

## 6. Consultas Útiles

### 📊 Consultas de Información

#### Ver todos los dueños con sus mascotas
```sql
SELECT 
    d.nombre AS dueño_nombre,
    d.apellido AS dueño_apellido,
    d.telefono,
    m.nombre AS mascota_nombre,
    m.especie,
    m.raza
FROM dueños d
LEFT JOIN mascotas m ON d.id_dueño = m.id_dueño
ORDER BY d.apellido, d.nombre;
```

#### Ver historial completo de una mascota
```sql
SELECT 
    m.nombre AS mascota,
    CONCAT(d.nombre, ' ', d.apellido) AS dueño,
    s.nombre AS servicio,
    hs.fecha_servicio,
    hs.veterinario,
    hs.diagnostico,
    hs.precio_cobrado
FROM historial_servicios hs
JOIN mascotas m ON hs.id_mascota = m.id_mascota
JOIN dueños d ON m.id_dueño = d.id_dueño
JOIN servicios s ON hs.id_servicio = s.id_servicio
WHERE m.nombre = 'Max'
ORDER BY hs.fecha_servicio DESC;
```

#### Ver mascotas que necesitan próximo control
```sql
SELECT 
    m.nombre AS mascota,
    CONCAT(d.nombre, ' ', d.apellido) AS dueño,
    d.telefono,
    s.nombre AS servicio,
    hs.proximo_control
FROM historial_servicios hs
JOIN mascotas m ON hs.id_mascota = m.id_mascota
JOIN dueños d ON m.id_dueño = d.id_dueño
JOIN servicios s ON hs.id_servicio = s.id_servicio
WHERE hs.proximo_control IS NOT NULL 
    AND hs.proximo_control >= CURDATE()
ORDER BY hs.proximo_control;
```

### 💰 Consultas de Ventas y Finanzas

#### Total de ingresos por servicios (mes actual)
```sql
SELECT 
    DATE_FORMAT(fecha_servicio, '%Y-%m') AS mes,
    COUNT(*) AS total_servicios,
    SUM(precio_cobrado) AS ingresos_totales
FROM historial_servicios
WHERE YEAR(fecha_servicio) = YEAR(CURDATE())
    AND MONTH(fecha_servicio) = MONTH(CURDATE())
GROUP BY DATE_FORMAT(fecha_servicio, '%Y-%m');
```

#### Total de ventas de productos (mes actual)
```sql
SELECT 
    DATE_FORMAT(fecha_venta, '%Y-%m') AS mes,
    COUNT(*) AS total_ventas,
    SUM(total) AS ingresos_totales
FROM ventas
WHERE YEAR(fecha_venta) = YEAR(CURDATE())
    AND MONTH(fecha_venta) = MONTH(CURDATE())
GROUP BY DATE_FORMAT(fecha_venta, '%Y-%m');
```

#### Servicios más solicitados
```sql
SELECT 
    s.nombre AS servicio,
    COUNT(hs.id_historial) AS veces_solicitado,
    SUM(hs.precio_cobrado) AS ingresos_totales,
    AVG(hs.precio_cobrado) AS precio_promedio
FROM servicios s
LEFT JOIN historial_servicios hs ON s.id_servicio = hs.id_servicio
GROUP BY s.id_servicio
ORDER BY veces_solicitado DESC;
```

#### Productos más vendidos
```sql
SELECT 
    p.nombre AS producto,
    p.categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.total) AS ingresos_totales
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
GROUP BY p.id_producto
ORDER BY unidades_vendidas DESC;
```

#### Productos con stock bajo
```sql
SELECT 
    nombre,
    categoria,
    stock,
    stock_minimo,
    (stock_minimo - stock) AS cantidad_a_pedir
FROM productos
WHERE stock <= stock_minimo
    AND activo = TRUE
ORDER BY stock;
```

### 🔍 Consultas de Análisis

#### Clientes más frecuentes
```sql
SELECT 
    CONCAT(d.nombre, ' ', d.apellido) AS cliente,
    d.telefono,
    COUNT(DISTINCT m.id_mascota) AS total_mascotas,
    COUNT(hs.id_historial) AS total_visitas,
    SUM(hs.precio_cobrado) AS total_gastado
FROM dueños d
LEFT JOIN mascotas m ON d.id_dueño = m.id_dueño
LEFT JOIN historial_servicios hs ON m.id_mascota = hs.id_mascota
GROUP BY d.id_dueño
ORDER BY total_visitas DESC;
```

#### Ingresos totales del día
```sql
SELECT 
    'Servicios' AS tipo,
    SUM(precio_cobrado) AS ingresos
FROM historial_servicios
WHERE DATE(fecha_servicio) = CURDATE()
UNION ALL
SELECT 
    'Productos' AS tipo,
    SUM(total) AS ingresos
FROM ventas
WHERE DATE(fecha_venta) = CURDATE();
```

#### Resumen de mascotas por especie
```sql
SELECT 
    especie,
    COUNT(*) AS cantidad,
    AVG(peso_kg) AS peso_promedio
FROM mascotas
WHERE activo = TRUE
GROUP BY especie;
```

---

## 🛠️ Operaciones Comunes

### Registrar una nueva visita
```sql
-- 1. Primero verifica el ID de la mascota y del servicio
SELECT id_mascota, nombre FROM mascotas WHERE nombre = 'Max';
SELECT id_servicio, nombre, precio FROM servicios WHERE nombre = 'Consulta General';

-- 2. Registra el servicio
INSERT INTO historial_servicios 
    (id_mascota, id_servicio, veterinario, diagnostico, tratamiento, precio_cobrado, proximo_control)
VALUES 
    (1, 1, 'Dr. Ramírez', 'Diagnóstico aquí', 'Tratamiento aquí', 250.00, '2026-03-18');
```

### Registrar una venta
```sql
-- 1. Verifica el producto
SELECT id_producto, nombre, precio, stock FROM productos WHERE nombre LIKE '%Alimento%';

-- 2. Registra la venta
INSERT INTO ventas 
    (id_mascota, id_producto, cantidad, precio_unitario, subtotal, descuento, total, metodo_pago)
VALUES 
    (1, 1, 1, 850.00, 850.00, 0, 850.00, 'Efectivo');

-- 3. Actualiza el stock
UPDATE productos 
SET stock = stock - 1 
WHERE id_producto = 1;
```

### Agregar un nuevo dueño con mascota
```sql
-- 1. Agregar el dueño
INSERT INTO dueños (nombre, apellido, telefono, email, direccion)
VALUES ('Pedro', 'Sánchez', '555-0105', 'pedro@email.com', 'Calle Nueva 100');

-- 2. Obtener el ID del dueño recién creado
SELECT LAST_INSERT_ID();

-- 3. Agregar la mascota (usa el ID obtenido)
INSERT INTO mascotas (id_dueño, nombre, especie, raza, fecha_nacimiento, sexo, color, peso_kg)
VALUES (LAST_INSERT_ID(), 'Bobby', 'Perro', 'Bulldog', '2022-06-15', 'Macho', 'Blanco', 15.0);
```

---

## 📱 Consejos Importantes

### Respaldo de la Base de Datos
Para hacer un respaldo de tu base de datos:
```sql
-- En el Command Line Client, sal de MySQL (escribe exit)
-- Luego en la línea de comandos de Windows ejecuta:
-- mysqldump -u root -p veterinaria_db > respaldo_veterinaria.sql
```

### Restaurar un Respaldo
```sql
-- En la línea de comandos de Windows:
-- mysql -u root -p veterinaria_db < respaldo_veterinaria.sql
```

### Ver Estructura de una Tabla
```sql
DESCRIBE mascotas;
-- o
SHOW COLUMNS FROM mascotas;
```

### Ver todas las tablas
```sql
SHOW TABLES;
```

---

## ✅ Verificación Final

Para verificar que todo está funcionando correctamente, ejecuta:

```sql
-- Contar registros en cada tabla
SELECT 'Dueños' AS tabla, COUNT(*) AS registros FROM dueños
UNION ALL
SELECT 'Mascotas', COUNT(*) FROM mascotas
UNION ALL
SELECT 'Servicios', COUNT(*) FROM servicios
UNION ALL
SELECT 'Historial', COUNT(*) FROM historial_servicios
UNION ALL
SELECT 'Productos', COUNT(*) FROM productos
UNION ALL
SELECT 'Ventas', COUNT(*) FROM ventas;
```

---

## 🆘 Solución de Problemas

### No puedo conectarme a MySQL
- Verifica que el servicio MySQL esté corriendo en Windows
- Busca "Servicios" en Windows y busca "MySQL80"
- Asegúrate de usar la contraseña correcta

### Error "Access denied"
- Verifica tu contraseña de root
- Intenta: `mysql -u root -p` y luego ingresa tu contraseña

### Error al crear tablas
- Asegúrate de estar usando la base de datos correcta con `USE veterinaria_db;`
- Verifica que no existan tablas con el mismo nombre con `SHOW TABLES;`

---

## 🎓 Recursos Adicionales

- [Documentación oficial de MySQL](https://dev.mysql.com/doc/)
- [Tutorial de SQL](https://www.w3schools.com/sql/)

---

**¡Felicidades!** 🎉 Ya tienes tu base de datos de veterinaria funcionando. Puedes empezar a agregar tus propios datos y crear consultas personalizadas según las necesidades de tu negocio.
