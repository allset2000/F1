CREATE TABLE [dbo].[Applications]
(
[ApplicationId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PermissionEnabled] [bit] NOT NULL CONSTRAINT [DF_Applications_PermissionEnabled] DEFAULT ((0)),
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_Applications_IsDeleted] DEFAULT ((0)),
[DateCreated] [datetime] NULL,
[DateUpdated] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Applications] ADD CONSTRAINT [PK_Applications] PRIMARY KEY CLUSTERED  ([ApplicationId]) ON [PRIMARY]
GO
