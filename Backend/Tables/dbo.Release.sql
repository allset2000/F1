CREATE TABLE [dbo].[Release]
(
[Tag] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Checksum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Subtitle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BundleId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
