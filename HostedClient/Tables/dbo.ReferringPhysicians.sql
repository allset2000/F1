CREATE TABLE [dbo].[ReferringPhysicians]
(
[ReferringID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[PhysicianID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_FirstName] DEFAULT (''),
[MI] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_MI] DEFAULT (''),
[LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_LastName] DEFAULT (''),
[Suffix] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_Suffix] DEFAULT (''),
[Gender] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_Gender] DEFAULT (''),
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_Address1] DEFAULT (''),
[Address2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_Address2] DEFAULT (''),
[City] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_City] DEFAULT (''),
[State] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_State] DEFAULT (''),
[Zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_Zip] DEFAULT (''),
[Phone1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_Phone1] DEFAULT (''),
[Phone2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_Phone2] DEFAULT (''),
[DOB] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_DOB] DEFAULT (''),
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_SSN] DEFAULT (''),
[Fax1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_Fax1] DEFAULT (''),
[Fax2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RP_Fax2] DEFAULT ('')
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ReferringPhysicians] ON [dbo].[ReferringPhysicians] ([ClinicID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_ReferringPhysicians_1] ON [dbo].[ReferringPhysicians] ([PhysicianID]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ReferringPhysicians] ADD CONSTRAINT [PK_ReferringPhysicians] PRIMARY KEY CLUSTERED  ([ReferringID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReferringPhysicians] ADD CONSTRAINT [FK_ReferringPhysicians_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID]) ON DELETE CASCADE
GO
