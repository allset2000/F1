CREATE TABLE [dbo].[ZZDictatorRelations]
(
[DictatorRelationId] [int] NOT NULL IDENTITY(1, 1),
[PrimaryDictatorId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DictatorRelations_PrimaryDictatorId] DEFAULT (''),
[SecondaryDictatorId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DictatorRelations_SecondaryDictatorId] DEFAULT ('')
) ON [PRIMARY]
GO
