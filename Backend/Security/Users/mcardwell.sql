IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'mcardwell')
CREATE LOGIN [mcardwell] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [mcardwell] FOR LOGIN [mcardwell]
GO
