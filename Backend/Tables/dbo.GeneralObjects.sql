CREATE TABLE [dbo].[GeneralObjects]
(
[ObjectId] [int] NOT NULL,
[ObjectType] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectUniqueKey] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_GeneralObjects_ObjectUniqueKey] DEFAULT (''),
[ObjectName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectDescription] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectStrValue1] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectStrValue2] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectStrValue3] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectStrValue4] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectStrValue5] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectIntValue1] [int] NOT NULL,
[ObjectIntValue2] [int] NOT NULL,
[ObjectIntValue3] [int] NOT NULL,
[ObjectStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GeneralObjects] ADD CONSTRAINT [PK_GeneralObjects] PRIMARY KEY CLUSTERED  ([ObjectId]) ON [PRIMARY]
GO
