CREATE TABLE [dbo].[ROW_AdminsClinics]
(
[PermissionId] [int] NOT NULL IDENTITY(1, 1),
[Admin_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Clinic_ID] [smallint] NULL,
[DictatorId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROW_AdminsClinics] ADD CONSTRAINT [PK_Admins_Clinics] PRIMARY KEY CLUSTERED  ([PermissionId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROW_AdminsClinics] ADD CONSTRAINT [FK_ROW_AdminsClinics_ROW_Admins] FOREIGN KEY ([Admin_ID]) REFERENCES [dbo].[ROW_Admins] ([Admin_ID])
GO
