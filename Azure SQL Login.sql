-- ===============================================
-- Create SQL Login template for Windows Azure SQL Database
-- ===============================================

CREATE LOGIN [Jon.Whitfield]
	WITH PASSWORD = 'AlFr35c0_R3p0rt1nG_#2' 
GO

CREATE USER [Angela.Smith] FROM LOGIN [Angela.Smith]

ALTER ROLE db_datawriter ADD MEMBER [Angela.Smith]

ALTER ROLE db_datareader ADD MEMBER [Angela.Smith]