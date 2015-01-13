CREATE TABLE [dbo].[UserDeviceTracking]
(
[UserDeviceTrackingId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DeviceId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeviceInfo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserDeviceTracking] ADD CONSTRAINT [PK_UserDeviceTracking] PRIMARY KEY CLUSTERED  ([UserDeviceTrackingId]) ON [PRIMARY]
GO
