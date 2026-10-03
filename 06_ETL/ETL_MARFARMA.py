import pandas as pd
import pyodbc
from sqlalchemy import create_engine, text
import logging

# Configurar logging
logging.basicConfig(filename='E:/MARFARMA_EF/06_ETL/etl_execution.log', level=logging.INFO, 
                    format='%(asctime)s - %(levelname)s - %(message)s')

logging.info('INICIANDO PROCESO ETL MARFARMA...')

# Cadenas de conexión (Trust Server Certificate)
# Se asume autenticación de Windows a servidor local
source_conn_str = "mssql+pyodbc://@localhost/MARFARMA_DB?driver=ODBC+Driver+18+for+SQL+Server&TrustServerCertificate=yes"
target_conn_str = "mssql+pyodbc://@localhost/MARFARMA_DW?driver=ODBC+Driver+18+for+SQL+Server&TrustServerCertificate=yes"

try:
    engine_src = create_engine(source_conn_str)
    engine_tgt = create_engine(target_conn_str)
    
    # -----------------------------------------------------
    # 1. EXTRACT
    # -----------------------------------------------------
    logging.info('EXTRACT: Leyendo tablas desde MARFARMA_DB')
    
    df_clientes = pd.read_sql("SELECT * FROM CLIENTES", engine_src)
    df_vendedores = pd.read_sql("SELECT * FROM VENDEDORES", engine_src)
    df_productos = pd.read_sql("SELECT * FROM PRODUCTOS", engine_src)
    df_ventas = pd.read_sql("SELECT * FROM VENTAS", engine_src)
    df_detalle = pd.read_sql("SELECT * FROM DETALLE_VENTA", engine_src)
    
    # -----------------------------------------------------
    # 2. TRANSFORM
    # -----------------------------------------------------
    logging.info('TRANSFORM: Limpieza, enriquecimiento y formateo de dimensiones')
    
    # DimCliente: Agrupar edad en rangos
    def clasificar_edad(edad):
        if edad < 18: return 'Menor de Edad'
        elif edad <= 30: return 'Joven'
        elif edad <= 50: return 'Adulto'
        else: return 'Adulto Mayor'

    df_clientes['EdadRango'] = df_clientes['edad'].apply(clasificar_edad)
    df_clientes['NombreCompleto'] = df_clientes['nombre_cliente'] + ' ' + df_clientes['apellido_paterno'] + ' ' + df_clientes['apellido_materno'].fillna('')
    df_clientes['NombreCompleto'] = df_clientes['NombreCompleto'].str.strip()
    dim_cliente = df_clientes[['id_cliente', 'NombreCompleto', 'sexo', 'EdadRango', 'distrito', 'tipo_cliente']]
    dim_cliente = dim_cliente.rename(columns={'sexo':'Sexo', 'distrito':'Distrito', 'tipo_cliente':'TipoCliente'})
    
    # DimProducto
    dim_producto = df_productos[['id_producto', 'nombre_producto', 'categoria', 'laboratorio']]
    dim_producto = dim_producto.rename(columns={'nombre_producto': 'NombreProducto', 'categoria': 'Categoria', 'laboratorio': 'Laboratorio'})
    
    # DimVendedor
    dim_vendedor = df_vendedores[['id_vendedor', 'nombre_vendedor', 'turno']]
    dim_vendedor = dim_vendedor.rename(columns={'nombre_vendedor': 'NombreVendedor', 'turno': 'Turno'})
    
    # DimTiempo (generada a partir de las fechas de las ventas)
    df_ventas['fecha'] = pd.to_datetime(df_ventas['fecha'])
    fechas_unicas = df_ventas['fecha'].drop_duplicates()
    dim_tiempo = pd.DataFrame({'Fecha': fechas_unicas})
    dim_tiempo['DateKey'] = dim_tiempo['Fecha'].dt.strftime('%Y%m%d').astype(int)
    dim_tiempo['Dia'] = dim_tiempo['Fecha'].dt.day
    dim_tiempo['Mes'] = dim_tiempo['Fecha'].dt.month
    dim_tiempo['Anio'] = dim_tiempo['Fecha'].dt.year
    dim_tiempo['NombreMes'] = dim_tiempo['Fecha'].dt.month_name(locale='es_ES.utf8') # O dejar por defecto
    dim_tiempo['Trimestre'] = dim_tiempo['Fecha'].dt.quarter
    
    # -----------------------------------------------------
    # 3. LOAD (Carga en MARFARMA_DW)
    # -----------------------------------------------------
    logging.info('LOAD: Cargando dimensiones en MARFARMA_DW')
    
    # Escribir dimensiones (se reemplaza si hay datos previos, o se hace merge, usaremos if_exists='append' para un flujo incremental, pero para la prueba vaciamos y llenamos)
    # Aquí vaciaremos para simular un load Full
    with engine_tgt.begin() as conn:
        conn.execute(text("DELETE FROM FactVentas"))
        conn.execute(text("DELETE FROM DimCliente"))
        conn.execute(text("DELETE FROM DimProducto"))
        conn.execute(text("DELETE FROM DimVendedor"))
        conn.execute(text("DELETE FROM DimTiempo"))
    
    dim_tiempo.to_sql('DimTiempo', engine_tgt, if_exists='append', index=False)
    
    # Cargar y recuperar las Surrogate Keys (Generadas por IDENTITY)
    dim_cliente.to_sql('DimCliente', engine_tgt, if_exists='append', index=False)
    dim_producto.to_sql('DimProducto', engine_tgt, if_exists='append', index=False)
    dim_vendedor.to_sql('DimVendedor', engine_tgt, if_exists='append', index=False)
    
    # Recuperar las SK generadas
    sk_cliente = pd.read_sql("SELECT ClienteKey, id_cliente FROM DimCliente", engine_tgt)
    sk_producto = pd.read_sql("SELECT ProductoKey, id_producto FROM DimProducto", engine_tgt)
    sk_vendedor = pd.read_sql("SELECT VendedorKey, id_vendedor FROM DimVendedor", engine_tgt)
    
    # Generar la Tabla de Hechos
    logging.info('TRANSFORM & LOAD: Construyendo FactVentas')
    df_hechos = pd.merge(df_detalle, df_ventas, on='id_venta', how='inner')
    
    # Hacer JOIN con las dimensiones para obtener las SKs
    df_hechos['DateKey'] = df_hechos['fecha'].dt.strftime('%Y%m%d').astype(int)
    
    df_hechos = pd.merge(df_hechos, sk_cliente, on='id_cliente', how='left')
    df_hechos = pd.merge(df_hechos, sk_vendedor, on='id_vendedor', how='left')
    df_hechos = pd.merge(df_hechos, sk_producto, on='id_producto', how='left')
    
    # Seleccionar las columnas para FactVentas
    fact_ventas = df_hechos[['DateKey', 'ClienteKey', 'VendedorKey', 'ProductoKey', 'metodo_pago', 
                             'cantidad', 'precio_unitario', 'subtotal', 'descuento', 'igv', 'total']]
    fact_ventas = fact_ventas.rename(columns={'metodo_pago': 'MetodoPago', 'cantidad': 'Cantidad',
                                              'precio_unitario': 'PrecioUnitario', 'subtotal': 'Subtotal',
                                              'descuento': 'Descuento', 'igv': 'IGV', 'total': 'Total'})
    
    fact_ventas.to_sql('FactVentas', engine_tgt, if_exists='append', index=False)
    
    logging.info(f'ETL FINALIZADO CON ÉXITO. Hechos procesados: {len(fact_ventas)}')
    print("ETL Procesado Correctamente. Verifica etl_execution.log")

except Exception as e:
    logging.error(f'ERROR EN ETL: {str(e)}')
    print(f"Error en ETL: {e}")
