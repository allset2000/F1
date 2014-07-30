CREATE TABLE [dbo].[JobsDeleted]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Username] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeletedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO
