CREATE TABLE [dbo].[Dictators_AutoText]
(
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AutoText_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AutoText_Content] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators_AutoText] ADD CONSTRAINT [PK_Dictators_AutoText] PRIMARY KEY CLUSTERED  ([DictatorID], [AutoText_Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators_AutoText] ADD CONSTRAINT [FK_Dictators_AutoText_Dictators] FOREIGN KEY ([DictatorID]) REFERENCES [dbo].[Dictators] ([DictatorID])
GO
