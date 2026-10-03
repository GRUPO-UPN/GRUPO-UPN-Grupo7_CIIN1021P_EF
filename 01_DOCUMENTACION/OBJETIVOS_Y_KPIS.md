# OBJETIVO SMART, ESTRATEGIAS Y KPIs - MARFARMA

## Objetivo SMART
**"Incrementar las ventas en 20% al finalizar 2026 respecto de las ventas totales obtenidas en el año 2025."**
- **Específico:** Incrementar ventas.
- **Medible:** 20% de crecimiento porcentual en facturación.
- **Alcanzable:** Con la apertura de campañas y nuevos laboratorios, es una meta realista.
- **Relevante:** Aumenta la rentabilidad del negocio principal de la Botica MARFARMA.
- **Temporal:** Al finalizar el año 2026.

*(Línea base: Se utilizarán las ventas acumuladas de Enero a Diciembre 2025, comparadas contra el proyectado/acumulado de 2026).*

## KPIs Identificados

| KPI | Fórmula | Objetivo | Frecuencia |
|---|---|---|---|
| **Ventas Totales** | `SUM(FactVentas.Total)` | Medir el volumen de ingreso bruto monetario. | Mensual |
| **Ticket Promedio** | `SUM(Total) / COUNT(DISTINCT id_venta)` | Conocer cuánto gasta un cliente en promedio por compra. | Mensual |
| **Crecimiento (%)** | `((Ventas Actual - Ventas Anterior) / Ventas Anterior) * 100` | Verificar si estamos en camino a lograr el 20% meta SMART. | Trimestral |
| **Top 10 Productos** | `Top 10 SUM(Total) agrupar por NombreProducto` | Identificar productos estrella para mejorar inventario. | Semanal |

## Estrategias Derivadas
1. **Fidelización:** Dado que podremos medir ventas por distrito y rango de edad, podemos lanzar campañas dirigidas a clientes frecuentes.
2. **Impulso de Ticket:** Si el Ticket Promedio es bajo, los vendedores (medidos por el KPI Ventas por Vendedor) pueden ofrecer vitaminas o artículos de cuidado personal de bajo costo en el punto de caja.
