CREATE TABLE [dbo].[JobsDeliveryDeleted]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Method] [smallint] NULL,
[RuleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletedOn] [datetime] NULL
) ON [PRIMARY]
GO
