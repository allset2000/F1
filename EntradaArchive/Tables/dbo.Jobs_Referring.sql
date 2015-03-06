CREATE TABLE [dbo].[Jobs_Referring]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhysicianID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MI] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sex] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClinicName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArchiveID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Referring] ADD CONSTRAINT [PK_Jobs_Physicians] PRIMARY KEY CLUSTERED  ([JobNumber] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Referring] ADD CONSTRAINT [FK_Jobs_Referring_ArchiveLog] FOREIGN KEY ([ArchiveID]) REFERENCES [dbo].[ArchiveLog] ([ArchiveID])
GO
