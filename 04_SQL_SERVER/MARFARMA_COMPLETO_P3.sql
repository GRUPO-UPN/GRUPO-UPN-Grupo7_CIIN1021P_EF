USE MARFARMA_DB;
GO

-------------------------------------------------------------------
-- FASE 4: AUTOMATIZACIÓN CON T-SQL
-------------------------------------------------------------------

-- 1. TABLA DE AUDITORÍA
CREATE TABLE AUDITORIA_VENTAS (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_venta VARCHAR(50),
    accion VARCHAR(50),
    usuario VARCHAR(100),
    fecha_auditoria DATETIME DEFAULT GETDATE(),
    detalle_cambio VARCHAR(255)
);
GO

-- 2. TRIGGERS
-- Trigger de Auditoría
CREATE TRIGGER trg_AuditoriaVentas
ON VENTAS
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO AUDITORIA_VENTAS (id_venta, accion, usuario, detalle_cambio)
        SELECT id_venta, 'INSERT', SYSTEM_USER, 'Venta Registrada' FROM inserted;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO AUDITORIA_VENTAS (id_venta, accion, usuario, detalle_cambio)
        SELECT id_venta, 'UPDATE', SYSTEM_USER, 'Venta Modificada' FROM inserted;
    END

    IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO AUDITORIA_VENTAS (id_venta, accion, usuario, detalle_cambio)
        SELECT id_venta, 'DELETE', SYSTEM_USER, 'Venta Eliminada' FROM deleted;
    END
END;
GO

