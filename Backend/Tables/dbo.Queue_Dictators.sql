CREATE TABLE [dbo].[Queue_Dictators]
(
[Queue_ID] [smallint] NOT NULL,
[ClinicID] [smallint] NULL,
[Location] [smallint] NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Queue_Dictators_DictatorID] DEFAULT (''),
[Filter] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
