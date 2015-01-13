CREATE TABLE [dbo].[UserInvitations]
(
[UserInvitationId] [int] NOT NULL IDENTITY(1, 1),
[FirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MI] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvitationSent] [bit] NOT NULL,
[RequestingUserId] [int] NOT NULL,
[ClinicId] [int] NOT NULL,
[InvitationMethod] [int] NOT NULL,
[RoleId] [int] NULL,
[SecurityToken] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateTimeRequested] [datetime] NOT NULL,
[DateTimeInvitationSent] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserInvitations] ADD CONSTRAINT [PK_UserInvitation] PRIMARY KEY CLUSTERED  ([UserInvitationId]) ON [PRIMARY]
GO
