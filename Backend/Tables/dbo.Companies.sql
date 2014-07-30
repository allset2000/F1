CREATE TABLE [dbo].[Companies]
(
[CompanyId] [int] NOT NULL,
[CompanyName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompanyCode] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditingWorkflowModelId] [int] NOT NULL,
[CompanyStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Companies] ADD CONSTRAINT [PK_Companies_1] PRIMARY KEY CLUSTERED  ([CompanyId]) ON [PRIMARY]
GO
