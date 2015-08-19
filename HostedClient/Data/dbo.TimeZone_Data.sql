SET IDENTITY_INSERT [dbo].[TimeZone] ON
INSERT INTO [dbo].[TimeZone] ([TimeZoneId], [TimeZoneName], [GMTOffset]) VALUES (1, 'PST', -8)
INSERT INTO [dbo].[TimeZone] ([TimeZoneId], [TimeZoneName], [GMTOffset]) VALUES (2, 'MNT', -7)
INSERT INTO [dbo].[TimeZone] ([TimeZoneId], [TimeZoneName], [GMTOffset]) VALUES (3, 'CST', -6)
INSERT INTO [dbo].[TimeZone] ([TimeZoneId], [TimeZoneName], [GMTOffset]) VALUES (4, 'EST', -5)
SET IDENTITY_INSERT [dbo].[TimeZone] OFF
