CREATE TABLE [dbo].[UserSessionTracking]
(
[UserSessionTrackingId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[SessionToken] [uniqueidentifier] NOT NULL,
[DateTimeLastActivity] [datetime] NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_UserSessionTracking_IsActive] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserSessionTracking] ADD CONSTRAINT [PK_UserSessionTracking] PRIMARY KEY CLUSTERED  ([UserSessionTrackingId]) ON [PRIMARY]
GO
