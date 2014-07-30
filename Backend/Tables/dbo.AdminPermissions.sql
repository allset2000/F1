CREATE TABLE [dbo].[AdminPermissions]
(
[Username] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Clinics] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Clinics] DEFAULT ((0)),
[Dictators] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Dictators] DEFAULT ((0)),
[Editors] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Editors] DEFAULT ((0)),
[Jobs] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Jobs] DEFAULT ((0)),
[Tdd] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Tdd] DEFAULT ((0)),
[Documents] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Documents] DEFAULT ((0)),
[ROWConfig] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_ROWConfig] DEFAULT ((0)),
[Lookups] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Lookups] DEFAULT ((0)),
[JobDelivery] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_JobDelivery] DEFAULT ((0)),
[Reports] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Reports] DEFAULT ((0)),
[Administration] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Administration] DEFAULT ((0)),
[Billing] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Billing] DEFAULT ((0)),
[VoicePRocessing] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_VoicePRocessing] DEFAULT ((0)),
[RecServer] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_RecServer] DEFAULT ((0)),
[Notifications] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_Notifications] DEFAULT ((0)),
[AutomatedBilling] [int] NOT NULL CONSTRAINT [DF_AdminPermissions_AutomatedBilling] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AdminPermissions] ADD CONSTRAINT [PK_AdminPermissions] PRIMARY KEY CLUSTERED  ([Username]) ON [PRIMARY]
GO
