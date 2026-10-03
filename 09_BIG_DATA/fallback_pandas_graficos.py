import pandas as pd
import matplotlib.pyplot as plt
import os

# Carga de CSV
df_ventas = pd.read_csv("E:/MARFARMA_EF/03_DATASET/datos/MARFARMA_VENTAS_65000.csv")
df_ventas['fecha'] = pd.to_datetime(df_ventas['fecha'])

# Filtrado de limpieza
df_ventas = df_ventas[(df_ventas['total'] > 0) & (df_ventas['cantidad'] > 0)]

# 1. Ventas por mes y año
df_ventas['Anio'] = df_ventas['fecha'].dt.year
df_ventas['Mes'] = df_ventas['fecha'].dt.month
ventas_mes = df_ventas.groupby(['Anio', 'Mes'])['total'].sum().reset_index()
ventas_mes = ventas_mes.rename(columns={'total': 'TotalVentas'})
    
# 2. Top 10 Productos
top_productos = df_ventas.groupby('nombre_producto')['total'].sum().reset_index()
top_productos = top_productos.rename(columns={'total': 'TotalVentas'})
top_productos = top_productos.sort_values(by='TotalVentas', ascending=False).head(10)

# 3. Ventas por Categoría
ventas_cat = df_ventas.groupby('categoria')['total'].sum().reset_index()
ventas_cat = ventas_cat.rename(columns={'total': 'TotalVentas'}).sort_values(by='TotalVentas', ascending=False)

# 4. Ventas por Distrito
ventas_dist = df_ventas.groupby('distrito')['total'].sum().reset_index()
ventas_dist = ventas_dist.rename(columns={'total': 'TotalVentas'}).sort_values(by='TotalVentas', ascending=False)

# Gráfico 1: Ventas por Mes
ventas_mes['Periodo'] = ventas_mes['Anio'].astype(str) + '-' + ventas_mes['Mes'].astype(str).str.zfill(2)
plt.figure(figsize=(10, 5))
plt.plot(ventas_mes['Periodo'], ventas_mes['TotalVentas'], marker='o')
plt.title("Evolución de Ventas por Mes")
plt.xlabel("Periodo")
plt.ylabel("Total Ventas (S/)")
plt.xticks(rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig('E:/MARFARMA_EF/09_BIG_DATA/graficos/ventas_por_mes.png')
plt.close()

# Gráfico 2: Top 10 Productos
plt.figure(figsize=(10, 5))
plt.bar(top_productos['nombre_producto'], top_productos['TotalVentas'], color='green')
plt.title("Top 10 Productos por Facturación")
plt.xlabel("Producto")
plt.ylabel("Facturación (S/)")
plt.xticks(rotation=90)
plt.tight_layout()
plt.savefig('E:/MARFARMA_EF/09_BIG_DATA/graficos/top_productos.png')
plt.close()

# Gráfico 3: Ventas por Categoría
plt.figure(figsize=(8, 8))
plt.pie(ventas_cat['TotalVentas'], labels=ventas_cat['categoria'], autopct='%1.1f%%')
plt.title("Participación de Ventas por Categoría")
plt.savefig('E:/MARFARMA_EF/09_BIG_DATA/graficos/ventas_por_categoria.png')
plt.close()

# Gráfico 4: Ventas por Distrito
plt.figure(figsize=(10, 5))
plt.bar(ventas_dist['distrito'], ventas_dist['TotalVentas'], color='orange')
plt.title("Ventas por Distrito")
plt.xlabel("Distrito")
plt.ylabel("Facturación (S/)")
plt.xticks(rotation=90)
plt.tight_layout()
plt.savefig('E:/MARFARMA_EF/09_BIG_DATA/graficos/ventas_por_distrito.png')
plt.close()

# Guardar Resultados Agregados en CSV
ventas_mes.to_csv('E:/MARFARMA_EF/09_BIG_DATA/resultados/ventas_por_mes.csv', index=False)
top_productos.to_csv('E:/MARFARMA_EF/09_BIG_DATA/resultados/top_productos.csv', index=False)

print("Gráficos generados como respaldo (Pandas).")
