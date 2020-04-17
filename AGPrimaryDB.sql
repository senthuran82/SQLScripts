SELECT 
                        d.[name], hars.role_desc, ag.[name]--, *
                FROM 
                        sys.DATABASES d
                        INNER JOIN sys.dm_hadr_availability_replica_states hars ON d.replica_id = hars.replica_id
						INNER JOIN sys.availability_groups ag ON ag.group_id = hars.group_id

						WHERE role_desc = 'PRIMARY'
						ORDER BY ag.[name]