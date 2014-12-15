CREATE TABLE [dbo].[SingleSignOn]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SingleSignOnToken] [nvarchar](100) NOT NULL,
	[UserCredentials] [nvarchar](100) NOT NULL,
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SingleSignOn] ADD CONSTRAINT [PK_SingleSignOn] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO