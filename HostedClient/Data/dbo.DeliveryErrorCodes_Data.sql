SET IDENTITY_INSERT [dbo].[DeliveryErrorCodes] ON
INSERT INTO [dbo].[DeliveryErrorCodes] ([DeliveryErrorCodeId], [DeliveryTypeId], [ErrorCode], [Description]) VALUES (1, 6, 101, 'Template variable ##athenaclinic## - Missing Data: EHRClinicId Missing from Clinics Table')
INSERT INTO [dbo].[DeliveryErrorCodes] ([DeliveryErrorCodeId], [DeliveryTypeId], [ErrorCode], [Description]) VALUES (2, 6, 102, 'Template variable ##encnbr## - Missing Data: EHR EncounterId missing from Schedules Table')
SET IDENTITY_INSERT [dbo].[DeliveryErrorCodes] OFF
