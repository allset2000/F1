CREATE TABLE [dbo].[JobsToDeliverErrors]
(
[ErrorDeliveryId] [int] NOT NULL IDENTITY(1, 1),
[ConfigurationName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryId] [int] NULL,
[ErrorId] [smallint] NULL,
[ErrorDate] [datetime] NOT NULL CONSTRAINT [DF_JobsToDeliverErrors_ErrorDate] DEFAULT (getdate()),
[Message] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionMessage] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StackTrace] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_JobsToDeliverErrors_DeliveryID] ON [dbo].[JobsToDeliverErrors] ([DeliveryId], [ErrorDeliveryId]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobsToDeliverErrors_ErrorDate] ON [dbo].[JobsToDeliverErrors] ([ErrorDate]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobsToDeliverErrors] ON [dbo].[JobsToDeliverErrors] ([ErrorDeliveryId]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_ErrorMessage_INC] ON [dbo].[JobsToDeliverErrors] ([ErrorMessage]) INCLUDE ([DeliveryId]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[JobsToDeliverErrors] ADD CONSTRAINT [PK_JobsToDeliverErrors] PRIMARY KEY CLUSTERED  ([ErrorDeliveryId]) ON [PRIMARY]
GO
