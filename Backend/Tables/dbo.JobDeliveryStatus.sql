CREATE TABLE [dbo].[JobDeliveryStatus]
(
[JobNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Method] [smallint] NULL,
[RuleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveredOn] [datetime] NULL
) ON [PRIMARY]
GO
