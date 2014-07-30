IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'mmoscoso')
CREATE LOGIN [mmoscoso] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [mmoscoso] FOR LOGIN [mmoscoso]
GO
