SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (43, 'FNC-JOBS-UNDELETE', 'Function - Undelete Jobs from Search Screen')
SET IDENTITY_INSERT [dbo].[Permissions] OFF
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (1, 'TAB-DICT', 'Dictators Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (2, 'TAB-JOBS', 'Jobs Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (3, 'TAB-QUEU', 'Queues Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (4, 'TAB-CONFIG', 'Configuration Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (5, 'TAB-TEST', 'Test Data Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (6, 'TAB-JT', 'Job Types Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (7, 'TAB-CONS', 'Console Access Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (8, 'TAB-RULES', 'Rules Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (9, 'TAB-ENTRADA-ACCESS', 'Console Access for Entrada Administration')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (10, 'TAB-APP-EXCEPTIONS', 'Application Exceptions Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (11, 'TAB-EXPLINK', 'Configure ExpressLink Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (12, 'SHOW-DIAGNOSTICS', 'Show Diagnostics')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (13, 'TAB-J2D-ERRORS', 'JobDelivery Errors Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (14, 'TAB-SCHEDULES', 'Schedules Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (15, 'FNC-JOB-UPDATE', 'Function - Update Jobs')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (16, 'FNC-ACK-RESEND', 'Function - Resend ACKS (Athena)')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (17, 'FNC-JOB-RESEND', 'Function - Resend Job')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (18, 'TAB-JOBSTODELIVER', 'Jobs To Deliver Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (19, 'FNC-J2D-ADD', 'Function - J2D Queue jobs to be delivered')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (20, 'FNC-J2D-REMOVE', 'Function - J2D  Remove jobs')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (21, 'FNC-GREENWAY-OVERRIDE', 'Function - Override Greenway return values')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (22, 'TAB-IMPORTDATA', 'Import Data Tab')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (23, 'FNC-IMPORT-DICTATORS', 'Function - Import Dictators')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (24, 'FNC-IMPORT-LOCATIONS', 'Function - Import Locations for rules')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (25, 'FNC-IMPORT-PROVIDERS', 'Function - Import Providers for rules')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (26, 'FNC-IMPORT-REASONS', 'Function - Import Reasons for rules')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (27, 'FNC-CLINIC-ADD', 'Function - Add Clinic')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (28, 'FNC-CLINIC-ADDEXISTING', 'Function - Add Existing Clinic')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (29, 'FNC-CLINIC-EDIT', 'Function - Edit Clinic')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (30, 'TAB-BACKEND-JOBS', 'Tab - Backend Job Management')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (31, 'FNC-JOBTYPE-ADD', 'Function - Add Jobtype')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (32, 'FNC-JOBTYPE-EDIT', 'Function - Edit Jobtype')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (33, 'FNC-JOBTYPE-TAGS', 'Function - Jobtype Tag Management')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (34, 'FNC-BACKENDJOB-FIXRECFAILED', 'Function - Backend Job Fix Rec Failed')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (35, 'FNC-BACKENDJOB-RETRYREC', 'Function - Backend Job Retry Recognition')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (36, 'FNC-JOBS-CLEAR', 'Function - Clear Jobs from Search screen')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (37, 'FNC-IMPORT-FROMSCHEDULES', 'Function - Import data from scheduling messages')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (38, 'FNC-SCHEDULES-REPROCESS', 'Function - Reporcess Schedules')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (39, 'FNC-BACKENDJOB-DELETE', 'Function - Delete Backend Job')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (40, 'FNC-BACKENDJOB-UNLOCK', 'Function - Unlock Backend Job')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (41, 'FNC-BACKENDJOB-RELEASE', 'Function - Releae Backend Job')
INSERT INTO [dbo].[Permissions] ([PermissionID], [Code], [Name]) VALUES (42, 'FNC-BACKENDJOB-REPROCESS', 'Function - Reprocess Backend Job')
SET IDENTITY_INSERT [dbo].[Permissions] OFF
