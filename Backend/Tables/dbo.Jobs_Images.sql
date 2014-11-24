CREATE TABLE [dbo].[Jobs_Images]
(
[ImageID] [bigint] NOT NULL IDENTITY(1, 1),
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ImagePath] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Jobs_Images_JobNumber] ON [dbo].[Jobs_Images] ([JobNumber]) ON [PRIMARY]

ALTER TABLE [dbo].[Jobs_Images] ADD 
CONSTRAINT [PK_Jobs_Images] PRIMARY KEY CLUSTERED  ([ImageID]) ON [PRIMARY]


GO
