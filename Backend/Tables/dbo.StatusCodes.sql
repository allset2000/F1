CREATE TABLE [dbo].[StatusCodes]
(
[StatusID] [smallint] NOT NULL,
[StatusName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FriendlyStatusName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_StatusCodes_FriendlyStatusName] DEFAULT (''),
[StatusClass] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatusStage] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditionStage] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrentEditorRule] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SpeechFolderTag] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActiveJobStatus] [bit] NOT NULL,
[IsJobSearchStatus] [bit] NOT NULL,
[IsSpecialCaseStatus] [bit] NOT NULL,
[StatusGroupId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StatusCodes] ADD CONSTRAINT [PK_StatusCodes] PRIMARY KEY CLUSTERED  ([StatusID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_StatusCodes_GroupID] ON [dbo].[StatusCodes] ([StatusGroupId], [StatusID]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StatusCodes] ADD CONSTRAINT [FK_StatusCodes_JobStatusGroup] FOREIGN KEY ([StatusGroupId]) REFERENCES [dbo].[JobStatusGroup] ([Id])
GO