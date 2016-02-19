CREATE TABLE [dbo].[JobImages]
(
[JobID] [bigint] NOT NULL,
[ImagePath] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ImageID] [bigint] NOT NULL IDENTITY(1, 1),
[ImageDescription] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobImages] ADD CONSTRAINT [PK_JobImages_ImageID] PRIMARY KEY CLUSTERED  ([ImageID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobImages] ON [dbo].[JobImages] ([JobID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobImages] ADD CONSTRAINT [FK_JobImages_Jobs] FOREIGN KEY ([JobID]) REFERENCES [dbo].[Jobs] ([JobID])
GO
