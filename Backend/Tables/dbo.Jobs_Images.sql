CREATE TABLE [dbo].[Jobs_Images]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ImagePath] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Jobs_Images] ON [dbo].[Jobs_Images] ([JobNumber]) ON [PRIMARY]
GO
