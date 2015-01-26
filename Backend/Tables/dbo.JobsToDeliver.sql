CREATE TABLE [dbo].[JobsToDeliver]
(
[DeliveryID] [int] NOT NULL IDENTITY(1, 1),
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Method] [smallint] NOT NULL,
[RuleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_JobsToDeliver_LastUpdatedOn] DEFAULT (getdate())
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_JobsToDeliver_JobNumber] ON [dbo].[JobsToDeliver] ([JobNumber]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Method_INC] ON [dbo].[JobsToDeliver] ([Method]) INCLUDE ([DeliveryID], [JobNumber], [LastUpdatedOn], [RuleName]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[JobsToDeliver] ADD CONSTRAINT [PK_JobsToDeliver] PRIMARY KEY CLUSTERED  ([DeliveryID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsToDeliver] ADD CONSTRAINT [FK_JobsToDeliver_JobsDeliveryMethods] FOREIGN KEY ([Method]) REFERENCES [dbo].[JobsDeliveryMethods] ([JobDeliveryID])
GO
