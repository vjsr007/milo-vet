-- ========================================
-- CONSULTAS DE PRUEBA - VETERINARIA DB
-- ========================================
-- Ejecuta estas consultas para probar la base de datos

USE veterinaria_db;

-- ========================================
-- 1. VERIFICAR DATOS BÁSICOS
-- ========================================

-- Ver todos los dueños
SELECT * FROM dueños;

-- Ver todas las mascotas
SELECT * FROM mascotas;

-- Ver todos los servicios
SELECT * FROM servicios;

-- ========================================
-- 2. CONSULTAS CON JOINS
-- ========================================

-- Ver dueños con sus mascotas
SELECT 
    d.nombre AS dueño_nombre,
    d.apellido AS dueño_apellido,
    d.telefono,
    m.nombre AS mascota_nombre,
    m.especie,
    m.raza,
    m.edad_años
FROM dueños d
LEFT JOIN mascotas m ON d.id_dueño = m.id_dueño
ORDER BY d.apellido, d.nombre;

-- Ver historial completo de servicios
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
ORDER BY hs.fecha_servicio DESC;

-- ========================================
-- 3. REPORTES FINANCIEROS
-- ========================================

-- Total de ingresos por servicios
SELECT 
    'Total Ingresos por Servicios' AS concepto,
    SUM(precio_cobrado) AS total,
    COUNT(*) AS cantidad_servicios
FROM historial_servicios;

-- Total de ventas de productos
SELECT 
    'Total Ventas de Productos' AS concepto,
    SUM(total) AS total,
    COUNT(*) AS cantidad_ventas
FROM ventas;

-- Ingresos totales (servicios + productos)
SELECT 
    SUM(total_ingresos) AS ingresos_totales
FROM (
    SELECT SUM(precio_cobrado) AS total_ingresos FROM historial_servicios
    UNION ALL
    SELECT SUM(total) FROM ventas
) AS ingresos;

-- ========================================
-- 4. ANÁLISIS DE SERVICIOS
-- ========================================

-- Servicios más solicitados
SELECT 
    s.nombre AS servicio,
    COUNT(hs.id_historial) AS veces_solicitado,
    SUM(hs.precio_cobrado) AS ingresos_totales,
    AVG(hs.precio_cobrado) AS precio_promedio
FROM servicios s
LEFT JOIN historial_servicios hs ON s.id_servicio = hs.id_servicio
GROUP BY s.id_servicio, s.nombre
ORDER BY veces_solicitado DESC;

-- ========================================
-- 5. ANÁLISIS DE PRODUCTOS
-- ========================================

-- Productos más vendidos
SELECT 
    p.nombre AS producto,
    p.categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.total) AS ingresos_totales
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
GROUP BY p.id_producto
ORDER BY unidades_vendidas DESC;

-- Productos con stock bajo (requieren reabastecimiento)
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

-- ========================================
-- 6. ANÁLISIS DE CLIENTES
-- ========================================

-- Clientes más frecuentes
SELECT 
    CONCAT(d.nombre, ' ', d.apellido) AS cliente,
    d.telefono,
    COUNT(DISTINCT m.id_mascota) AS total_mascotas,
    COUNT(hs.id_historial) AS total_visitas,
    COALESCE(SUM(hs.precio_cobrado), 0) AS total_gastado_servicios
FROM dueños d
LEFT JOIN mascotas m ON d.id_dueño = m.id_dueño
LEFT JOIN historial_servicios hs ON m.id_mascota = hs.id_mascota
GROUP BY d.id_dueño
ORDER BY total_visitas DESC;

-- ========================================
-- 7. PRÓXIMOS CONTROLES
-- ========================================

-- Mascotas que necesitan próximo control
SELECT 
    m.nombre AS mascota,
    CONCAT(d.nombre, ' ', d.apellido) AS dueño,
    d.telefono,
    s.nombre AS servicio,
    hs.proximo_control AS fecha_control,
    DATEDIFF(hs.proximo_control, CURDATE()) AS dias_restantes
FROM historial_servicios hs
JOIN mascotas m ON hs.id_mascota = m.id_mascota
JOIN dueños d ON m.id_dueño = d.id_dueño
JOIN servicios s ON hs.id_servicio = s.id_servicio
WHERE hs.proximo_control IS NOT NULL 
    AND hs.proximo_control >= CURDATE()
ORDER BY hs.proximo_control;

-- ========================================
-- 8. ESTADÍSTICAS DE MASCOTAS
-- ========================================

-- Resumen por especie
SELECT 
    especie,
    COUNT(*) AS cantidad,
    AVG(peso_kg) AS peso_promedio_kg
FROM mascotas
WHERE activo = TRUE
GROUP BY especie;

-- Distribución por sexo
SELECT 
    especie,
    sexo,
    COUNT(*) AS cantidad
FROM mascotas
WHERE activo = TRUE
GROUP BY especie, sexo
ORDER BY especie, sexo;

-- ========================================
-- 9. BÚSQUEDAS ESPECÍFICAS
-- ========================================

-- Buscar mascota por nombre
SELECT 
    m.nombre AS mascota,
    m.especie,
    m.raza,
    CONCAT(d.nombre, ' ', d.apellido) AS dueño,
    d.telefono
FROM mascotas m
JOIN dueños d ON m.id_dueño = d.id_dueño
WHERE m.nombre LIKE '%Max%';

-- Buscar dueño por teléfono
SELECT 
    CONCAT(d.nombre, ' ', d.apellido) AS dueño,
    d.telefono,
    d.email,
    COUNT(m.id_mascota) AS total_mascotas
FROM dueños d
LEFT JOIN mascotas m ON d.id_dueño = m.id_dueño
WHERE d.telefono LIKE '%555-0101%'
GROUP BY d.id_dueño;

-- ========================================
-- 10. HISTORIAL DE UNA MASCOTA ESPECÍFICA
-- ========================================

-- Historial completo de "Max"
SELECT 
    'Servicios' AS tipo,
    s.nombre AS detalle,
    hs.fecha_servicio AS fecha,
    hs.precio_cobrado AS monto,
    hs.veterinario,
    hs.diagnostico AS observaciones
FROM historial_servicios hs
JOIN mascotas m ON hs.id_mascota = m.id_mascota
JOIN servicios s ON hs.id_servicio = s.id_servicio
WHERE m.nombre = 'Max'
UNION ALL
SELECT 
    'Venta' AS tipo,
    p.nombre AS detalle,
    v.fecha_venta AS fecha,
    v.total AS monto,
    v.metodo_pago AS veterinario,
    CONCAT('Cantidad: ', v.cantidad) AS observaciones
FROM ventas v
JOIN mascotas m ON v.id_mascota = m.id_mascota
JOIN productos p ON v.id_producto = p.id_producto
WHERE m.nombre = 'Max'
ORDER BY fecha DESC;

-- ========================================
-- ✅ FIN DE CONSULTAS DE PRUEBA
-- ========================================

SELECT '¡Todas las consultas ejecutadas exitosamente!' AS mensaje;
