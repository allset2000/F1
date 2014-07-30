CREATE TABLE [dbo].[Contacts]
(
[ContactId] [int] NOT NULL,
[ContactType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FullName] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FirstName] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MiddleName] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Initials] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ASPMembershipPwd] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserSettings] [varchar] (4096) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Contacts_UserSettings] DEFAULT (''),
[EMail] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContactStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SecurityToken] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Contacts_SecurityToken] DEFAULT ('')
) ON [PRIMARY]
CREATE UNIQUE NONCLUSTERED INDEX [IX_ContactsContactTypeUserID] ON [dbo].[Contacts] ([ContactType], [UserID]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Contacts] ADD CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED  ([ContactId]) ON [PRIMARY]
GO
