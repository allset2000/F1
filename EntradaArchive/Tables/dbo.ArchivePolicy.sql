CREATE TABLE [dbo].[ArchivePolicy]
(
[PolicyID] [int] NOT NULL IDENTITY(1, 1),
[PolicyName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ArchiveAge] [int] NOT NULL,
[PurgeAge] [int] NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_ArchivePolicy_IsActive] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ArchivePolicy] ADD CONSTRAINT [PK_ArchivePolicy] PRIMARY KEY CLUSTERED  ([PolicyID]) ON [PRIMARY]
GO
