set�nocount�on�

IF�OBJECT_ID(N'tempdb..##servrole')�IS�NOT�NULL�

DROP�TABLE�##servrole�
�
CREATE�TABLE�##servrole�(query�varchar(1000))�
�
�insert�into�##servrole�select�'use�master;'�
�
insert�into�##servrole��select�'�exec�sp_addsrvrolemember�'''+m.name+''','+p.name+';'�FROM�sys.server_role_members�rm�
JOIN�sys.server_principals�p�
ON�rm.role_principal_id�=�p.principal_id�
JOIN�sys.server_principals�m�
ON�rm.member_principal_id�=�m.principal_id�
where�m.name�not�in�('sa','dbo','entity�owner','information_schema','sys','public');�
�
insert�into�##servrole�select��
case�when�sp.state_desc='GRANT_WITH_GRANT_OPTION'�then�
substring�(state_desc,0,6)+'�'+permission_name+'�to�['+srp.name+']�with�grant�option�;'�
else��
state_desc+'�'+permission_name+'�to�['+srp.name+']�;'end�
from�sys.server_permissions�sp�
join�sys.server_principals�srp�on��sp.grantee_principal_id=srp.principal_id�
where�srp.name�not�like�'%##%'�and�
srp.name�not�in�('sa','dbo','entity�owner','information_schema','sys')�
and�sp.type�not�in�('COSQ','CO');�

select�query�as�'�'�from�##servrole�where�query�is�not�null;�
go

drop�table�##servrole�
go 