CREATE TABLE [dbo].[LogExceptions]
(
[LogExceptionID] [int] NOT NULL IDENTITY(1, 1),
[LogConfigurationID] [int] NOT NULL,
[MainClassName] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainMethodName] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorThrownAtClassName] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorThrownAtMethodName] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InnerError] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StackTrace] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCreatedDate] [datetime] NOT NULL CONSTRAINT [DF__LogExcept__Error__3F914C5E] DEFAULT (getdate()),
[ErrorWrittenDate] [datetime] NOT NULL CONSTRAINT [DF__LogExcept__Error__40857097] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogExceptions] ADD CONSTRAINT [PK_LogExceptions] PRIMARY KEY CLUSTERED  ([LogExceptionID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogExceptions] ADD CONSTRAINT [FK_LogExceptions_LogConfiguration] FOREIGN KEY ([LogConfigurationID]) REFERENCES [dbo].[LogConfiguration] ([LogConfigurationID])
GO
