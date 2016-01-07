CREATE TABLE [dbo].[JobsDeliveryErrors]
(
[DeliveryErrorId] [int] NOT NULL IDENTITY(1, 1),
[JobId] [bigint] NOT NULL,
[DeliveryRuleId] [int] NULL,
[ErrorStatus] [smallint] NOT NULL,
[ErrorMessage] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionMessage] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstAttempt] [datetime] NOT NULL,
[ChangedOn] [datetime] NOT NULL,
[ErrorCode] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsDeliveryErrors] ADD CONSTRAINT [PK_JobsDeliveryErrors] PRIMARY KEY CLUSTERED  ([DeliveryErrorId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobsDeliveryErrors_JobId_ErrorStatus_ErrorMessage] ON [dbo].[JobsDeliveryErrors] ([JobId], [ErrorStatus], [ErrorMessage]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsDeliveryErrors] ADD CONSTRAINT [FK_JobsDeliveryErrors_Jobs] FOREIGN KEY ([JobId]) REFERENCES [dbo].[Jobs] ([JobID])
GO
