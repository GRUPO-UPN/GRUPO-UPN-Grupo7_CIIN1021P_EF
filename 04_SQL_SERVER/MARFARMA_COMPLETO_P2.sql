USE MARFARMA_DB;
GO

-------------------------------------------------------------------
-- CARGA DE TABLAS STAGING
-------------------------------------------------------------------
BULK INSERT STG_PRODUCTOS
FROM 'E:\MARFARMA_EF\03_DATASET\datos\MARFARMA_PRODUCTOS.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT STG_VENDEDORES
FROM 'E:\MARFARMA_EF\03_DATASET\datos\MARFARMA_VENDEDORES.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT STG_VENTAS
FROM 'E:\MARFARMA_EF\03_DATASET\datos\MARFARMA_VENTAS.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT STG_DETALLE_VENTA
FROM 'E:\MARFARMA_EF\03_DATASET\datos\MARFARMA_DETALLE_VENTA.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');
GO

-------------------------------------------------------------------
-- TRANSFORMACIÓN E INSERCIÓN A TABLAS FINALES (Idempotente)
-------------------------------------------------------------------
-- CLIENTES
INSERT INTO CLIENTES (id_cliente, nombre_cliente, apellido_paterno, apellido_materno, sexo, edad, distrito, provincia, departamento, tipo_cliente)
SELECT id_cliente, nombre_cliente, apellido_paterno, apellido_materno, sexo, CAST(edad AS INT), distrito, provincia, departamento, tipo_cliente
FROM STG_CLIENTES
WHERE id_cliente NOT IN (SELECT id_cliente FROM CLIENTES);

-- PRODUCTOS
INSERT INTO PRODUCTOS (id_producto, nombre_producto, categoria, laboratorio, requiere_receta, precio_unitario)
SELECT id_producto, nombre_producto, categoria, laboratorio, requiere_receta, CAST(precio_unitario AS DECIMAL(10,2))
FROM STG_PRODUCTOS
WHERE id_producto NOT IN (SELECT id_producto FROM PRODUCTOS);

-- VENDEDORES
INSERT INTO VENDEDORES (id_vendedor, nombre_vendedor, turno)
SELECT id_vendedor, nombre_vendedor, turno
FROM STG_VENDEDORES
WHERE id_vendedor NOT IN (SELECT id_vendedor FROM VENDEDORES);

-- VENTAS
INSERT INTO VENTAS (id_venta, fecha, hora, id_cliente, id_vendedor, metodo_pago, tipo_cliente, estado_venta)
SELECT id_venta, CAST(fecha AS DATE), CAST(hora AS TIME), id_cliente, id_vendedor, metodo_pago, tipo_cliente, estado_venta
FROM STG_VENTAS
WHERE id_venta NOT IN (SELECT id_venta FROM VENTAS);

-- DETALLE VENTA
INSERT INTO DETALLE_VENTA (id_detalle, id_venta, id_producto, cantidad, precio_unitario, subtotal, descuento, igv, total)
SELECT id_detalle, id_venta, id_producto, CAST(cantidad AS INT), CAST(precio_unitario AS DECIMAL(10,2)), 
       CAST(subtotal AS DECIMAL(10,2)), CAST(descuento AS DECIMAL(10,2)), CAST(igv AS DECIMAL(10,2)), CAST(total AS DECIMAL(10,2))
FROM STG_DETALLE_VENTA
WHERE id_detalle NOT IN (SELECT id_detalle FROM DETALLE_VENTA);

GO
