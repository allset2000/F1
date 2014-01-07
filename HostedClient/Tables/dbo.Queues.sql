CREATE TABLE [dbo].[Queues]
(
[QueueID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_Queues_Active] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queues] ADD CONSTRAINT [PK_Queues] PRIMARY KEY CLUSTERED  ([QueueID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Queues_ClinicID] ON [dbo].[Queues] ([ClinicID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queues] ADD CONSTRAINT [FK_Queues_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID]) ON DELETE CASCADE
GO
