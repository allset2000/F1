CREATE TABLE [dbo].[Queue_Dictators]
(
[Queue_ID] [smallint] NOT NULL,
[ClinicID] [smallint] NULL CONSTRAINT [DF_Queue_Dictators_ClinicID] DEFAULT ((0)),
[Location] [smallint] NULL CONSTRAINT [DF_Queue_Dictators_Location] DEFAULT ((0)),
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Queue_Dictators_DictatorID] DEFAULT (''),
[Filter] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queue_Dictators] ADD CONSTRAINT [FK_Queue_Dictators_Queue_Names] FOREIGN KEY ([Queue_ID]) REFERENCES [dbo].[Queue_Names] ([QueueID])
GO
