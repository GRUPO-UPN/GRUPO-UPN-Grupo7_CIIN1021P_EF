USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'MARFARMA_DB')
BEGIN
    ALTER DATABASE MARFARMA_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MARFARMA_DB;
END
GO

CREATE DATABASE MARFARMA_DB;
GO

USE MARFARMA_DB;
GO

-------------------------------------------------------------------
-- FASE 3: TABLAS FINALES (Transaccionales)
-------------------------------------------------------------------
CREATE TABLE CLIENTES (
    id_cliente VARCHAR(50) PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    sexo VARCHAR(20),
    edad INT CHECK (edad >= 0),
    distrito VARCHAR(100),
    provincia VARCHAR(100),
    departamento VARCHAR(100),
    tipo_cliente VARCHAR(50)
);

CREATE TABLE PRODUCTOS (
    id_producto VARCHAR(50) PRIMARY KEY,
    nombre_producto VARCHAR(200) NOT NULL,
    categoria VARCHAR(100),
    laboratorio VARCHAR(100),
    requiere_receta VARCHAR(2) DEFAULT 'No',
    precio_unitario DECIMAL(10,2) CHECK (precio_unitario >= 0)
);

CREATE TABLE VENDEDORES (
    id_vendedor VARCHAR(50) PRIMARY KEY,
    nombre_vendedor VARCHAR(150) NOT NULL,
    turno VARCHAR(50)
);

CREATE TABLE VENTAS (
    id_venta VARCHAR(50) PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    id_cliente VARCHAR(50) FOREIGN KEY REFERENCES CLIENTES(id_cliente),
    id_vendedor VARCHAR(50) FOREIGN KEY REFERENCES VENDEDORES(id_vendedor),
    metodo_pago VARCHAR(50),
    tipo_cliente VARCHAR(50),
    estado_venta VARCHAR(50) DEFAULT 'Completada'
);

CREATE TABLE DETALLE_VENTA (
    id_detalle VARCHAR(50) PRIMARY KEY,
    id_venta VARCHAR(50) FOREIGN KEY REFERENCES VENTAS(id_venta),
    id_producto VARCHAR(50) FOREIGN KEY REFERENCES PRODUCTOS(id_producto),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    descuento DECIMAL(10,2) DEFAULT 0 CHECK (descuento >= 0),
    igv DECIMAL(10,2) NOT NULL CHECK (igv >= 0),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0)
);

-------------------------------------------------------------------
-- TABLAS STAGING PARA CARGA MASIVA
-------------------------------------------------------------------
CREATE TABLE STG_CLIENTES (
    id_cliente VARCHAR(50), nombre_cliente VARCHAR(100), apellido_paterno VARCHAR(100), apellido_materno VARCHAR(100),
    sexo VARCHAR(20), edad VARCHAR(10), distrito VARCHAR(100), provincia VARCHAR(100), departamento VARCHAR(100), tipo_cliente VARCHAR(50)
);

CREATE TABLE STG_PRODUCTOS (
    id_producto VARCHAR(50), nombre_producto VARCHAR(200), categoria VARCHAR(100),
    laboratorio VARCHAR(100), requiere_receta VARCHAR(50), precio_unitario VARCHAR(50)
);

CREATE TABLE STG_VENDEDORES (
    id_vendedor VARCHAR(50), nombre_vendedor VARCHAR(150), turno VARCHAR(50)
);

CREATE TABLE STG_VENTAS (
    id_venta VARCHAR(50), fecha VARCHAR(50), hora VARCHAR(50), id_cliente VARCHAR(50),
    id_vendedor VARCHAR(50), metodo_pago VARCHAR(50), tipo_cliente VARCHAR(50), estado_venta VARCHAR(50)
);

CREATE TABLE STG_DETALLE_VENTA (
    id_detalle VARCHAR(50), id_venta VARCHAR(50), id_producto VARCHAR(50), cantidad VARCHAR(50),
    precio_unitario VARCHAR(50), subtotal VARCHAR(50), descuento VARCHAR(50), igv VARCHAR(50), total VARCHAR(50)
);

GO
