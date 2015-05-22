CREATE TABLE [dbo].[TimeZone]
(
[TimeZoneId] [int] NOT NULL IDENTITY(1, 1),
[TimeZoneName] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TimeZone] ADD CONSTRAINT [PK_TimeZone] PRIMARY KEY CLUSTERED  ([TimeZoneId]) ON [PRIMARY]
GO
