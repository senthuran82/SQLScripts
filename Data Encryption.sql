CREATE DATABASE [data encryption test]
GO


USE [data encryption test]
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'D@t@3ncR4pT10n'
GO

CREATE CERTIFICATE data_encrypt_cert
WITH SUBJECT = 'Data Encryption Test'
GO

CREATE SYMMETRIC KEY data_encrypt_key
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE data_encrypt_cert

GO

CREATE TABLE encrypt_test
(
 c1 INT
, c2 BIGINT
, c3 VARBINARY (MAX)
)

GO


DECLARE @c1 INT = 1
DECLARE @c2 BIGINT = 4147202836508587


WHILE @c1 < 101
BEGIN
INSERT INTO encrypt_test (c1, c2)
VALUES (@c1, @c2)
SET @c1+=1
SET @c2+=1
END

OPEN SYMMETRIC KEY data_encrypt_key
DECRYPTION BY CERTIFICATE data_encrypt_cert

GO

UPDATE encrypt_test
SET c3 = ENCRYPTBYKEY (KEY_GUID('data_encrypt_key'), CONVERT(VARCHAR, c2))
FROM encrypt_test

GO

CLOSE SYMMETRIC KEY data_encrypt_key


SELECT *
FROM encrypt_test

ALTER TABLE encrypt_test
DROP COLUMN c2

SELECT c1, c3, CONVERT (VARCHAR, DECRYPTBYKEY(c3)) AS c3_decrypted
FROM encrypt_test

GRANT VIEW DEFINITION ON SYMMETRIC KEY::data_encrypt_key TO [DATAVAIL\ssubramaniam]; 
GO
GRANT VIEW DEFINITION ON Certificate::data_encrypt_cert TO [DATAVAIL\ssubramaniam];
GO