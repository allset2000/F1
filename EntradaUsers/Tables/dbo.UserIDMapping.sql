CREATE TABLE [dbo].[UserIDMapping]
(
[UserId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_UserIDMapping_UserId] DEFAULT (newid()),
[UserIdOk] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserIDMapping] ADD CONSTRAINT [PK_UserIDMapping] PRIMARY KEY CLUSTERED  ([UserId]) ON [PRIMARY]
GO
