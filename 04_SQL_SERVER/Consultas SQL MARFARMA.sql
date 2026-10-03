USE MARFARMA_DB;
GO

-- =================================================================
-- BLOQUE 1: EXISTENCIA DE TABLAS Y OBJETOS DEL ESQUEMA
-- =================================================================

-- 1.1 Existencia de tablas transaccionales y staging
SELECT 
    name AS Tabla, 
    type_desc AS Tipo, 
    create_date AS FechaCreacion
FROM sys.tables
WHERE name IN (
    'CLIENTES', 'PRODUCTOS', 'VENDEDORES', 'VENTAS', 'DETALLE_VENTA',
    'STG_CLIENTES', 'STG_PRODUCTOS', 'STG_VENDEDORES', 'STG_VENTAS', 'STG_DETALLE_VENTA',
    'AUDITORIA_VENTAS'
)
ORDER BY name;

-- 1.2 Llaves primarias y foráneas configuradas
SELECT 
    fk.name AS ForeignKey,
    tp.name AS TablaHija,
    cp.name AS ColumnaHija,
    tr.name AS TablaPadre,
    cr.name AS ColumnaPadre
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
INNER JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id;

-- 1.3 Restricciones CHECK
SELECT 
    t.name AS Tabla,
    chk.name AS ConstraintName,
    chk.definition AS DefinicionCheck
FROM sys.check_constraints chk
INNER JOIN sys.tables t ON chk.parent_object_id = t.object_id;


-- =================================================================
-- BLOQUE 2: VOLUMEN DE DATOS Y CONCILIACIÓN STAGING VS FINAL
-- =================================================================

-- 2.1 Conteo general de tablas staging
SELECT 'STG_CLIENTES' AS Tabla, COUNT(*) AS TotalRegistros FROM STG_CLIENTES
UNION ALL
SELECT 'STG_PRODUCTOS', COUNT(*) FROM STG_PRODUCTOS
UNION ALL
SELECT 'STG_VENDEDORES', COUNT(*) FROM STG_VENDEDORES
UNION ALL
SELECT 'STG_VENTAS', COUNT(*) FROM STG_VENTAS
UNION ALL
SELECT 'STG_DETALLE_VENTA', COUNT(*) FROM STG_DETALLE_VENTA;

-- 2.2 Conteo general de tablas finales transaccionales
SELECT 'CLIENTES' AS Tabla, COUNT(*) AS TotalRegistros FROM CLIENTES
UNION ALL
SELECT 'PRODUCTOS', COUNT(*) FROM PRODUCTOS
UNION ALL
SELECT 'VENDEDORES', COUNT(*) FROM VENDEDORES
UNION ALL
SELECT 'VENTAS', COUNT(*) FROM VENTAS
UNION ALL
SELECT 'DETALLE_VENTA', COUNT(*) FROM DETALLE_VENTA;

-- 2.3 IDs no vacíos de staging que aún no existen en las tablas finales.
SELECT 'CLIENTES' AS Entidad, COUNT_BIG(*) AS Registros_No_Migrados
FROM (SELECT DISTINCT id_cliente FROM STG_CLIENTES WHERE NULLIF(LTRIM(RTRIM(id_cliente)), '') IS NOT NULL) s
WHERE NOT EXISTS (SELECT 1 FROM CLIENTES f WHERE f.id_cliente = s.id_cliente)
UNION ALL
SELECT 'PRODUCTOS', COUNT_BIG(*)
FROM (SELECT DISTINCT id_producto FROM STG_PRODUCTOS WHERE NULLIF(LTRIM(RTRIM(id_producto)), '') IS NOT NULL) s
WHERE NOT EXISTS (SELECT 1 FROM PRODUCTOS f WHERE f.id_producto = s.id_producto)
UNION ALL
SELECT 'VENDEDORES', COUNT_BIG(*)
FROM (SELECT DISTINCT id_vendedor FROM STG_VENDEDORES WHERE NULLIF(LTRIM(RTRIM(id_vendedor)), '') IS NOT NULL) s
WHERE NOT EXISTS (SELECT 1 FROM VENDEDORES f WHERE f.id_vendedor = s.id_vendedor)
UNION ALL
SELECT 'VENTAS', COUNT_BIG(*)
FROM (SELECT DISTINCT id_venta FROM STG_VENTAS WHERE NULLIF(LTRIM(RTRIM(id_venta)), '') IS NOT NULL) s
WHERE NOT EXISTS (SELECT 1 FROM VENTAS f WHERE f.id_venta = s.id_venta)
UNION ALL
SELECT 'DETALLE_VENTA', COUNT_BIG(*)
FROM (SELECT DISTINCT id_detalle FROM STG_DETALLE_VENTA WHERE NULLIF(LTRIM(RTRIM(id_detalle)), '') IS NOT NULL) s
WHERE NOT EXISTS (SELECT 1 FROM DETALLE_VENTA f WHERE f.id_detalle = s.id_detalle);

