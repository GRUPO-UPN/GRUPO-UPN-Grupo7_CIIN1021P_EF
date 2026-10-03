from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as _sum, month, year, count
import matplotlib.pyplot as plt
import os

# 1. Inicializar Spark
spark = SparkSession.builder \
    .appName("MARFARMA_BigData") \
    .master("local[*]") \
    .getOrCreate()

# 2. Carga de CSV
df_ventas = spark.read.csv("E:/MARFARMA_EF/03_DATASET/datos/MARFARMA_VENTAS_65000.csv", header=True, inferSchema=True)

# Filtrado de limpieza
df_ventas = df_ventas.filter(col("total") > 0).filter(col("cantidad") > 0)
df_ventas.createOrReplaceTempView("ventas_vw")

# 1. Ventas por mes y año
ventas_mes = df_ventas.groupBy(year("fecha").alias("Anio"), month("fecha").alias("Mes")) \
    .agg(_sum("total").alias("TotalVentas")) \
    .orderBy("Anio", "Mes")
    
# 2. Top 10 Productos
top_productos = spark.sql("""
    SELECT nombre_producto, SUM(total) as TotalVentas 
    FROM ventas_vw 
    GROUP BY nombre_producto 
    ORDER BY TotalVentas DESC 
    LIMIT 10
""")

# 3. Ventas por Categoría
ventas_cat = df_ventas.groupBy("categoria").agg(_sum("total").alias("TotalVentas")).orderBy(col("TotalVentas").desc())

# 4. Ventas por Distrito
ventas_dist = df_ventas.groupBy("distrito").agg(_sum("total").alias("TotalVentas")).orderBy(col("TotalVentas").desc())

# Convertir a Pandas para graficar
pdf_mes = ventas_mes.toPandas()
pdf_prod = top_productos.toPandas()
pdf_cat = ventas_cat.toPandas()
pdf_dist = ventas_dist.toPandas()

# Gráfico 1: Ventas por Mes
pdf_mes['Periodo'] = pdf_mes['Anio'].astype(str) + '-' + pdf_mes['Mes'].astype(str).str.zfill(2)
plt.figure(figsize=(10, 5))
plt.plot(pdf_mes['Periodo'], pdf_mes['TotalVentas'], marker='o')
plt.title("Evolución de Ventas por Mes (PySpark)")
plt.xlabel("Periodo")
plt.ylabel("Total Ventas (S/)")
plt.xticks(rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig('E:/MARFARMA_EF/09_BIG_DATA/graficos/ventas_por_mes.png')
plt.close()

# Gráfico 2: Top 10 Productos
plt.figure(figsize=(10, 5))
plt.bar(pdf_prod['nombre_producto'], pdf_prod['TotalVentas'], color='green')
plt.title("Top 10 Productos por Facturación")
plt.xlabel("Producto")
plt.ylabel("Facturación (S/)")
plt.xticks(rotation=90)
plt.tight_layout()
plt.savefig('E:/MARFARMA_EF/09_BIG_DATA/graficos/top_productos.png')
plt.close()

# Gráfico 3: Ventas por Categoría
plt.figure(figsize=(8, 8))
plt.pie(pdf_cat['TotalVentas'], labels=pdf_cat['categoria'], autopct='%1.1f%%')
plt.title("Participación de Ventas por Categoría")
plt.savefig('E:/MARFARMA_EF/09_BIG_DATA/graficos/ventas_por_categoria.png')
plt.close()

# Gráfico 4: Ventas por Distrito
plt.figure(figsize=(10, 5))
plt.bar(pdf_dist['distrito'], pdf_dist['TotalVentas'], color='orange')
plt.title("Ventas por Distrito")
plt.xlabel("Distrito")
plt.ylabel("Facturación (S/)")
plt.xticks(rotation=90)
plt.tight_layout()
plt.savefig('E:/MARFARMA_EF/09_BIG_DATA/graficos/ventas_por_distrito.png')
plt.close()

# Guardar Resultados Agregados en CSV
pdf_mes.to_csv('E:/MARFARMA_EF/09_BIG_DATA/resultados/ventas_por_mes.csv', index=False)
pdf_prod.to_csv('E:/MARFARMA_EF/09_BIG_DATA/resultados/top_productos.csv', index=False)

print("Gráficos generados y exportados correctamente.")
