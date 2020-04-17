SELECT *
FROM sys.firewall_rules

--EXEC sp_set_firewall_rule @name = test, @start_ip_address = , @end_ip_address = 

--EXEC sp_delete_firewall_rule