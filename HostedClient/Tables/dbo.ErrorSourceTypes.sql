CREATE TABLE [dbo].[ErrorSourceTypes]
(
[ErrorSourceTypeID] [int] NOT NULL IDENTITY(1, 1),
[ErrorSourceType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ErrorSourceTypes] ADD CONSTRAINT [PK_ErrorSourceTypes] PRIMARY KEY CLUSTERED  ([ErrorSourceTypeID]) ON [PRIMARY]
GO
