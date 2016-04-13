CREATE TABLE [dbo].[JobDeliveryHistory]
(
[DeliveryID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Method] [smallint] NULL,
[RuleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveredOn] [datetime] NOT NULL CONSTRAINT [DF_JobDeliveryHistory_DeliveredOn] DEFAULT (getdate()),
[JobData] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Id] [int] NULL,
[JobHistoryID] [int] NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[JobDeliveryHistory] ADD 
CONSTRAINT [PK_JobDeliveryHistory] PRIMARY KEY CLUSTERED  ([DeliveryID]) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_JobNumber] ON [dbo].[JobDeliveryHistory] ([JobNumber]) ON [PRIMARY]

GO

ALTER TABLE [dbo].[JobDeliveryHistory] ADD CONSTRAINT [FK_JobDeliveryHistory_JobsDeliveryMethods] FOREIGN KEY ([Method]) REFERENCES [dbo].[JobsDeliveryMethods] ([JobDeliveryID])
GO
