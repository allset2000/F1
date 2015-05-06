CREATE TABLE [dbo].[UserDeviceTracking]
(
[UserDeviceTrackingId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DeviceId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeviceInfo] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChangedOn] [datetime] NOT NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[UserDeviceTracking] ADD 
CONSTRAINT [PK_UserDeviceTracking] PRIMARY KEY CLUSTERED  ([UserDeviceTrackingId]) ON [PRIMARY]
GO