-- Trigger de Integridad (Evitar que se eliminen productos si tienen detalle de venta)
CREATE TRIGGER trg_IntegridadProductos
ON PRODUCTOS
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM DETALLE_VENTA dv INNER JOIN deleted d ON dv.id_producto = d.id_producto)
    BEGIN
        RAISERROR('No se puede eliminar un producto con ventas asociadas.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        DELETE FROM PRODUCTOS WHERE id_producto IN (SELECT id_producto FROM deleted);
    END
END;
GO

-- 3. UDF (Función Escalar)
CREATE FUNCTION fn_CalcularIGV (@subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @subtotal * 0.18;
END;
GO

-- 4. PROCEDIMIENTOS ALMACENADOS
-- Registro de Ventas Transaccional con Manejo de Errores
CREATE PROCEDURE sp_RegistrarVenta
    @id_venta VARCHAR(50),
    @id_cliente VARCHAR(50),
    @id_vendedor VARCHAR(50),
    @metodo_pago VARCHAR(50),
    @tipo_cliente VARCHAR(50),
    @id_producto VARCHAR(50),
    @cantidad INT,
    @precio_unitario DECIMAL(10,2),
    @descuento DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Cabecera
        INSERT INTO VENTAS (id_venta, fecha, hora, id_cliente, id_vendedor, metodo_pago, tipo_cliente, estado_venta)
        VALUES (@id_venta, CAST(GETDATE() AS DATE), CAST(GETDATE() AS TIME), @id_cliente, @id_vendedor, @metodo_pago, @tipo_cliente, 'Completada');

        -- Detalle (Usa la UDF para IGV)
        DECLARE @subtotal DECIMAL(10,2) = (@cantidad * @precio_unitario) - @descuento;
        DECLARE @igv DECIMAL(10,2) = dbo.fn_CalcularIGV(@subtotal);
        DECLARE @total DECIMAL(10,2) = @subtotal + @igv;
        DECLARE @id_detalle VARCHAR(50) = NEWID();

        INSERT INTO DETALLE_VENTA (id_detalle, id_venta, id_producto, cantidad, precio_unitario, subtotal, descuento, igv, total)
        VALUES (@id_detalle, @id_venta, @id_producto, @cantidad, @precio_unitario, @subtotal, @descuento, @igv, @total);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

-- SP para Reporte por Períodos
CREATE PROCEDURE sp_ReporteVentasPorPeriodo
    @fecha_inicio DATE,
    @fecha_fin DATE
AS
BEGIN
    SELECT v.fecha, SUM(dv.total) AS total_ventas, COUNT(DISTINCT v.id_venta) AS numero_operaciones
    FROM VENTAS v
    JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
    WHERE v.fecha BETWEEN @fecha_inicio AND @fecha_fin
    GROUP BY v.fecha
    ORDER BY v.fecha;
END;
GO

-- 5. CURSOR ACADÉMICO (Ejemplo de procesamiento fila a fila)
CREATE PROCEDURE sp_CursorAcademico_AumentoPrecios
AS
BEGIN
    DECLARE @id_prod VARCHAR(50);
    DECLARE @precio DECIMAL(10,2);
    
    DECLARE cur_productos CURSOR FOR
    SELECT id_producto, precio_unitario FROM PRODUCTOS WHERE categoria = 'Medicamentos';
    
    OPEN cur_productos;
    FETCH NEXT FROM cur_productos INTO @id_prod, @precio;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Aumento del 5% simulado a nivel fila
        UPDATE PRODUCTOS SET precio_unitario = @precio * 1.05 WHERE id_producto = @id_prod;
        FETCH NEXT FROM cur_productos INTO @id_prod, @precio;
    END;
    
    CLOSE cur_productos;
    DEALLOCATE cur_productos;
END;
GO

-- 6. VISTAS
CREATE VIEW vw_ResumenVentas
AS
SELECT 
    v.fecha,
    c.distrito,
    p.categoria,
    SUM(dv.total) as IngresoTotal,
    SUM(dv.cantidad) as UnidadesVendidas
FROM VENTAS v
JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
JOIN PRODUCTOS p ON dv.id_producto = p.id_producto
JOIN CLIENTES c ON v.id_cliente = c.id_cliente
GROUP BY v.fecha, c.distrito, p.categoria;
GO

-------------------------------------------------------------------
-- FASE 5: ÍNDICES
-------------------------------------------------------------------
-- Índices para optimizar reportes
CREATE NONCLUSTERED INDEX IDX_Ventas_Fecha ON VENTAS(fecha);
CREATE NONCLUSTERED INDEX IDX_Detalle_Producto ON DETALLE_VENTA(id_producto) INCLUDE (total, cantidad);
CREATE NONCLUSTERED INDEX IDX_Clientes_Distrito ON CLIENTES(distrito);
GO

-------------------------------------------------------------------
-- FASE 6: SEGURIDAD Y ROLES (Ley 29733)
-------------------------------------------------------------------

-- Creación de Roles
CREATE ROLE ADMIN;
CREATE ROLE AUDITOR;
CREATE ROLE ANALISTA;
CREATE ROLE CAJERO;
CREATE ROLE FARMACEUTICO;
CREATE ROLE ALMACEN;
CREATE ROLE SUPERVISOR;
GO

-- Asignación de Permisos Principio Menor Privilegio
GRANT CONTROL ON DATABASE::MARFARMA_DB TO ADMIN;

-- Cajero solo puede ejecutar el SP de registrar venta y leer productos
GRANT EXECUTE ON OBJECT::sp_RegistrarVenta TO CAJERO;
GRANT SELECT ON PRODUCTOS TO CAJERO;

-- Analista solo lectura a las vistas
GRANT SELECT ON vw_ResumenVentas TO ANALISTA;
GRANT SELECT ON VENTAS TO ANALISTA;
GRANT SELECT ON DETALLE_VENTA TO ANALISTA;

-- Auditor solo lectura a las tablas de auditoría (Ley 29733 trazabilidad)
GRANT SELECT ON AUDITORIA_VENTAS TO AUDITOR;
DENY INSERT, UPDATE, DELETE ON AUDITORIA_VENTAS TO AUDITOR;

-- Creación de Usuarios de Prueba (sin login para la BD)
CREATE USER usr_admin WITHOUT LOGIN;
CREATE USER usr_auditor WITHOUT LOGIN;
CREATE USER usr_analista WITHOUT LOGIN;
CREATE USER usr_cajero WITHOUT LOGIN;

-- Asignar usuarios a roles
ALTER ROLE ADMIN ADD MEMBER usr_admin;
ALTER ROLE AUDITOR ADD MEMBER usr_auditor;
ALTER ROLE ANALISTA ADD MEMBER usr_analista;
ALTER ROLE CAJERO ADD MEMBER usr_cajero;
GO
