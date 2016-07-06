CREATE TABLE [dbo].[LogExceptions]
(
[LogExceptionID] [int] NOT NULL IDENTITY(1, 1),
[LogConfigurationID] [int] NOT NULL,
[MainClassName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainMethodName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorThrownAtClassName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorThrownAtMethodName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InnerError] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StackTrace] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCreatedDate] [datetime] NOT NULL CONSTRAINT [DF__LogExcept__Error__70F39DC8] DEFAULT (getdate()),
[ErrorWrittenDate] [datetime] NOT NULL CONSTRAINT [DF__LogExcept__Error__71E7C201] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogExceptions] ADD CONSTRAINT [PK_LogExceptions] PRIMARY KEY CLUSTERED  ([LogExceptionID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20160701-102541] ON [dbo].[LogExceptions] ([LogConfigurationID], [ErrorWrittenDate]) INCLUDE ([ErrorThrownAtMethodName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogExceptions] ADD CONSTRAINT [FK_LogExceptions_LogConfiguration] FOREIGN KEY ([LogConfigurationID]) REFERENCES [dbo].[LogConfiguration] ([LogConfigurationID])
GO
CREATE FULLTEXT INDEX ON [dbo].[LogExceptions] KEY INDEX [PK_LogExceptions] ON [LogExceptionErrors]
GO
ALTER FULLTEXT INDEX ON [dbo].[LogExceptions] ADD ([ExceptionMessage] LANGUAGE 1033)
GO
