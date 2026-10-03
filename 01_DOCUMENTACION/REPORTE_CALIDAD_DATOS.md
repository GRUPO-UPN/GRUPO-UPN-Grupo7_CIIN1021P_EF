# REPORTE DE CALIDAD DE DATOS - MARFARMA

Se realizó una auditoría y perfilamiento técnico de los archivos CSV provistos en el repositorio.

### Resultados Generales
1. **Valores Nulos:** No se detectaron valores nulos (`NULL`, `NaN` o en blanco) en los CSVs principales (`Clientes`, `Productos`, `Vendedores`, `Ventas`, `Detalle Venta`).
2. **Duplicados:** No se detectaron filas completamente duplicadas en ninguna de las entidades.
3. **Restricciones de Valores:**
   - No se encontraron valores negativos en columnas numéricas de precios, cantidades o subtotales.
   - Las fechas de ventas abarcan el rango desde `2024-01-01` hasta `2026-08-31`, con formato válido y consistente.
4. **Coherencia Matemática:**
   - La validación `subtotal = cantidad * precio_unitario` se cumple en toda la tabla `Detalle_Venta` (con diferencias despreciables por precisión de punto flotante de `1.13e-13`).

### Integridad Referencial
Las claves foráneas como `id_cliente` (en Ventas), `id_vendedor` (en Ventas) y `id_producto` (en Detalle Venta) están correctamente vinculadas a sus respectivas dimensiones, sin registros huérfanos aparentes.

### Conclusiones y Transformaciones requeridas
- El dataset tiene un nivel alto de limpieza y consistencia. 
- No es necesario ejecutar eliminación de filas ni descartar datos por mala calidad.
- Se implementará un área de Staging para realizar la carga masiva y prevenir inserciones duplicadas (idempotencia) cuando se despliegue en SQL Server.
