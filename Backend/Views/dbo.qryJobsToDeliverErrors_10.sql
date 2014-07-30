SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[qryJobsToDeliverErrors_10] AS
SELECT ConfigurationName, DeliveryId, ErrorId, ErrorDate, Message, ErrorMessage, ExceptionMessage, StackTrace FROM (SELECT ROW_NUMBER() OVER (PARTITION BY DeliveryId ORDER BY ErrorDate DESC) AS 'RowNumber', ConfigurationName, DeliveryId, ErrorId, ErrorDate, Message, ErrorMessage, ExceptionMessage, StackTrace FROM JobsToDeliverErrors) JTE WHERE RowNumber<10
GO
