CREATE TABLE [dbo].[ExpressNotesTags]
(
[TagID] [int] NOT NULL IDENTITY(1, 1),
[JobTypeID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Required] [bit] NOT NULL,
[FieldName] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExpressNotesTags] ADD CONSTRAINT [PK_ExpressNotesTags] PRIMARY KEY CLUSTERED  ([TagID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExpressNotesTags] ADD CONSTRAINT [FK_ExpressNotesTags_JobTypes] FOREIGN KEY ([JobTypeID]) REFERENCES [dbo].[JobTypes] ([JobTypeID])
GO