-- 2.4 Identificar duplicados en Staging (que impidieron inserción por WHERE NOT IN)
SELECT 'STG_CLIENTES' AS Tabla, id_cliente AS ID_Duplicado, COUNT(*) AS Veces FROM STG_CLIENTES WHERE id_cliente IS NOT NULL GROUP BY id_cliente HAVING COUNT(*) > 1
UNION ALL
SELECT 'STG_PRODUCTOS', id_producto, COUNT(*) FROM STG_PRODUCTOS WHERE id_producto IS NOT NULL GROUP BY id_producto HAVING COUNT(*) > 1
UNION ALL
SELECT 'STG_VENDEDORES', id_vendedor, COUNT(*) FROM STG_VENDEDORES WHERE id_vendedor IS NOT NULL GROUP BY id_vendedor HAVING COUNT(*) > 1
UNION ALL
SELECT 'STG_VENTAS', id_venta, COUNT(*) FROM STG_VENTAS WHERE id_venta IS NOT NULL GROUP BY id_venta HAVING COUNT(*) > 1
UNION ALL
SELECT 'STG_DETALLE_VENTA', id_detalle, COUNT(*) FROM STG_DETALLE_VENTA WHERE id_detalle IS NOT NULL GROUP BY id_detalle HAVING COUNT(*) > 1;


-- =================================================================
-- BLOQUE 3: INTEGRIDAD REFERENCIAL Y DATOS HUÉRFANOS
-- =================================================================

-- 3.1 Ventas que apuntan a Clientes inexistentes
SELECT v.id_venta, v.id_cliente 
FROM VENTAS v
LEFT JOIN CLIENTES c ON v.id_cliente = c.id_cliente
WHERE c.id_cliente IS NULL AND v.id_cliente IS NOT NULL;

-- 3.2 Ventas que apuntan a Vendedores inexistentes
SELECT v.id_venta, v.id_vendedor 
FROM VENTAS v
LEFT JOIN VENDEDORES ven ON v.id_vendedor = ven.id_vendedor
WHERE ven.id_vendedor IS NULL AND v.id_vendedor IS NOT NULL;

-- 3.3 Detalles de venta huérfanos (sin cabecera o sin producto)
SELECT dv.id_detalle, dv.id_venta 
FROM DETALLE_VENTA dv
LEFT JOIN VENTAS v ON dv.id_venta = v.id_venta
WHERE v.id_venta IS NULL;

SELECT dv.id_detalle, dv.id_producto 
FROM DETALLE_VENTA dv
LEFT JOIN PRODUCTOS p ON dv.id_producto = p.id_producto
WHERE p.id_producto IS NULL;


-- =================================================================
-- BLOQUE 4: VALIDACIÓN FINANCIERA Y FUNCIÓN UDF
-- =================================================================

-- 4.1 Prueba directa de la función escalar dbo.fn_CalcularIGV
SELECT dbo.fn_CalcularIGV(100.00) AS IGV_Esperado_18;

-- 4.2 Verificar cálculo de Subtotal: ((cantidad * precio_unitario) - descuento)
SELECT TOP 10 
    id_detalle, cantidad, precio_unitario, descuento,
    subtotal AS Subtotal_Guardado,
    ((cantidad * precio_unitario) - descuento) AS Subtotal_Calculado,
    ABS(subtotal - ((cantidad * precio_unitario) - descuento)) AS Diferencia
FROM DETALLE_VENTA
WHERE ABS(subtotal - ((cantidad * precio_unitario) - descuento)) > 0.01;

-- 4.3 Comprobar si el IGV guardado coincide con la UDF fn_CalcularIGV
SELECT TOP 10
    id_detalle, subtotal,
    igv AS IGV_Guardado,
    dbo.fn_CalcularIGV(subtotal) AS IGV_Funcion,
    ABS(igv - dbo.fn_CalcularIGV(subtotal)) AS Diferencia
