# PREGUNTAS Y RESPUESTAS PARA LA SUSTENTACIÓN (DEFENSA)

### 1. ¿Por qué eligieron Kimball (Bottom-up) en lugar de Inmon para el Data Warehouse?
**Respuesta:** Kimball permite construir el Data Warehouse iterativamente a través de Data Marts (en este caso el de Ventas de MARFARMA) orientados a procesos de negocio. Es más rápido de implementar y su modelo desnormalizado en estrella está altamente optimizado para consultas de lectura en herramientas como Power BI, a diferencia de Inmon que requiere un modelo normalizado corporativo previo muy costoso de diseñar.

### 2. ¿Qué ventaja tiene MongoDB frente a SQL Server en este proyecto?
**Respuesta:** En SQL Server dependemos de un esquema fijo. Con MongoDB, al usar un modelo basado en documentos, pudimos encapsular una Venta, su Cliente y sus Múltiples Detalles en un solo documento JSON. Esto reduce los costosos JOINs a nivel de base de datos y permite flexibilidad (por ejemplo, si a un detalle le agregamos campos médicos que a otro no). Sin embargo, carece de transaccionalidad ACID entre múltiples colecciones con el mismo rendimiento que SQL Server.

### 3. ¿Cómo aseguran el cumplimiento de la Ley de Protección de Datos Personales (Ley 29733)?
**Respuesta:** Se aplicó el *Principio de Menor Privilegio* mediante la creación de Roles. El Cajero solo puede ejecutar el SP de registro sin listar a todos los pacientes; el Analista solo consulta vistas con datos agregados (sin nombres/DNI); y se creó un Trigger de Auditoría de DML que registra quién, cómo y cuándo se modifica la data sensible, cuyo log solo puede ser leído por el Auditor.

### 4. ¿Qué ventaja aporta Apache Spark (PySpark) frente a SQL Server puro?
**Respuesta:** A medida que las ventas de MARFARMA crezcan a cientos de millones de registros (Big Data), SQL Server verticalmente se saturará. PySpark procesa los datos en memoria de manera distribuida (RDDs y DataFrames a través de nodos de un clúster). Esto nos permite realizar agregaciones (ventas por distrito, top 10 productos) horizontalmente escalables en fracciones del tiempo que le tomaría al motor relacional local.
