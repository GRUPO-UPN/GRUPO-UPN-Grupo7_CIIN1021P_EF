# PLAN DE IMPLEMENTACIÓN - MARFARMA_EF

Este documento describe la metodología de trabajo por fases para el proyecto universitario MARFARMA_EF, asegurando un desarrollo estructurado y reproducible.

## Fases del Proyecto

1. **Fase 1: Auditoría del Proyecto y Dataset**
   - **Objetivo:** Inspeccionar los datos originales, verificar calidad (nulos, duplicados, coherencia) y establecer la base del proyecto.
   - **Estado:** Completado.

2. **Fase 2: Diseño Transaccional y Diagrama E-R**
   - **Objetivo:** Diseñar la base de datos relacional (5D) basada en las entidades clave (Clientes, Productos, Vendedores, Ventas, etc.).

3. **Fase 3: SQL Server y Carga de Datos**
   - **Objetivo:** Crear la BD `MARFARMA_DB`, tablas staging, y realizar la carga masiva mediante T-SQL.

4. **Fase 4: Automatización con T-SQL**
   - **Objetivo:** Implementar Procedimientos Almacenados, UDFs, Triggers para auditoría y manejar control de excepciones (TRY...CATCH / Transacciones).

5. **Fase 5: Índices y Consultas**
   - **Objetivo:** Optimizar el rendimiento de las consultas clave utilizando índices adecuados.

6. **Fase 6: Seguridad, Roles, Usuarios y Ley 29733**
   - **Objetivo:** Aplicar principios de menor privilegio y controles conforme a la Ley de Protección de Datos Personales.

7. **Fase 7: Política de Backup y Recuperación**
   - **Objetivo:** Diseñar y probar la estrategia de copias de seguridad (Full + Diferencial) y el script de restauración.

8. **Fase 8: MongoDB y NoSQL**
   - **Objetivo:** Explorar un enfoque documental para gestionar los registros semiestructurados en MongoDB.

9. **Fase 9: ETL**
   - **Objetivo:** Procesar los datos de orígenes heterogéneos y prepararlos para el análisis en el Data Warehouse.

10. **Fase 10: Data Warehouse**
    - **Objetivo:** Diseñar esquemas estrella y copo de nieve en `MARFARMA_DW`.

11. **Fase 11: Objetivo SMART, Estrategias y KPIs**
    - **Objetivo:** Establecer métricas claras para incrementar ventas y realizar el análisis de resultados.

12. **Fase 12: OLAP**
    - **Objetivo:** Realizar análisis multidimensional (Drill-down, Roll-up, Slice, Dice).

13. **Fase 13: Dashboard de Business Intelligence**
    - **Objetivo:** Visualizar KPIs orientados a la toma de decisiones empresariales.

14. **Fase 14: Big Data y PySpark**
    - **Objetivo:** Implementar un procesamiento distribuido para grandes volúmenes de datos transaccionales.

15. **Fase 15: Dashboard de Big Data y Gráficos**
    - **Objetivo:** Visualizar análisis derivados de PySpark (Ventas por mes, categorías, top 10 productos).

16. **Fase 16: Integración y Pruebas Finales**
    - **Objetivo:** Verificar y documentar el correcto funcionamiento del flujo completo.

17. **Fase 17: Documentación y Sustentación**
    - **Objetivo:** Preparar la matriz de cumplimiento, evidencias y cuestionarios para la defensa.

El flujo se ejecutará de manera secuencial validando los resultados antes de avanzar a la siguiente etapa.
