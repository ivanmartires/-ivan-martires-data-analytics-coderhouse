-- ============================================================
-- M4 — Pre-entrega: Consultas SQL de negocio
-- Extrayendo métricas clave con SQL
-- Base de datos: Ventas_Tech_DB (tabla ventas)
-- Sintaxis de entrega: PostgreSQL
-- (probado localmente en Microsoft SQL Server 2025 Express)
-- ============================================================

-- ============================================================
-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes
-- ============================================================
-- Versión SQL Server:
-- SELECT MONTH(fecha_venta) AS mes, SUM(cantidad * precio_unitario) AS total_facturado,
--        COUNT(*) AS cantidad_pedidos, AVG(cantidad * precio_unitario) AS ticket_promedio
-- FROM ventas GROUP BY MONTH(fecha_venta) ORDER BY mes;

-- Versión de entrega (PostgreSQL):
SELECT
    EXTRACT(MONTH FROM fecha_venta)     AS mes,
    SUM(cantidad * precio_unitario)     AS total_facturado,
    COUNT(*)                            AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)     AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

-- ============================================================
-- Consulta 2 — Ranking de productos
-- Top 5 de productos por total facturado
-- ============================================================
-- Versión SQL Server:
-- SELECT TOP 5 id_producto, SUM(cantidad) AS unidades_vendidas,
--        SUM(cantidad * precio_unitario) AS total_generado
-- FROM ventas GROUP BY id_producto ORDER BY total_generado DESC;

-- Versión de entrega (PostgreSQL):
SELECT
    id_producto,
    SUM(cantidad)                       AS unidades_vendidas,
    SUM(cantidad * precio_unitario)     AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC
LIMIT 5;

-- ============================================================
-- Consulta 3 — Clientes recurrentes
-- Clientes con más de un pedido
-- (sin diferencias de sintaxis entre motores)
-- ============================================================
SELECT
    id_cliente,
    COUNT(*)                            AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)     AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;

-- ============================================================
-- Consulta 4 — Meses por encima/por debajo del promedio
-- Compara el total de cada mes contra el promedio mensual general
-- ============================================================
-- Versión SQL Server: igual que abajo,
-- reemplazando EXTRACT(MONTH FROM fecha_venta) por MONTH(fecha_venta).

-- Versión de entrega (PostgreSQL):
WITH totales_mensuales AS (
    SELECT
        EXTRACT(MONTH FROM fecha_venta)     AS mes,
        SUM(cantidad * precio_unitario)     AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_mensuales)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM totales_mensuales
ORDER BY mes;

-- ============================================================
-- Hallazgos
-- ============================================================
-- 1. La facturación está concentrada en pocos productos de alto valor
--    unitario, no en volumen: el producto 1 (Laptop Pro 15) representa
--    solo el 10% de las unidades vendidas (3 de 29) pero concentra el
--    55,9% de la facturación total ($3.600 de $6.444). El producto 2
--    (Mouse Inalámbrico) es el caso inverso: 45% de las unidades
--    vendidas (13 de 29) pero apenas 5,6% de la facturación ($364).
--    Acción sugerida: priorizar stock y visibilidad del producto 1 —
--    un quiebre de stock ahí golpearía la facturación mucho más que
--    en productos de bajo ticket como el producto 2.
--
-- 2. El 100% de los clientes de la base son recurrentes: los 5
--    clientes cargados realizaron exactamente 2 compras cada uno, sin
--    ningún cliente de compra única en esta muestra.
--    Acción sugerida: si el patrón se confirma con más datos, conviene
--    invertir en retención (fidelización) además de en adquisición,
--    ya que la base ya muestra un comportamiento de recompra alto.
--
-- 3. La comparación mensual (Consulta 4) todavía no es representativa:
--    las 10 ventas cargadas están todas fechadas en marzo de 2024, por
--    lo que solo existe un mes en la base y no se puede observar
--    variación real hasta contar con datos de varios meses.
--    Acción sugerida: cargar ventas de varios meses antes de usar esta
--    consulta para decisiones de estacionalidad — con un solo mes,
--    cualquier conclusión sería prematura.