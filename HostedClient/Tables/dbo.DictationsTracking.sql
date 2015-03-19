CREATE TABLE [dbo].[DictationsTracking]
(
[DictationsTrackingID] [bigint] NOT NULL IDENTITY(1, 1),
[DictationID] [bigint] NOT NULL,
[Status] [smallint] NOT NULL,
[ChangeDate] [datetime] NOT NULL,
[ChangedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DictationsTracking_Status_INC] ON [dbo].[DictationsTracking] ([Status]) INCLUDE ([ChangeDate], [DictationID]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[DictationsTracking] ADD CONSTRAINT [PK_DictationsTracking] PRIMARY KEY CLUSTERED  ([DictationsTrackingID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DictationsTracking_DictationID] ON [dbo].[DictationsTracking] ([DictationID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DictationsTracking] ADD CONSTRAINT [FK_DictationsTracking_Dictations] FOREIGN KEY ([DictationID]) REFERENCES [dbo].[Dictations] ([DictationID]) ON DELETE CASCADE
GO
