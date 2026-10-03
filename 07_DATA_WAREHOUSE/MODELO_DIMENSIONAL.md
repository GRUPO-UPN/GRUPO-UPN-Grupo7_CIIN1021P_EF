# MODELO DIMENSIONAL - MARFARMA DW

## 1. Esquema Estrella (Star Schema)
El esquema estrella fue el implementado físicamente en la base de datos `MARFARMA_DW`. Consiste en una tabla de hechos central `FactVentas` rodeada por tablas de dimensiones desnormalizadas, lo cual optimiza la velocidad de las consultas analíticas reduciendo el número de JOINs requeridos.

```mermaid
erDiagram
    FactVentas {
        int FactKey PK
        int DateKey FK
        int ClienteKey FK
        int VendedorKey FK
        int ProductoKey FK
        string MetodoPago
        int Cantidad
        float PrecioUnitario
        float Subtotal
        float Descuento
        float IGV
        float Total
    }

    DimTiempo {
        int DateKey PK
        date Fecha
        int Dia
        int Mes
        int Anio
        string NombreMes
        int Trimestre
    }

    DimCliente {
        int ClienteKey PK
        string id_cliente
        string NombreCompleto
        string Sexo
        string EdadRango
        string Distrito
        string TipoCliente
    }

    DimVendedor {
        int VendedorKey PK
        string id_vendedor
        string NombreVendedor
        string Turno
    }

    DimProducto {
        int ProductoKey PK
        string id_producto
        string NombreProducto
        string Categoria
        string Laboratorio
    }

    FactVentas }o--|| DimTiempo : "Ocurre en"
    FactVentas }o--|| DimCliente : "Comprado por"
    FactVentas }o--|| DimVendedor : "Vendido por"
    FactVentas }o--|| DimProducto : "Incluye"
```

## 2. Esquema Copo de Nieve (Snowflake Schema)
Es una variante más normalizada del esquema estrella. En este modelo, las dimensiones con jerarquías (como Producto -> Categoría/Laboratorio o Cliente -> Ubicación) se separan en múltiples tablas afines.

```mermaid
erDiagram
    FactVentas }o--|| DimProducto : "Incluye"
    DimProducto }o--|| DimCategoria : "Pertenece"
    DimProducto }o--|| DimLaboratorio : "Fabricado por"

    DimProducto {
        int ProductoKey PK
        string NombreProducto
        int CategoriaKey FK
        int LaboratorioKey FK
    }

    DimCategoria {
        int CategoriaKey PK
        string NombreCategoria
    }
    
    DimLaboratorio {
        int LaboratorioKey PK
        string NombreLaboratorio
    }
```

## 3. Diferencias y Justificación Metodológica (Kimball vs Inmon)
En este proyecto aplicamos la metodología **Bottom-Up de Ralph Kimball**, que se enfoca en entregar valor rápido mediante la construcción de Data Marts (como nuestro caso de Ventas) utilizando esquemas estrella descentralizados pero con dimensiones conformadas. 
- **Estrella vs Copo de Nieve:** Elegimos el esquema estrella por su mayor rendimiento de lectura en herramientas BI (como Power BI) y simplicidad de diseño. El modelo copo de nieve reduce redundancia de datos (espacio), pero a costa de degradar el rendimiento por el incremento de operaciones JOIN complejas en el motor OLAP.
