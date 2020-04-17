SELECT 'BACKUP DATABASE '+[name]+' TO DISK = '+'''\\PVCLOSQL300\DV Migration\Migration 03232019\Backups_300\'+[name]+'.BAK'+''''+' WITH STATS = 10, COMPRESSION GO'
FROM sys.databases
WHERE database_id > 4