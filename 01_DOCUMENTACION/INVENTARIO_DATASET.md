# INVENTARIO DEL DATASET - MARFARMA

Este documento detalla los archivos recibidos en el repositorio oficial de MARFARMA y las estructuras encontradas.

### 1. `MARFARMA_CLIENTES.csv`
- **Filas:** 5,000
- **Columnas:** 10 (`id_cliente`, `nombre_cliente`, `apellido_paterno`, `apellido_materno`, `sexo`, `edad`, `distrito`, `provincia`, `departamento`, `tipo_cliente`)

### 2. `MARFARMA_PRODUCTOS.csv`
- **Filas:** 300
- **Columnas:** 6 (`id_producto`, `nombre_producto`, `categoria`, `laboratorio`, `requiere_receta`, `precio_unitario`)

### 3. `MARFARMA_VENDEDORES.csv`
- **Filas:** 30
- **Columnas:** 3 (`id_vendedor`, `nombre_vendedor`, `turno`)

### 4. `MARFARMA_VENTAS.csv`
- **Filas:** 65,000
- **Columnas:** 8 (`id_venta`, `fecha`, `hora`, `id_cliente`, `id_vendedor`, `metodo_pago`, `tipo_cliente`, `estado_venta`)

### 5. `MARFARMA_DETALLE_VENTA.csv`
- **Filas:** 104,229
- **Columnas:** 9 (`id_detalle`, `id_venta`, `id_producto`, `cantidad`, `precio_unitario`, `subtotal`, `descuento`, `igv`, `total`)

### 6. `MARFARMA_VENTAS_65000.csv`
- **Filas:** 104,229
- **Columnas:** 25 (Vista desnormalizada con todos los campos de ventas, detalles, productos, clientes y vendedores).

### Notas:
- `MARFARMA_RESUMEN_ESTADISTICO.csv` se encuentra presente pero tiene un formato malformado (irregular en columnas) que requiere parsing especial si se fuera a usar.
