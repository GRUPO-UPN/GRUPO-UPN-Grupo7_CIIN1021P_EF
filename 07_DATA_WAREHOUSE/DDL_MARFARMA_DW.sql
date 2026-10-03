USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'MARFARMA_DW')
BEGIN
    ALTER DATABASE MARFARMA_DW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MARFARMA_DW;
END
GO

CREATE DATABASE MARFARMA_DW;
GO

USE MARFARMA_DW;
GO

-- DIMENSIÓN TIEMPO
CREATE TABLE DimTiempo (
    DateKey INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Dia INT,
    Mes INT,
    Anio INT,
    NombreMes VARCHAR(20),
    Trimestre INT
);

-- DIMENSIÓN CLIENTE
CREATE TABLE DimCliente (
    ClienteKey INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente VARCHAR(50) NOT NULL,
    NombreCompleto VARCHAR(200),
    Sexo VARCHAR(20),
    EdadRango VARCHAR(50),
    Distrito VARCHAR(100),
    TipoCliente VARCHAR(50)
);

-- DIMENSIÓN VENDEDOR
CREATE TABLE DimVendedor (
    VendedorKey INT IDENTITY(1,1) PRIMARY KEY,
    id_vendedor VARCHAR(50) NOT NULL,
    NombreVendedor VARCHAR(150),
    Turno VARCHAR(50)
);

-- DIMENSIÓN PRODUCTO
CREATE TABLE DimProducto (
    ProductoKey INT IDENTITY(1,1) PRIMARY KEY,
    id_producto VARCHAR(50) NOT NULL,
    NombreProducto VARCHAR(200),
    Categoria VARCHAR(100),
    Laboratorio VARCHAR(100)
);

-- TABLA DE HECHOS (FACT VENTAS)
CREATE TABLE FactVentas (
    FactKey INT IDENTITY(1,1) PRIMARY KEY,
    DateKey INT FOREIGN KEY REFERENCES DimTiempo(DateKey),
    ClienteKey INT FOREIGN KEY REFERENCES DimCliente(ClienteKey),
    VendedorKey INT FOREIGN KEY REFERENCES DimVendedor(VendedorKey),
    ProductoKey INT FOREIGN KEY REFERENCES DimProducto(ProductoKey),
    MetodoPago VARCHAR(50),
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    Subtotal DECIMAL(10,2),
    Descuento DECIMAL(10,2),
    IGV DECIMAL(10,2),
    Total DECIMAL(10,2)
);
GO
