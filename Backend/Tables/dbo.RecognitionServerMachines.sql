CREATE TABLE [dbo].[RecognitionServerMachines]
(
[RecServerGroupId] [smallint] NOT NULL,
[MachineName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RecognitionServerMachines] ADD CONSTRAINT [PK_RecognitionServerMachines] PRIMARY KEY CLUSTERED  ([RecServerGroupId], [MachineName]) ON [PRIMARY]
GO
