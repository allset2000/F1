CREATE TABLE [dbo].[Applications]
(
[ApplicationId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Applications] ADD CONSTRAINT [PK_Applications] PRIMARY KEY CLUSTERED  ([ApplicationId]) ON [PRIMARY]
GO
