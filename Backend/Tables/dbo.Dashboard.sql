CREATE TABLE [dbo].[Dashboard]
(
[Dashboard_Id] [smallint] NOT NULL,
[Dashboard_Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dashboard_Order] [int] NOT NULL CONSTRAINT [DF_Dashboard_Dashboard_Order] DEFAULT ((0))
) ON [PRIMARY]
GO
