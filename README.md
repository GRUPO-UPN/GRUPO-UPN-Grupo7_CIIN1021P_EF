# 🏥 MARFARMA — Sistema Transaccional, Data Warehouse y Analítica Big Data

[![SQL Server](https://img.shields.io/badge/SQL_SERVER-2019%2B-red?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![T-SQL](https://img.shields.io/badge/T--SQL-DATABASE_ENGINE-0078D4?style=for-the-badge&logo=microsoft)](https://learn.microsoft.com/sql/t-sql/)
[![Architecture](https://img.shields.io/badge/ARCHITECTURE-KIMBALL_STAR_SCHEMA-76B900?style=for-the-badge)](https://www.kimballgroup.com/)
[![Compliance](https://img.shields.io/badge/COMPLIANCE-LEY_N.%C2%BA_29733_(PER%C3%9A)-007ACC?style=for-the-badge)](https://www.gob.pe/institucion/minjus/normas-legales/259164-29733)

[![MongoDB](https://img.shields.io/badge/MongoDB-NoSQL-47A248?style=for-the-badge&logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Apache Spark](https://img.shields.io/badge/PySpark-Big_Data_Analytics-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)](https://spark.apache.org/)
[![Power BI](https://img.shields.io/badge/Power_BI-Business_Intelligence-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![Google Colab](https://img.shields.io/badge/Google_Colab-Notebook_Execution-F9AB00?style=for-the-badge&logo=googlecolab&logoColor=white)](https://colab.research.google.com/drive/1zPjf0qTjOxWyQxgfCW5r3VU36NB_Daea?usp=sharing)

---

## 📌 Enlaces del Proyecto

* 📄 **Informe Académico Final (Google Docs):**  
  [Ver Documento Oficial](https://docs.google.com/document/d/1Vq2KuKZ5SP5ivXN2ev0f19g59X_ATJn_/edit?usp=sharing&ouid=101032473611357179014&rtpof=true&sd=true)

* ⚡ **Ejecución y Análisis en Google Colab:**  
  [Abrir Notebook en Colab](https://colab.research.google.com/drive/1zPjf0qTjOxWyQxgfCW5r3VU36NB_Daea?usp=sharing)

---

## 📖 Descripción del Proyecto

Este repositorio contiene la solución integral de ingeniería de datos para la cadena farmacéutica **MARFARMA**, abarcando desde la gestión de base de datos relacional (OLTP) y no relacional (NoSQL), pasando por la integración y pipelines ETL, el diseño y carga del Data Warehouse (OLAP), hasta la analítica avanzada con Big Data y cuadros de mando gerenciales en Business Intelligence.

---

## 👥 Integrantes — Grupo 7

* **Curso:** CIIN1021P
* **Evaluación:** Evaluación Final (EF)
* **Integrantes:**
  * 1. Aguilar Cruz, Alex Gustavo
   2. Fernandez Vigo Sergio Esteban
   3. Ishpilco Quispe, Esau
   4. Malca Chilon, Antony                                                                                
   5. Vasquez Valdez Jaime Farid
   *

---

## 🏗️ Arquitectura de la Solución

```mermaid
flowchart LR
    subgraph Fuentes
        A[(SQL Server\nOLTP)]
        B[(MongoDB\nCatálogo)]
        C[CSV Datasets]
    end

    subgraph Pipeline
        D[ETL Python / Pandas]
    end

    subgraph Almacenamiento Analítico
        E[(Data Warehouse\nStar Schema)]
    end

    subgraph Consumo y Analítica
        F[Power BI\nDashboards]
        G[PySpark / Colab\nBig Data Analytics]
    end

    A --> D
    B --> D
    C --> D
    D --> E
    E --> F
    E --> G
