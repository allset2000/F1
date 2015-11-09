CREATE TABLE [dbo].[Roles]
(
[RoleID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NULL,
[RoleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[Roles] ADD
CONSTRAINT [FK_Roles_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
ALTER TABLE [dbo].[Roles] ADD CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED  ([RoleID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Roles_ClinicID] ON [dbo].[Roles] ([ClinicID]) ON [PRIMARY]
GO
