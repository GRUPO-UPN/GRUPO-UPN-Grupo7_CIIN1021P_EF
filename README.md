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

## 📌 Enlaces Oficiales del Proyecto

* 📄 **Informe Académico Completo (Google Docs):**  
  [Acceder al Informe Oficial](https://docs.google.com/document/d/1Vq2KuKZ5SP5ivXN2ev0f19g59X_ATJn_/edit?usp=sharing&ouid=101032473611357179014&rtpof=true&sd=true)

* ⚡ **Cuaderno Interactivo en Google Colab (PySpark & Analítica):**  
  [Ejecutar en Google Colab](https://colab.research.google.com/drive/1zPjf0qTjOxWyQxgfCW5r3VU36NB_Daea?usp=sharing)

---

## 👥 Datos Académicos y Equipo de Trabajo

* **Curso:** CIIN1021P
* **Evaluación:** Evaluación Final (EF)
* **Grupo:** Grupo 7
* **Integrantes:**  
   
  * **1. Aguilar Cruz, Alex Gustavo
  * **2. Fernandez Vigo Sergio Esteban
  * **3. Ishpilco Quispe, Esau
  * **4. Malca Chilon, Antony                                                                             
  * **5. Vasquez Valdez Jaime Farid

---

## 📑 Tabla de Contenidos

1. [Descripción y Caso de Estudio](#-descripción-y-caso-de-estudio)
2. [Arquitectura Integral de la Solución](#-arquitectura-integral-de-la-solución)
3. [Estructura del Repositorio](#-estructura-del-repositorio)
4. [Capa Transaccional (OLTP) y NoSQL](#-capa-transaccional-oltp-y-nosql)
5. [Pipeline de Integración de Datos (ETL)](#-pipeline-de-integración-de-datos-etl)
6. [Data Warehouse y Modelo Dimensional (OLAP)](#-data-warehouse-y-modelo-dimensional-olap)
7. [Analítica Big Data con Apache Spark (PySpark)](#-analítica-big-data-con-apache-spark-pyspark)
8. [Business Intelligence (Power BI)](#-business-intelligence-power-bi)
9. [Gobernanza, Calidad de Datos y Cumplimiento Normativo](#-gobernanza-calidad-de-datos-y-cumplimiento-normativo)
10. [Estrategia y Políticas de Respaldo (Backups)](#-estrategia-y-políticas-de-respaldo-backups)
11. [Guía de Puesta en Marcha y Reproducción](#-guía-de-puesta-en-marcha-y-reproducción)
12. [Preguntas Frecuentes para Defensa de Proyecto](#-preguntas-frecuentes-para-defensa-de-proyecto)

---

## 🏢 Descripción y Caso de Estudio

**MARFARMA** es una cadena farmacéutica nacional con múltiples puntos de venta que atiende una alta demanda de productos médicos, cuidado personal y suplementos. Debido a su rápido crecimiento, la organización requería consolidar sus operaciones a través de un ecosistema escalable de ingeniería de datos capaz de:
* Centralizar el registro confiable de transacciones de ventas y control de clientes/vendedores.
* Adaptar el almacenamiento no estructurado de catálogos y trazabilidad rápida.
* Transformar y depurar datasets masivos mediante pipelines automatizados.
* Generar un Data Warehouse estructurado bajo la metodología Kimball para análisis multidimensional.
* Ejecutar analítica descriptiva y predictiva a escala con PySpark.
* Proveer paneles ejecutivos en Power BI para el soporte en la toma de decisiones estratégicas.

---

## 🏗️ Arquitectura Integral de la Solución

El flujo completo de datos implementado en este repositorio sigue una arquitectura por capas desacopladas:

```mermaid
flowchart TD
    subgraph Ingestion ["1. Fuentes de Datos (OLTP & Archivos)"]
        A[(SQL Server: MARFARMA_DB)]
        B[(MongoDB: Catálogo NoSQL)]
        C[Archivos Planos: CSV Datasets]
    end

    subgraph Pipeline ["2. Extracción, Transformación y Carga"]
        D[ETL_MARFARMA.py\nPython / Pandas / PyODBC]
        D -->|Logs & Auditoría| D1[etl_execution.log]
    end

    subgraph Storage ["3. Almacenamiento Analítico (OLAP)"]
        E[(Data Warehouse: MARFARMA_DW\nKimball Star Schema)]
    end

    subgraph Processing ["4. Procesamiento Distribuido (Big Data)"]
        F[PySpark Engine\nexecute_pyspark.py / Google Colab]
    end

    subgraph Analytics ["5. Visualización y BI"]
        G[Dashboard Power BI\nDASHBOARD.pbix]
        H[Gráficos Analíticos\nTop Productos / Distritos]
    end

    A --> D
    B --> D
    C --> D
    D --> E
    E --> F
    E --> G
    F --> H

