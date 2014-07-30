CREATE TABLE [dbo].[AdminLogging]
(
[LogId] [int] NOT NULL IDENTITY(1, 1),
[Username] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Operation] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperationData] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperationDateTime] [datetime] NOT NULL CONSTRAINT [DF_AdminLogging_OperationDateTime] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AdminLogging] ADD CONSTRAINT [PK_AdminLogging] PRIMARY KEY CLUSTERED  ([LogId]) ON [PRIMARY]
GO
