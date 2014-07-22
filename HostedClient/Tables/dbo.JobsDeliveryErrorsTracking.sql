CREATE TABLE [dbo].[JobsDeliveryErrorsTracking]
(
[DeliveryErrorTrackingId] [int] NOT NULL IDENTITY(1, 1),
[DeliveryErrorId] [int] NOT NULL,
[JobId] [bigint] NOT NULL,
[DeliveryRuleId] [int] NULL,
[ErrorStatus] [smallint] NOT NULL,
[ErrorMessage] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionMessage] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangedOn] [datetime] NOT NULL,
[FirstAttempt] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsDeliveryErrorsTracking] ADD CONSTRAINT [PK_JobsDeliveryErrorsTracking] PRIMARY KEY CLUSTERED  ([DeliveryErrorTrackingId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsDeliveryErrorsTracking] ADD CONSTRAINT [FK_JobsDeliveryErrorsTracking_Jobs] FOREIGN KEY ([JobId]) REFERENCES [dbo].[Jobs] ([JobID])
GO
