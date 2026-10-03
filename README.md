# MARFARMA EF - Proyecto Integral Universitario

![SQL Server](https://img.shields.io/badge/SQL%20Server-2019%2B-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-Database%20Engine-0078D4?style=for-the-badge)
![Modelado](https://img.shields.io/badge/Architecture-Kimball%20Star%20Schema-green?style=for-the-badge)
![Compliance](https://img.shields.io/badge/Compliance-Ley%20N.%C2%BA%2029733%20(Per%C3%BA)-blue?style=for-the-badge)

---

Bienvenido al proyecto universitario integral **MARFARMA_EF**. Este proyecto articula conceptos avanzados de bases de datos relacionales, automatización con T-SQL, NoSQL, Data Warehousing, BI y Big Data (Apache Spark) a través de un pipeline automatizado, basado en el caso de estudio de la botica MARFARMA.

## Estructura del Proyecto

```text
Grupo7_CIIN1021P_EF/
├── 01_DOCUMENTACION/        # Planes, políticas, guías y matriz de cumplimiento
├── 02_DIAGRAMAS/            # Modelos conceptuales y lógicos en Mermaid
├── 03_DATASET/              # Datos crudos y documentación del origen (CSVs)
├── 04_SQL_SERVER/           # Scripts DDL y DML, Procedimientos y Automatización (T-SQL)
├── 05_MONGODB/              # Script de colecciones y operaciones CRUD
├── 06_ETL/                  # Código Python (pandas/sqlalchemy) para carga de DW
├── 07_DATA_WAREHOUSE/       # Modelo dimensional y consultas OLAP
├── 08_POWER_BI/             # Guía para el Dashboard BI
├── 09_BIG_DATA/             # Notebooks de PySpark, resultados agregados y gráficos
├── 10_BACKUPS/              # Copias de seguridad (.bak)
```

## Prerrequisitos
- **SQL Server 2019+** y utilidad `sqlcmd`.
- **Python 3.10+** (con `pandas`, `sqlalchemy`, `pyodbc`, `matplotlib`, `nbformat`, `pyspark`).
- **Java 11/17** (requerido para ejecutar Apache Spark localmente).
- **MongoDB** y utilidad `mongosh`.
- **Power BI Desktop** (para abrir/construir el dashboard).

## Secuencia de Ejecución desde Cero
1. **Paso 1: Entorno de Datos (Fase 3-6)**
   Ejecutar mediante `sqlcmd` o SSMS los archivos de `04_SQL_SERVER/` en este orden: 
   - `MARFARMA_COMPLETO_P1.sql` (Esquema)
   - `MARFARMA_COMPLETO_P2.sql` (Carga BULK)
   - `MARFARMA_COMPLETO_P3.sql` (Automatización T-SQL)
2. **Paso 2: Backups (Fase 7)**
   Ejecutar las instrucciones en `01_DOCUMENTACION/POLITICA_BACKUP.md`.
3. **Paso 3: NoSQL (Fase 8)**
   Ejecutar en consola: `mongosh -f 05_MONGODB/operaciones_crud.js`.
4. **Paso 4: Data Warehouse (Fase 10)**
   Ejecutar en SSMS: `07_DATA_WAREHOUSE/DDL_MARFARMA_DW.sql`.
5. **Paso 5: ETL (Fase 9)**
   Ejecutar en consola: `python 06_ETL/ETL_MARFARMA.py`.
6. **Paso 6: Big Data (Fase 14-15)**
   - Si se cuenta con Java configurado, abrir `MARFARMA_PySpark.ipynb` en Jupyter Notebook y ejecutar.
   - Alternativa para generación de gráficos: `python 09_BIG_DATA/fallback_pandas_graficos.py`.

**GRUPO 7:**
1. Aguilar Cruz, Alex Gustavo
2. Fernandez Vigo Sergio Esteban
3. Ishpilco Quispe, Esau
4. Malca Chilon, Antony                                                                                     
5. Vasquez Valdez Jaime Farid