FROM DETALLE_VENTA
WHERE ABS(igv - dbo.fn_CalcularIGV(subtotal)) > 0.01;

-- 4.4 Comprobar si Total = Subtotal + IGV
SELECT TOP 10
    id_detalle, subtotal, igv,
    total AS Total_Guardado,
    (subtotal + igv) AS Total_Calculado
FROM DETALLE_VENTA
WHERE ABS(total - (subtotal + igv)) > 0.01;


-- =================================================================
-- BLOQUE 5: PROCEDIMIENTOS, VISTAS, CURSORES Y TRIGGERS
-- =================================================================

-- 5.1 Estado de Triggers
SELECT name AS TriggerName, parent_class_desc, is_disabled 
FROM sys.triggers 
WHERE name IN ('trg_AuditoriaVentas', 'trg_IntegridadProductos');

-- 5.2 Estado de Procedimientos Almacenados
SELECT name AS StoredProcedure, create_date 
FROM sys.procedures 
WHERE name IN ('sp_RegistrarVenta', 'sp_ReporteVentasPorPeriodo', 'sp_CursorAcademico_AumentoPrecios');

-- 5.3 Probar Vista de Resumen de Ventas
SELECT TOP 10 * FROM vw_ResumenVentas;

-- 5.4 Probar sp_ReporteVentasPorPeriodo
DECLARE @minFecha DATE = (SELECT MIN(fecha) FROM VENTAS);
DECLARE @maxFecha DATE = (SELECT MAX(fecha) FROM VENTAS);
EXEC sp_ReporteVentasPorPeriodo @fecha_inicio = @minFecha, @fecha_fin = @maxFecha;

-- 5.5 Prueba del cursor dentro de una transacción que siempre se revierte.
BEGIN TRY
    BEGIN TRANSACTION;

    SELECT TOP (3) id_producto, nombre_producto, precio_unitario AS Precio_Antes
    FROM PRODUCTOS
    WHERE categoria = 'Medicamentos'
    ORDER BY id_producto;

    EXEC dbo.sp_CursorAcademico_AumentoPrecios;

    SELECT TOP (3) id_producto, nombre_producto, precio_unitario AS Precio_Despues_Aumento_5Pct
    FROM PRODUCTOS
    WHERE categoria = 'Medicamentos'
    ORDER BY id_producto;

    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;

-- 5.6 Probar Trigger de Integridad (trg_IntegridadProductos: debe bloquear el delete)
BEGIN TRY
    DECLARE @prod_con_venta VARCHAR(50) =
        (SELECT TOP (1) id_producto FROM DETALLE_VENTA ORDER BY id_producto);
    IF @prod_con_venta IS NULL
        PRINT 'PRUEBA OMITIDA: no hay productos asociados a detalles de venta.';
    ELSE
    BEGIN
        DELETE FROM PRODUCTOS WHERE id_producto = @prod_con_venta;
        PRINT 'ALERTA: la eliminación no fue bloqueada.';
    END;
END TRY
BEGIN CATCH
    IF ERROR_MESSAGE() = 'No se puede eliminar un producto con ventas asociadas.'
        PRINT 'CORRECTO: el trigger trg_IntegridadProductos bloqueó la eliminación.';
    ELSE
        PRINT 'La eliminación falló, pero no se confirmó que fuera por el trigger.';
    PRINT 'Error capturado: ' + ERROR_MESSAGE();
END CATCH;

-- 5.7 Prueba transaccional de registro y auditoría. Los cambios se revierten.
DECLARE @cli VARCHAR(50) = (SELECT TOP (1) id_cliente FROM CLIENTES ORDER BY id_cliente);
DECLARE @vend VARCHAR(50) = (SELECT TOP (1) id_vendedor FROM VENDEDORES ORDER BY id_vendedor);
DECLARE @prod VARCHAR(50) = (SELECT TOP (1) id_producto FROM PRODUCTOS ORDER BY id_producto);
DECLARE @precio DECIMAL(10,2) = (SELECT precio_unitario FROM PRODUCTOS WHERE id_producto = @prod);
DECLARE @id_venta_test VARCHAR(50) = CONCAT('TEST_', CONVERT(VARCHAR(36), NEWID()));

