# POLÍTICA DE PROTECCIÓN DE DATOS Y SEGURIDAD - MARFARMA

Este documento establece las políticas de protección de datos personales alineadas a la Ley N.° 29733 (Ley de Protección de Datos Personales del Perú) y su Reglamento, implementadas en la base de datos `MARFARMA_DB`.

## 1. Principio de Menor Privilegio
Para garantizar la confidencialidad y el acceso restringido a los datos sensibles, se han definido y asignado los siguientes roles:
- **ADMIN:** Acceso total y control sobre el esquema y la base de datos.
- **AUDITOR:** Acceso exclusivo de lectura a las tablas de log/auditoría. Tiene explícitamente bloqueado (`DENY`) el permiso de modificar, insertar o eliminar registros de auditoría.
- **ANALISTA:** Acceso de lectura únicamente a vistas agregadas y anonimizadas orientadas a Business Intelligence, sin acceso a los datos de contacto directo de los clientes cuando no es necesario.
- **CAJERO:** Acceso de ejecución al procedimiento almacenado de registro de ventas, sin permisos para consultar todo el historial de clientes o alterar inventario.

## 2. Auditoría y Trazabilidad (Log de Operaciones)
Se ha implementado una tabla de log `AUDITORIA_VENTAS` junto a Triggers en la tabla principal de transacciones (`VENTAS`). 
- **Qué se registra:** La acción (INSERT, UPDATE, DELETE), el usuario de base de datos que realizó el cambio, la fecha/hora exacta y el registro afectado.
- **Objetivo Legal:** Garantizar el registro de quién y cuándo se manipularon las transacciones de los pacientes/clientes.

## 3. Limitaciones
La actual implementación en base de datos proporciona controles técnicos a nivel de motor SQL Server. Se requiere que las aplicaciones cliente encripten en tránsito (TLS/SSL) los datos de los usuarios, y que a nivel de interfaz de usuario se expongan únicamente los campos requeridos, ocultando aquellos no esenciales según la operación solicitada.
