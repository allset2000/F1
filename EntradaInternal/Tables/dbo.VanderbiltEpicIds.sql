CREATE TABLE [dbo].[VanderbiltEpicIds]
(
[DictatorId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EpicId] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VanderbiltEpicIds] ADD CONSTRAINT [PK_VanderbiltEpicIds] PRIMARY KEY CLUSTERED  ([DictatorId]) ON [PRIMARY]
GO
