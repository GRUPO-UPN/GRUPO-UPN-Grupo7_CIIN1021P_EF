USE MARFARMA_DW;
GO

-- 1. ROLL-UP (Agregando de Día -> Mes -> Año)
SELECT t.Anio, t.Mes, SUM(f.Total) AS TotalVentas
FROM FactVentas f
JOIN DimTiempo t ON f.DateKey = t.DateKey
GROUP BY t.Anio, t.Mes
ORDER BY t.Anio, t.Mes;

-- 2. DRILL-DOWN (Detallando de Año -> Trimestre -> Mes)
SELECT t.Anio, t.Trimestre, t.Mes, p.Categoria, SUM(f.Total) AS TotalVentas
FROM FactVentas f
JOIN DimTiempo t ON f.DateKey = t.DateKey
JOIN DimProducto p ON f.ProductoKey = p.ProductoKey
WHERE t.Anio = 2025
GROUP BY t.Anio, t.Trimestre, t.Mes, p.Categoria
ORDER BY t.Trimestre, t.Mes;

-- 3. SLICE (Filtrando por UNA dimensión: Solo Ventas de 'Medicamentos')
SELECT t.Anio, t.Mes, SUM(f.Total) AS TotalVentas
FROM FactVentas f
JOIN DimTiempo t ON f.DateKey = t.DateKey
JOIN DimProducto p ON f.ProductoKey = p.ProductoKey
WHERE p.Categoria = 'Medicamentos'
GROUP BY t.Anio, t.Mes
ORDER BY t.Anio, t.Mes;

-- 4. DICE (Filtrando por VARIAS dimensiones: 'Medicamentos' vendidos a 'Adulto Mayor' en 'Efectivo')
SELECT t.Anio, c.EdadRango, p.Categoria, f.MetodoPago, SUM(f.Total) AS TotalVentas
FROM FactVentas f
JOIN DimTiempo t ON f.DateKey = t.DateKey
JOIN DimProducto p ON f.ProductoKey = p.ProductoKey
JOIN DimCliente c ON f.ClienteKey = c.ClienteKey
WHERE p.Categoria = 'Medicamentos' 
  AND c.EdadRango = 'Adulto Mayor'
  AND f.MetodoPago = 'Efectivo'
GROUP BY t.Anio, c.EdadRango, p.Categoria, f.MetodoPago;
GO
