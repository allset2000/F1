CREATE TABLE [dbo].[DeliveryErrorCodes]
(
[DeliveryErrorCodeId] [int] NOT NULL IDENTITY(1, 1),
[DeliveryTypeId] [int] NOT NULL,
[ErrorCode] [int] NOT NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeliveryErrorCodes] ADD CONSTRAINT [PK_DeliveryErrorCode] PRIMARY KEY CLUSTERED  ([DeliveryErrorCodeId]) ON [PRIMARY]
GO
