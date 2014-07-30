CREATE TABLE [dbo].[RecognitionServerGroups]
(
[RecServerGroupId] [smallint] NOT NULL,
[RecServerGroupName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SkipUpdater] [bit] NOT NULL CONSTRAINT [DF_RecognitionServerGroups_SkipUpdater] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RecognitionServerGroups] ADD CONSTRAINT [PK_RecognitionServerGroups] PRIMARY KEY CLUSTERED  ([RecServerGroupId]) ON [PRIMARY]
GO
