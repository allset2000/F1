CREATE TABLE [dbo].[SMContactFavorites]
(
[FavoriteID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[FavUserID] [int] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_SMContactFavorites_IsDeleted] DEFAULT ((0)),
[DateCreated] [datetime] NOT NULL,
[DateUpdated] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SMContactFavorites] ADD CONSTRAINT [PK_SMContactFavorites] PRIMARY KEY CLUSTERED  ([FavoriteID]) ON [PRIMARY]
GO
