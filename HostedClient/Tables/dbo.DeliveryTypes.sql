CREATE TABLE [dbo].[DeliveryTypes]
(
[DeliveryTypeId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeliveryTypes] ADD CONSTRAINT [PK_DeliveryTypes] PRIMARY KEY CLUSTERED  ([DeliveryTypeId]) ON [PRIMARY]
GO
