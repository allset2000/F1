CREATE TABLE [dbo].[JobParsingErrors]
(
[JobId] [int] NOT NULL,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastExceptionTime] [smalldatetime] NOT NULL,
[LastExceptionMessage] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExceptionCount] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobParsingErrors] ADD CONSTRAINT [PK_JobParsingErrors] PRIMARY KEY CLUSTERED  ([JobNumber]) ON [PRIMARY]
GO
