USE veterinaria_db;

CREATE TABLE IF NOT EXISTS duenos (
    id_dueno INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion TEXT,
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    INDEX idx_nombre (nombre, apellido),
    INDEX idx_telefono (telefono)
);

CREATE TABLE IF NOT EXISTS mascotas (
    id_mascota INT PRIMARY KEY AUTO_INCREMENT,
    id_dueno INT NOT NULL,
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
    FOREIGN KEY (id_dueno) REFERENCES duenos(id_dueno),
    INDEX idx_dueno (id_dueno),
    INDEX idx_nombre (nombre)
);

CREATE TABLE IF NOT EXISTS servicios (
    id_servicio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    duracion_minutos INT,
    activo BOOLEAN DEFAULT TRUE,
    INDEX idx_nombre (nombre)
);

CREATE TABLE IF NOT EXISTS historial_servicios (
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

CREATE TABLE IF NOT EXISTS productos (
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

CREATE TABLE IF NOT EXISTS ventas (
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

INSERT INTO duenos (nombre, apellido, telefono, email, direccion) VALUES
('Juan', 'Perez', '555-0101', 'juan.perez@email.com', 'Calle Principal 123'),
('Maria', 'Gonzalez', '555-0102', 'maria.gonzalez@email.com', 'Avenida Central 456'),
('Carlos', 'Rodriguez', '555-0103', 'carlos.rodriguez@email.com', 'Boulevard Norte 789'),
('Ana', 'Martinez', '555-0104', 'ana.martinez@email.com', 'Calle Sur 321');

INSERT INTO mascotas (id_dueno, nombre, especie, raza, fecha_nacimiento, sexo, color, peso_kg) VALUES
(1, 'Max', 'Perro', 'Labrador', '2020-03-15', 'Macho', 'Dorado', 28.5),
(1, 'Luna', 'Gato', 'Siames', '2021-07-20', 'Hembra', 'Crema', 4.2),
(2, 'Rocky', 'Perro', 'Pastor Aleman', '2019-05-10', 'Macho', 'Negro y cafe', 35.0),
(3, 'Michi', 'Gato', 'Persa', '2022-01-05', 'Macho', 'Gris', 5.1),
(4, 'Toto', 'Perro', 'Chihuahua', '2021-11-30', 'Macho', 'Cafe', 2.8);

INSERT INTO servicios (nombre, descripcion, precio, duracion_minutos) VALUES
('Consulta General', 'Revision general del estado de salud', 250.00, 30),
('Vacunacion', 'Aplicacion de vacunas segun calendario', 180.00, 15),
('Desparasitacion', 'Tratamiento antiparasitario interno', 150.00, 10),
('Bano y Corte', 'Bano completo y corte de pelo', 300.00, 90),
('Cirugia Menor', 'Procedimientos quirurgicos menores', 1500.00, 120),
('Esterilizacion', 'Cirugia de esterilizacion', 2000.00, 180),
('Limpieza Dental', 'Limpieza y profilaxis dental', 500.00, 60),
('Radiografia', 'Estudio radiografico', 400.00, 30);

INSERT INTO productos (nombre, descripcion, categoria, precio, stock, stock_minimo) VALUES
('Alimento Premium Perro 15kg', 'Alimento balanceado para perros adultos', 'Alimento', 850.00, 50, 10),
('Alimento Premium Gato 7kg', 'Alimento balanceado para gatos adultos', 'Alimento', 600.00, 40, 8),
('Collar Antipulgas', 'Collar de proteccion contra pulgas y garrapatas', 'Higiene', 180.00, 100, 20),
('Shampoo Medicado', 'Shampoo para pieles sensibles', 'Higiene', 120.00, 60, 15),
('Vitaminas', 'Suplemento vitaminico multifuncional', 'Medicamento', 250.00, 30, 10),
('Antiparasitario Interno', 'Desparasitante en tabletas', 'Medicamento', 80.00, 80, 20);

INSERT INTO historial_servicios (id_mascota, id_servicio, veterinario, diagnostico, tratamiento, precio_cobrado, proximo_control) VALUES
(1, 1, 'Dr. Ramirez', 'Estado de salud optimo', 'Mantenimiento preventivo', 250.00, '2026-08-18'),
(1, 2, 'Dr. Ramirez', 'Vacunacion anual', 'Aplicacion de vacuna multiple', 180.00, '2027-02-18'),
(2, 1, 'Dra. Lopez', 'Irritacion ocular leve', 'Gotas oftalmicas', 250.00, '2026-03-04'),
(3, 6, 'Dr. Ramirez', 'Esterilizacion programada', 'Cirugia sin complicaciones', 2000.00, '2026-03-11'),
(5, 4, 'Asistente Perez', 'Bano de rutina', 'Bano completo y corte de unas', 300.00, NULL);

INSERT INTO ventas (id_mascota, id_producto, cantidad, precio_unitario, subtotal, descuento, total, metodo_pago) VALUES
(1, 1, 1, 850.00, 850.00, 0, 850.00, 'Tarjeta'),
(2, 2, 1, 600.00, 600.00, 50.00, 550.00, 'Efectivo'),
(1, 3, 2, 180.00, 360.00, 0, 360.00, 'Tarjeta'),
(3, 5, 1, 250.00, 250.00, 0, 250.00, 'Transferencia'),
(5, 4, 1, 120.00, 120.00, 0, 120.00, 'Efectivo');

SELECT 'Tablas creadas exitosamente' AS mensaje;
SELECT 'Duenos' AS tabla, COUNT(*) AS registros FROM duenos
UNION ALL SELECT 'Mascotas', COUNT(*) FROM mascotas
UNION ALL SELECT 'Servicios', COUNT(*) FROM servicios
UNION ALL SELECT 'Historial', COUNT(*) FROM historial_servicios
UNION ALL SELECT 'Productos', COUNT(*) FROM productos
UNION ALL SELECT 'Ventas', COUNT(*) FROM ventas;
