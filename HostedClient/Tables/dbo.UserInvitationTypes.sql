CREATE TABLE [dbo].[UserInvitationTypes]
(
[InvitationTypeId] [int] NOT NULL IDENTITY(1, 1),
[InvitationTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserInvitationTypes] ADD CONSTRAINT [PK_UserInvitationTypes] PRIMARY KEY CLUSTERED  ([InvitationTypeId]) ON [PRIMARY]
GO
