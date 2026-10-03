# POLÍTICA DE BACKUP Y RECUPERACIÓN - MARFARMA

Este documento define la estrategia de copias de seguridad de la base de datos `MARFARMA_DB` para garantizar la continuidad del negocio y la protección contra pérdida de datos.

## 1. Estrategia de Respaldos
La estrategia implementada se basa en el modelo de recuperación FULL e incluye:
- **Backup Completo (Full):** Semanal (por ejemplo, los domingos a las 02:00 AM). Garantiza una base de recuperación sólida.
- **Backup Diferencial (Differential):** Diario (de lunes a sábado a las 02:00 AM). Minimiza el tiempo de respaldo diario y el tamaño del archivo capturando solo los cambios.
- **Retención:** Los archivos de respaldo deben mantenerse en disco local durante 15 días, y copiarse a un almacenamiento en la nube para retención a largo plazo.

## 2. Destinos
- **Almacenamiento Local (Prueba):** `E:\MARFARMA_EF\10_BACKUPS\`
- **Nube:** Se recomienda enviar a Azure Blob Storage o AWS S3 mediante procesos automatizados (por implementar).

## 3. Scripts de Respaldo

**Backup Completo:**
```sql
BACKUP DATABASE MARFARMA_DB 
TO DISK = 'E:\MARFARMA_EF\10_BACKUPS\MARFARMA_DB_Full.bak'
WITH FORMAT, MEDIANAME = 'SQLServerBackups', NAME = 'Full Backup of MARFARMA_DB';
```

**Backup Diferencial:**
```sql
BACKUP DATABASE MARFARMA_DB 
TO DISK = 'E:\MARFARMA_EF\10_BACKUPS\MARFARMA_DB_Diff.bak'
WITH DIFFERENTIAL, NAME = 'Differential Backup of MARFARMA_DB';
```

## 4. Procedimiento de Restauración
Para restaurar la base de datos a un punto reciente, se aplica primero el backup completo y luego el último diferencial:

```sql
-- 1. Restaurar Full (dejando BD en modo recuperación para aplicar el diferencial)
RESTORE DATABASE MARFARMA_DB 
FROM DISK = 'E:\MARFARMA_EF\10_BACKUPS\MARFARMA_DB_Full.bak'
WITH NORECOVERY, REPLACE;

-- 2. Restaurar Diferencial y recuperar BD
RESTORE DATABASE MARFARMA_DB 
FROM DISK = 'E:\MARFARMA_EF\10_BACKUPS\MARFARMA_DB_Diff.bak'
WITH RECOVERY;
```
