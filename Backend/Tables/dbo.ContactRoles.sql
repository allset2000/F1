CREATE TABLE [dbo].[ContactRoles]
(
[ContactRoleId] [int] NOT NULL,
[ContactId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ClinicId] [int] NOT NULL,
[ClinicsFilter] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DictatorsFilter] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ContactRoles_DictatorsFilter] DEFAULT (''),
[JobsFilter] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RoleStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ContactRoles] ADD CONSTRAINT [FK_ContactRoles_Contacts] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[ContactRoles] ADD CONSTRAINT [FK_ContactRoles_GeneralObjects] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[GeneralObjects] ([ObjectId])
GO