IF @cli IS NOT NULL AND @vend IS NOT NULL AND @prod IS NOT NULL AND @precio IS NOT NULL
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        EXEC dbo.sp_RegistrarVenta
            @id_venta = @id_venta_test,
            @id_cliente = @cli,
            @id_vendedor = @vend,
            @metodo_pago = 'Efectivo',
            @tipo_cliente = 'Regular',
            @id_producto = @prod,
            @cantidad = 2,
            @precio_unitario = @precio,
            @descuento = 0.00;

        UPDATE VENTAS SET metodo_pago = 'Tarjeta' WHERE id_venta = @id_venta_test;
        DELETE FROM DETALLE_VENTA WHERE id_venta = @id_venta_test;
        DELETE FROM VENTAS WHERE id_venta = @id_venta_test;

        SELECT id_venta, accion, usuario, fecha_auditoria, detalle_cambio
        FROM AUDITORIA_VENTAS
        WHERE id_venta = @id_venta_test
        ORDER BY id_auditoria;

        ROLLBACK TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
ELSE
    PRINT 'Prueba omitida: se necesitan clientes, vendedores y productos con precio válido.';


-- =================================================================
-- BLOQUE 6: ÍNDICES Y OPTIMIZACIÓN
-- =================================================================

-- 6.1 Validar existencia de índices no agrupados creados
SELECT 
    t.name AS Tabla,
    i.name AS Indice,
    i.type_desc AS TipoIndice
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name IN ('IDX_Ventas_Fecha', 'IDX_Detalle_Producto', 'IDX_Clientes_Distrito');

-- 6.2 Detalle de columnas indexadas y columnas INCLUDE
SELECT 
    t.name AS Tabla,
    i.name AS Indice,
    c.name AS Columna,
    ic.is_included_column AS EsColumnaInclude
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name IN ('IDX_Ventas_Fecha', 'IDX_Detalle_Producto', 'IDX_Clientes_Distrito')
ORDER BY t.name, i.name;


-- =================================================================
-- BLOQUE 7: SEGURIDAD, ROLES Y PRIVILEGIOS (Ley 29733)
-- =================================================================

-- 7.1 Miembros de cada rol creado
SELECT 
    r.name AS Rol,
    m.name AS Miembro
FROM sys.database_role_members rm
JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
WHERE r.name IN ('ADMIN', 'AUDITOR', 'ANALISTA', 'CAJERO', 'FARMACEUTICO', 'ALMACEN', 'SUPERVISOR')
ORDER BY r.name;

-- 7.2 Permisos GRANT / DENY por cada rol o usuario
SELECT 
    pr.name AS Entidad,
    pe.permission_name AS Permiso,
    pe.state_desc AS EstadoPermiso,
    COALESCE(o.name, 'DATABASE') AS Objeto
FROM sys.database_permissions pe
JOIN sys.database_principals pr ON pe.grantee_principal_id = pr.principal_id
LEFT JOIN sys.objects o ON pe.major_id = o.object_id
WHERE pr.name IN ('ADMIN', 'AUDITOR', 'ANALISTA', 'CAJERO', 'usr_admin', 'usr_auditor', 'usr_analista', 'usr_cajero')
ORDER BY pr.name, pe.permission_name;

-- 7.3 Simulación de privilegios: usr_cajero
DECLARE @suplantando_cajero BIT = 0;
BEGIN TRY
    EXECUTE AS USER = 'usr_cajero';
    SET @suplantando_cajero = 1;
    SELECT TOP (1) id_producto, nombre_producto, precio_unitario FROM PRODUCTOS; -- Permitido
    REVERT;
    SET @suplantando_cajero = 0;
END TRY
BEGIN CATCH
    IF @suplantando_cajero = 1 REVERT;
    THROW;
END CATCH;

-- 7.4 Simulación de privilegios: usr_auditor
DECLARE @suplantando_auditor BIT = 0;
BEGIN TRY
    EXECUTE AS USER = 'usr_auditor';
    SET @suplantando_auditor = 1;
    SELECT TOP (1) * FROM AUDITORIA_VENTAS; -- Permitido (SELECT)
    REVERT;
    SET @suplantando_auditor = 0;
END TRY
BEGIN CATCH
    IF @suplantando_auditor = 1 REVERT;
    THROW;
END CATCH;
