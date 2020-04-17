USE Test
GO

CREATE TABLE backup_size_test
(
c1 INT IDENTITY (1, 1)
, c2 VARCHAR (MAX)
)

GO

DECLARE @a INT = 1

WHILE (@a < 20000000)
BEGIN
INSERT INTO backup_size_test (c2)
VALUES ('abcdefghijklmnopqrstuvwxyz_abcdefghijklmnopqrstuvwxyz')
SET @a = @a+1
END

SELECT *
INTO backup_size_1
FROM backup_size
GO
SELECT *
INTO backup_size_2
FROM backup_size
GO
SELECT *
INTO backup_size_3
FROM backup_size
GO
SELECT *
INTO backup_size_4
FROM backup_size
GO
SELECT *
INTO backup_size_5
FROM backup_size
GO
SELECT *
INTO backup_size_6
FROM backup_size
GO
SELECT *
INTO backup_size_7
FROM backup_size
GO
SELECT *
INTO backup_size_8
FROM backup_size
GO
SELECT *
INTO backup_size_9
FROM backup_size
GO
SELECT *
INTO backup_size_10
FROM backup_size
GO

SELECT *
INTO backup_size_11
FROM backup_size
GO
SELECT *
INTO backup_size_12
FROM backup_size
GO
SELECT *
INTO backup_size_13
FROM backup_size
GO
SELECT *
INTO backup_size_14
FROM backup_size
GO
SELECT *
INTO backup_size_15
FROM backup_size
GO
SELECT *
INTO backup_size_16
FROM backup_size
GO
SELECT *
INTO backup_size_17
FROM backup_size
GO
SELECT *
INTO backup_size_18
FROM backup_size
GO
SELECT *
INTO backup_size_19
FROM backup_size
GO
SELECT *
INTO backup_size_20
FROM backup_size
GO

SELECT *
INTO backup_size_21
FROM backup_size
GO
SELECT *
INTO backup_size_22
FROM backup_size
GO
SELECT *
INTO backup_size_23
FROM backup_size
GO
SELECT *
INTO backup_size_24
FROM backup_size
GO
SELECT *
INTO backup_size_25
FROM backup_size
GO
SELECT *
INTO backup_size_26
FROM backup_size
GO
SELECT *
INTO backup_size_27
FROM backup_size
GO
SELECT *
INTO backup_size_28
FROM backup_size
GO
SELECT *
INTO backup_size_29
FROM backup_size
GO
SELECT *
INTO backup_size_30
FROM backup_size
GO