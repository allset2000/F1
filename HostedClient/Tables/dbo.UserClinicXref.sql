CREATE TABLE [dbo].[UserClinicXref]
(
[UserClinicXrefID] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[ClinicId] [smallint] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_UserClinicXref_Deleted] DEFAULT ((0))
) ON [PRIMARY]
ALTER TABLE [dbo].[UserClinicXref] ADD 
CONSTRAINT [PK_UserClinicXref] PRIMARY KEY CLUSTERED  ([UserClinicXrefID]) ON [PRIMARY]
ALTER TABLE [dbo].[UserClinicXref] ADD
CONSTRAINT [FK_UserClinicXref_Clinics] FOREIGN KEY ([ClinicId]) REFERENCES [dbo].[Clinics] ([ClinicID])
ALTER TABLE [dbo].[UserClinicXref] ADD
CONSTRAINT [FK_UserClinicXref_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserID])
GO
