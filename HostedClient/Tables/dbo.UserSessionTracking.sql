CREATE TABLE [dbo].[UserSessionTracking]
(
[UserSessionTrackingId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[SessionToken] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastActivity] [datetime] NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_UserSessionTracking_IsActive] DEFAULT ((1)),
[DeviceId] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_UserSessionTracking_DeviceId] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserSessionTracking] ADD CONSTRAINT [PK_UserSessionTracking] PRIMARY KEY CLUSTERED  ([UserSessionTrackingId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_UserSessionTracking_Userid] ON [dbo].[UserSessionTracking] ([UserId]) ON [PRIMARY]
GO
