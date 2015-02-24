CREATE TABLE [dbo].[MessageThreads]
(
[MessageThreadID] [int] NOT NULL IDENTITY(1, 1),
[ThreadID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ThreadOwnerID] [int] NOT NULL,
[ThreadOwnerClinicID] [smallint] NOT NULL,
[PatientID] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__MessageTh__IsAct__20ECC9AD] DEFAULT ((1))
) ON [PRIMARY]
ALTER TABLE [dbo].[MessageThreads] ADD 
CONSTRAINT [PK_MessageThreads] PRIMARY KEY CLUSTERED  ([MessageThreadID]) ON [PRIMARY]
ALTER TABLE [dbo].[MessageThreads] ADD
CONSTRAINT [FK_MessageThreads_Patients] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patients] ([PatientID])
GO

ALTER TABLE [dbo].[MessageThreads] ADD CONSTRAINT [FK_MessageThreads_Clinics] FOREIGN KEY ([ThreadOwnerClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
ALTER TABLE [dbo].[MessageThreads] ADD CONSTRAINT [FK_MessageThreads_Users] FOREIGN KEY ([ThreadOwnerID]) REFERENCES [dbo].[Users] ([UserID])
GO
