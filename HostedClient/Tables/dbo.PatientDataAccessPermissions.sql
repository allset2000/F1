CREATE TABLE [dbo].[PatientDataAccessPermissions]
(
[PatientDataAccessPermissionID] [int] NOT NULL IDENTITY(1, 1),
[PermissionCode] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientDataAccessPermissions] ADD CONSTRAINT [PK_PatientDataAccessPermissions] PRIMARY KEY CLUSTERED  ([PatientDataAccessPermissionID]) ON [PRIMARY]
GO
