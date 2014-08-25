CREATE TABLE [dbo].[MobileTracking]
(
[TrackingID] [bigint] NOT NULL IDENTITY(1, 1),
[Version] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Build] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Tag] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClinicCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TimeStamp] [datetime] NOT NULL CONSTRAINT [DF_MobileTracking_TimeStamp] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MobileTracking] ADD CONSTRAINT [PK_MobileTracking] PRIMARY KEY CLUSTERED  ([TrackingID]) ON [PRIMARY]
GO
