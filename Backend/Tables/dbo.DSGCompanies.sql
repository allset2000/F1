CREATE TABLE [dbo].[DSGCompanies]
(
[CompanyId] [int] NOT NULL IDENTITY(1, 1),
[CompanyName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DSGCompanies_CompanyName] DEFAULT (''),
[CompanyCode] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DSGCompanies_CompanyCode] DEFAULT (''),
[vendor] [bit] NOT NULL CONSTRAINT [DF__DSGCompan__vendo__4B0DEC02] DEFAULT ((0))
) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[DSGCompanies] TO [carnold]
GRANT INSERT ON  [dbo].[DSGCompanies] TO [carnold]
GRANT UPDATE ON  [dbo].[DSGCompanies] TO [carnold]
GO

ALTER TABLE [dbo].[DSGCompanies] ADD CONSTRAINT [PK_DSGCompanies] PRIMARY KEY CLUSTERED  ([CompanyId]) ON [PRIMARY]
GO
