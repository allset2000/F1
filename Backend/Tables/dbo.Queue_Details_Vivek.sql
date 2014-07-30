CREATE TABLE [dbo].[Queue_Details_Vivek]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [int] NULL,
[Location] [int] NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queue_Details_Vivek] ADD CONSTRAINT [PK_Queue_Details_Vivek] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Queue_Details_Vivek] ON [dbo].[Queue_Details_Vivek] ([ClinicID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Queue_Details_Vivek_1] ON [dbo].[Queue_Details_Vivek] ([Location]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Queue_Details_Vivek_2] ON [dbo].[Queue_Details_Vivek] ([Location]) ON [PRIMARY]
GO
