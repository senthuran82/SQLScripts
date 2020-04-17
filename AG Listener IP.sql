SELECT agl.dns_name, agl_ip.ip_address, agl_ip.network_subnet_ip
FROM sys.availability_group_listeners agl
INNER JOIN sys.availability_group_listener_ip_addresses agl_ip
ON agl.listener_id = agl_ip.listener_id