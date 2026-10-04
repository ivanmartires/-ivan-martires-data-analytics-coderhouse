# RetailPro — Entregas del curso de Data Analytics

Repositorio con las entregas del proyecto integrador del curso de Data Analytics (Coderhouse). El proyecto analiza las ventas de **RetailPro**, una empresa de retail ficticia, desde el modelado de la base de datos hasta el modelo analítico en Power BI.

> Los datos son ficticios y de tamaño reducido: están pensados para practicar, no para sacar conclusiones de negocio reales.

## Estructura del repositorio

```
├── sql-checkpoint/
│   ├── ventas_tech_db.sql          # M3: crea la base, las tablas, las claves y carga los datos
│   ├── m4_consultas_negocio.sql    # M4: métricas con GROUP BY, HAVING y CASE WHEN
│   └── m5_consultas_joins.sql      # M5: INNER JOIN, LEFT JOIN y UNION ALL
├── modulo_06/
│   └── Pipeline_ETL_Martires_Ivan.pbix   # M6: ETL en Power Query
├── modulo_08/
│   └── Martires_Ivan_Checkpoint2.pbix    # M8: modelo de datos y medidas DAX
└── README.md
```

La carpeta `sql-checkpoint` agrupa los scripts de los módulos 3, 4 y 5; por eso no sigue el formato `modulo_0X` de las demás.

## Herramientas

- Microsoft SQL Server 2025 Express y SQL Server Management Studio (SSMS)
- Power BI Desktop (Power Query / lenguaje M, modelado y DAX)
- Excel (dataset provisto por el curso para la parte de Power BI)
- Git y GitHub

## Parte 1 — Base de datos SQL (`sql-checkpoint`)

Base de datos `Ventas_Tech_DB`, con 4 tablas relacionadas:

```
categorias (1) ── (N) productos (1) ── (N) ventas (N) ── (1) clientes
```

| Tabla | Filas cargadas |
|---|---|
| categorias | 4 |
| clientes | 5 |
| productos | 6 |
| ventas | 10 (todas de marzo de 2024) |

### Cómo ejecutar los scripts

**Requisitos:** SQL Server (probado en la versión 2025 Express) y SSMS. Los tres scripts no usan el mismo dialecto:

| Script | Dialecto |
|---|---|
| `ventas_tech_db.sql` | T-SQL (`USE`, `GO`, `TINYINT`): corre en SQL Server |
| `m5_consultas_joins.sql` | JOINs estándar, con `USE` al inicio: corre en SQL Server |
| `m4_consultas_negocio.sql` | Entregado en sintaxis PostgreSQL (`EXTRACT`, `LIMIT`); las equivalentes de SQL Server (`MONTH()`, `TOP`) están comentadas arriba de cada consulta |

1. Abrí SSMS y conectate a tu instancia de SQL Server.
2. Abrí y ejecutá completo `sql-checkpoint/ventas_tech_db.sql`. Crea la base, borra y recrea las tablas y carga los datos; se puede volver a ejecutar sin errores.
3. Ejecutá `m5_consultas_joins.sql`. Depende de las tablas y los datos del paso 2 y empieza con `USE Ventas_Tech_DB`.
4. Para `m4_consultas_negocio.sql`, seleccioná primero la base `Ventas_Tech_DB` (el script no incluye `USE`) y usá las versiones de SQL Server de las consultas 1 y 2, que están comentadas. En la consulta 4, reemplazá `EXTRACT(MONTH FROM fecha_venta)` por `MONTH(fecha_venta)`. Las versiones ejecutables están en sintaxis PostgreSQL y SQL Server las rechaza. La consulta 3 es igual en ambos motores.

**Resultados esperados:**

- En `m4_consultas_negocio.sql`, las consultas que agrupan por mes devuelven una sola fila, porque todas las ventas son de marzo de 2024.
- En `m5_consultas_joins.sql`, las consultas 2 y 3 (clientes sin ventas y productos sin ventas) devuelven 0 filas: todos los clientes y productos cargados tienen al menos una venta.

## Parte 2 — Power BI (`modulo_06` y `modulo_08`)

**Requisito:** Power BI Desktop (Windows).

Los archivos `.pbix` **no se conectan a la base SQL**: parten del archivo Excel `Pipeline_ETL_Dataset.xlsx`, provisto por el curso y no incluido en este repositorio (50 ventas entre enero de 2023 y julio de 2024).

- **`modulo_06` — ETL:** eliminación de duplicados, tratamiento de nulos, corrección de tipos de dato, nomenclatura `Dim_` / `Fact_` y merge para enriquecer `Fact_Ventas`.
- **`modulo_08` — Modelo analítico:** relaciones 1:N con dirección única, tabla calendario `Dim_Fechas`, tabla `_Medidas` con 5 medidas DAX (Total Ventas, Ventas Online, Ventas YTD, Ventas LY y % Crecimiento Anual) y una página de validación con matriz.

**Nota sobre la fuente de datos:** el origen del Excel está configurado con una ruta local de la PC del autor. Los archivos se abren y se pueden explorar sin problema, pero para actualizar los datos hay que cambiar el origen (Transformar datos → Configuración de origen de datos) y apuntarlo a tu copia del Excel.

## Autor

Ivan Martires
