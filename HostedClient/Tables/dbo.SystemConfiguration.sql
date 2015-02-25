CREATE TABLE [dbo].[SystemConfiguration]
(
[ConfigId] [int] NOT NULL IDENTITY(1, 1),
[ConfigKey] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConfigValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NOT NULL,
[DateUpdated] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemConfiguration] ADD CONSTRAINT [PK_SystemConfiguration] PRIMARY KEY CLUSTERED  ([ConfigId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemConfiguration] ADD CONSTRAINT [UC_SystemConfiguration_ConfigKey] UNIQUE NONCLUSTERED  ([ConfigKey]) ON [PRIMARY]
GO
