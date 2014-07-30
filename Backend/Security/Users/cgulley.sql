IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'cgulley')
CREATE LOGIN [cgulley] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [cgulley] FOR LOGIN [cgulley]
GO
