-- ============================================================
-- M5 — Pre-entrega: Consultas con JOINs para el proyecto
-- Cruzando tablas para enriquecer el análisis
-- Base de datos: Ventas_Tech_DB
-- ============================================================

USE Ventas_Tech_DB;

-- ============================================================
-- Consulta - 1 Vista base del proyecto (INNER JOIN)
-- Ventas enriquecidas con cliente, producto y categoría
-- ============================================================
SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre                            AS cliente,
    c.ciudad,
    p.nombre_producto                   AS producto,
    cat.nombre_categoria                AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario      AS total_venta
FROM ventas v
INNER JOIN clientes c    ON v.id_cliente = c.id_cliente
INNER JOIN productos p   ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- ============================================================
-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
-- Nota: con los datos actuales, los 5 clientes ya compraron al
-- menos una vez — esperable 0 filas.
-- ============================================================
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- ============================================================
-- Consulta 3 — Productos sin ventas (LEFT JOIN)
-- Nota: los 6 productos cargados en M3 tienen al menos una venta
-- registrada — esperable 0 filas con los datos actuales.
-- ============================================================
SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- ============================================================
-- Consulta 4 — Consolidado por canal (UNION ALL)
-- No hay columna de canal en el esquema: se genera como valor
-- literal, separando las ventas por quincena de marzo 2024.
-- ============================================================
SELECT
    canal,
    SUM(total) AS total_facturado
FROM (
    SELECT
        fecha_venta                      AS fecha,
        cantidad * precio_unitario       AS total,
        'Primera quincena'               AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta                      AS fecha,
        cantidad * precio_unitario       AS total,
        'Segunda quincena'               AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
) consolidado
GROUP BY canal;
