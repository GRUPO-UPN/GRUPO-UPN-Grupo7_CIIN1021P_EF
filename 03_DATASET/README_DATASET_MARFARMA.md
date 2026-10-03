# DATASET MARFARMA (65,000 Registros)

**DATOS SINTÉTICOS PARA FINES ACADÉMICOS**

Este dataset ha sido generado específicamente para el proyecto universitario de Bases de Datos Avanzadas y Big Data asociado a la botica/agente **MARFARMA**, ubicada en Cajamarca, Perú.

## Contenido del Dataset

El dataset simula las operaciones comerciales de MARFARMA entre enero de 2024 y agosto de 2026. 

Se incluyen los siguientes archivos generados en el directorio `/datos`:
1. `MARFARMA_VENTAS_65000.csv`: Tabla denormalizada (sábana) con toda la información consolidada.
2. `MARFARMA_CLIENTES.csv`: Catálogo de 5,000 clientes con datos demográficos peruanos.
3. `MARFARMA_PRODUCTOS.csv`: Catálogo de 300 productos de botica clasificados por categorías reales.
4. `MARFARMA_VENDEDORES.csv`: Catálogo de 30 vendedores organizados por turnos (Mañana, Tarde, Noche).
5. `MARFARMA_VENTAS.csv`: Cabecera de 65,000 ventas únicas.
6. `MARFARMA_DETALLE_VENTA.csv`: Líneas de detalle asociadas a cada venta (relación 1:N).
7. `MARFARMA_RESUMEN_ESTADISTICO.csv`: Agrupaciones analíticas de muestra (ventas por año, mes y categoría).

## Generación y Reglas de Coherencia

- **Semilla Fija**: Se utilizó `SEED = 2026` en Python (numpy, random y Faker) para asegurar la reproducibilidad de la data.
- **Contexto Geográfico**: Los clientes residen principalmente en Cajamarca y sus distritos (Baños del Inca, La Encañada, Llacanora, etc.).
- **Coherencia de Negocio**:
  - Los productos que normalmente requieren receta médica (Antibióticos, Gastrointestinales) tienen marcado `requiere_receta = SI`.
  - Los horarios de las ventas coinciden matemáticamente con el turno asignado al vendedor en la base de datos (Mañana, Tarde o Noche).
  - Los cálculos financieros son exactos línea por línea:
    `subtotal = cantidad * precio_unitario`
    `monto_descuento = subtotal * porcentaje_descuento`
    `base_imponible = subtotal - monto_descuento`
    `igv = base_imponible * 0.18`
    `total = base_imponible + igv`

## Uso Recomendado Académico

- **SQL Server**: Puedes importar los archivos `MARFARMA_CLIENTES`, `PRODUCTOS`, `VENDEDORES`, `VENTAS` y `DETALLE_VENTA` usando el Import Wizard o BULK INSERT para probar claves foráneas, procedimientos almacenados, joins y triggers.
- **MongoDB / NoSQL**: Puedes transformar `MARFARMA_VENTAS_65000.csv` a formato JSON e importarlo en MongoDB usando `mongoimport` para simular un almacenamiento de documentos incrustados.
- **ETL y Data Warehouse**: Utiliza la tabla transaccional para cargar un modelo estrella (FactVentas, DimCliente, DimProducto, etc.) mediante SQL Server Integration Services (SSIS).
- **Power BI / BI**: Conecta Power BI a los CSV normalizados para crear KPIs como Ticket Promedio, Ventas por Vendedor y Distribución por Distrito.
- **PySpark / Big Data**: Carga el archivo denormalizado `MARFARMA_VENTAS_65000.csv` en un clúster local o de la nube usando `spark.read.csv()` para demostrar procesamiento de agregaciones (`groupBy()`, `agg()`) y transformaciones con Spark SQL.

## ¿Cómo Regenerar los Datos?
Si necesitas modificar el volumen o el período de tiempo, ejecuta el script en Python localizado en `/scripts/generar_datos_marfama.py`:

```bash
uv run --with pandas --with numpy --with faker python generar_datos_marfama.py
```

Al finalizar la ejecución, se generará de forma automática el reporte en `/validacion/REPORTE_CALIDAD_MARFARMA.txt` verificando que todas las reglas descritas anteriormente se han cumplido sin errores.
