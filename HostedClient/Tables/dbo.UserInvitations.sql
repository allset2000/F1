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
[RoleId] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityToken] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateTimeRequested] [datetime] NOT NULL,
[DateTimeInvitationSent] [datetime] NULL,
[IsDemoUser] [bit] NULL,
[RegisteredUserId] [int] NULL,
[InvitationMessage] [varchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvitationTypeId] [int] NULL,
[Deleted] [bit] NULL CONSTRAINT [DF_UserInvitations_Deleted] DEFAULT ((0))
) ON [PRIMARY]
ALTER TABLE [dbo].[UserInvitations] ADD
CONSTRAINT [FK_UserInvitations_InvitationTypeId] FOREIGN KEY ([InvitationTypeId]) REFERENCES [dbo].[UserInvitationTypes] ([InvitationTypeId])
ALTER TABLE [dbo].[UserInvitations] ADD
CONSTRAINT [FK_UserInvitations_UserInvitations] FOREIGN KEY ([UserInvitationId]) REFERENCES [dbo].[UserInvitations] ([UserInvitationId])
GO
ALTER TABLE [dbo].[UserInvitations] ADD CONSTRAINT [PK_UserInvitation] PRIMARY KEY CLUSTERED  ([UserInvitationId]) ON [PRIMARY]
GO
