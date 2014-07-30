CREATE TABLE [dbo].[DSGCompanies]
(
[CompanyId] [int] NOT NULL IDENTITY(1, 1),
[CompanyName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DSGCompanies_CompanyName] DEFAULT (''),
[CompanyCode] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DSGCompanies_CompanyCode] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSGCompanies] ADD CONSTRAINT [PK_DSGCompanies] PRIMARY KEY CLUSTERED  ([CompanyId]) ON [PRIMARY]
GO
