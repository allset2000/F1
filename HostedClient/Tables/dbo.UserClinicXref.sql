CREATE TABLE [dbo].[UserClinicXref]
(
[UserClinicXref] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[ClinicId] [int] NOT NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_UserClinicXref_Deleted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserClinicXref] ADD CONSTRAINT [PK_UserClinicXref] PRIMARY KEY CLUSTERED  ([UserClinicXref]) ON [PRIMARY]
GO
