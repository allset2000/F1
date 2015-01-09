CREATE TABLE [dbo].[DeviceManagement]
(
[DeviceManagementId] [int] NOT NULL IDENTITY(1, 1),
[ClinicId] [int] NOT NULL,
[DeviceId] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserAgent] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsApproved] [bit] NOT NULL CONSTRAINT [DF_DeviceManagement_IsApproved] DEFAULT ((0)),
[DateTimeInserted] [datetime] NOT NULL,
[DateTimeLastUpdated] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeviceManagement] ADD CONSTRAINT [PK_DeviceManagement] PRIMARY KEY CLUSTERED  ([DeviceManagementId]) ON [PRIMARY]
GO
