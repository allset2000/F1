CREATE TABLE [dbo].[JobsDeliveryMethods]
(
[JobDeliveryID] [smallint] NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsDeliveryMethods] ADD CONSTRAINT [PK_JobsDeliveryMethods] PRIMARY KEY CLUSTERED  ([JobDeliveryID]) ON [PRIMARY]
GO
