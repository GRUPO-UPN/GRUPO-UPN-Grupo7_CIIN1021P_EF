# MATRIZ DE CUMPLIMIENTO - MARFARMA_EF

| Requisito / Fase | Implementación (Archivo/Carpeta) | Estado de Prueba | Observaciones |
|---|---|---|---|
| 1. Auditoría Dataset | `01_DOCUMENTACION/REPORTE_CALIDAD_DATOS.md` | ✔️ Completado | Ningún dato nulo o anómalo hallado. |
| 2. Diseño E-R (5D) | `02_DIAGRAMAS/DISEÑO_TRANSACCIONAL.md` | ✔️ Completado | Modelo 3FN sobre 5 entidades core. |
| 3. SQL Server & Carga | `04_SQL_SERVER/MARFARMA_COMPLETO_P1 y P2` | ✔️ Completado | Carga exitosa de 65,000 ventas. |
| 4. Automatización T-SQL | `04_SQL_SERVER/MARFARMA_COMPLETO_P3.sql` | ✔️ Completado | Contiene TRY CATCH, Transacciones y Cursor. |
| 5. Triggers & UDF | `04_SQL_SERVER/MARFARMA_COMPLETO_P3.sql` | ✔️ Completado | Auditoría (DML) e Integridad Referencial. |
| 6. Índices y Seguridad | `04_SQL_SERVER/MARFARMA_COMPLETO_P3.sql` | ✔️ Completado | 3 roles + 4 adicionales, Ley N. 29733. |
| 7. Backups | `01_DOCUMENTACION/POLITICA_BACKUP.md` | ✔️ Completado | Full + Diff generados en disco. |
| 8. MongoDB | `05_MONGODB/operaciones_crud.js` | ✔️ Completado | CRUD verificado mediante mongosh. |
| 9. ETL | `06_ETL/ETL_MARFARMA.py` | ✔️ Completado | Transformación e ingesta validada en SQL. |
| 10. Data Warehouse | `07_DATA_WAREHOUSE/DDL_MARFARMA_DW.sql` | ✔️ Completado | Kimball (Bottom-up) aplicado. |
| 11. KPI y SMART | `01_DOCUMENTACION/OBJETIVOS_Y_KPIS.md` | ✔️ Completado | Definidos para 2026 vs 2025 (+20%). |
| 12. OLAP | `07_DATA_WAREHOUSE/OLAP_Queries.sql` | ✔️ Completado | Roll-up, Drill-down, Slice, Dice. |
| 13. Dashboard BI | `08_POWER_BI/INSTRUCCIONES_DASHBOARD.md` | ⚠️ Guía generada | Creación manual requerida en Desktop. |
| 14. PySpark Notebook | `09_BIG_DATA/MARFARMA_PySpark.ipynb` | ✔️ Generado | Fallback Pandas ejecutado (Java dependency). |
| 15. Dashboard Big Data | `09_BIG_DATA/graficos/*.png` | ✔️ Completado | 4 gráficos generados automáticamente. |
