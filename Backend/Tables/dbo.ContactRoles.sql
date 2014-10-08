CREATE TABLE [dbo].[ContactRoles]
(
[ContactRoleId] [int] NOT NULL,
[ContactId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ClinicId] [int] NOT NULL,
[ClinicsFilter] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DictatorsFilter] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobsFilter] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RoleStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
