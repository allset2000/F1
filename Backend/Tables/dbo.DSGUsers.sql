CREATE TABLE [dbo].[DSGUsers]
(
[UserId] [int] NOT NULL IDENTITY(1, 1),
[Username] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompanyId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSGUsers] ADD CONSTRAINT [PK_DSGUsers] PRIMARY KEY CLUSTERED  ([UserId]) ON [PRIMARY]
GO
