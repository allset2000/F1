CREATE TABLE [dbo].[JobsDeliveryTracking]
(
[DeliveryTrackingId] [int] NOT NULL IDENTITY(1, 1),
[JobId] [bigint] NOT NULL,
[DeliveryTypeId] [int] NOT NULL,
[ApplicationId] [int] NOT NULL,
[Section] [int] NULL,
[DeliveryMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeliveryResponse] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryDate] [datetime] NOT NULL,
[ResponseDate] [datetime] NULL,
[ImageID] [bigint] NULL CONSTRAINT [DF_JobsDeliveryTracking_ImageID] DEFAULT (NULL)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
CREATE NONCLUSTERED INDEX [idx_JDT_JobIDDelTypeID] ON [dbo].[JobsDeliveryTracking] ([JobId], [DeliveryTypeId], [Section], [DeliveryTrackingId]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[JobsDeliveryTracking] ADD CONSTRAINT [PK_JobsDeliveryTracking] PRIMARY KEY CLUSTERED  ([DeliveryTrackingId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsDeliveryTracking] ADD CONSTRAINT [FK_JobsDeliveryTracking_Applications] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[JobsDeliveryTracking] ADD CONSTRAINT [FK_JobsDeliveryTracking_DeliveryTypes] FOREIGN KEY ([DeliveryTypeId]) REFERENCES [dbo].[DeliveryTypes] ([DeliveryTypeId])
GO
ALTER TABLE [dbo].[JobsDeliveryTracking] ADD CONSTRAINT [FK_JobsDeliveryTracking_Jobs] FOREIGN KEY ([JobId]) REFERENCES [dbo].[Jobs] ([JobID])
GO
