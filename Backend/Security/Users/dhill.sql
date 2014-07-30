IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'dhill')
CREATE LOGIN [dhill] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [dhill] FOR LOGIN [dhill]
GO
