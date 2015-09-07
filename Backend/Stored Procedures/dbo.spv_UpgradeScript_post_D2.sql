SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Narender
-- Create date: 20/08/2015
-- Description: SP Used to store Backend data changes in the D2 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_D2]
AS
BEGIN
--BEGIN #3770 and 3774#
	-- Data for [JobStatusGroup]
	IF NOT EXISTS(select * from JobStatusGroup where Id = 1 and StatusGroup = N'In Process')
		BEGIN
			INSERT [dbo].[JobStatusGroup] ([StatusGroup]) VALUES (N'In Process')
		END
	IF NOT EXISTS(select * from JobStatusGroup where Id = 2 and StatusGroup = N'Available for CR')
		BEGIN
			INSERT [dbo].[JobStatusGroup] ([StatusGroup]) VALUES ( N'Available for CR')
		END
	IF NOT EXISTS(select * from JobStatusGroup where Id = 3 and StatusGroup = N'Corrected By CR')
		BEGIN
			INSERT [dbo].[JobStatusGroup] ([StatusGroup]) VALUES (N'Corrected By CR')
		End
	IF NOT EXISTS(select * from JobStatusGroup where Id = 4 and StatusGroup = N'Editing Complete')
		BEGIN
			INSERT [dbo].[JobStatusGroup] ([StatusGroup]) VALUES ( N'Editing Complete')
		End
	IF NOT EXISTS(select * from JobStatusGroup where Id = 5 and StatusGroup = N'Delivered')
		BEGIN
			INSERT [dbo].[JobStatusGroup] ([StatusGroup]) VALUES ( N'Delivered')
		End
	-- End of Data for [JobStatusGroup]

	-- Data for [PortalJobReportAvailableColumns]
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 1 and Name = N'MRN')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'MRN', N'', NULL)
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 2 and Name = N'Patient')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES (N'Patient', N'', NULL)
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 3 and Name = N'In Process')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'In Process', N'120px', N'{0:dd-MMM-yyyy hh:mm:ss tt}')
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 4 and Name = N'Appointment Date')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'Appointment Date', N'130px', N'{0:dd-MMM-yyyy hh:mm:ss tt}')
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 5 and Name = N'Job Number')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'Job Number', N'100px', NULL)
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 6 and Name = N'Job Status')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'Job Status', N'', NULL)
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 7 and Name = N'Job Type')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'Job Type', N'', NULL)
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 8 and Name = N'Dictator ID')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'Dictator ID', N'', NULL)
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 9 and Name = N'Editing Complete')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'Editing Complete', N'120px', N'{0:dd-MMM-yyyy hh:mm:ss tt}')
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 10 and Name = N'Device Generated')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'Device Generated', N'120px', NULL)
		END
	-- End of Data for [PortalJobReportAvailableColumns]
	
	-- Data for [RangeOptions]
	IF NOT EXISTS(select * from RangeOptions where Id = 1 and RangeOption = N'Last 1-6 Hrs' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES ( N'Last 1-6 Hrs', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 2 and RangeOption = N'Last 7-12 Hrs' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES ( N'Last 7-12 Hrs', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 3 and RangeOption = N'Last 13-18 Hrs' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES ( N'Last 13-18 Hrs', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 4 and RangeOption = N'Last 19-24 Hrs' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES (N'Last 19-24 Hrs', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 5 and RangeOption = N'Today' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES (N'Today', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 6 and RangeOption = N'Yesterday' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES ( N'Yesterday', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 7 and RangeOption = N'Last 7 Days' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES (N'Last 7 Days', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 8 and RangeOption = N'Last 30 Days' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES (N'Last 30 Days', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 9 and RangeOption = N'Last 60 Days' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES ( N'Last 60 Days', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 10 and RangeOption = N'Last 90 Days' and OptionType = N'D')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES ( N'Last 90 Days', N'D')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 11 and RangeOption = N'This Week' and OptionType = N'W')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES ( N'This Week', N'W')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 12 and RangeOption = N'Last Week' and OptionType = N'W')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES (N'Last Week', N'W')
		END
	IF NOT EXISTS(select * from RangeOptions where Id = 13 and RangeOption = N'Custom' and OptionType = N'C')
		BEGIN
			INSERT [dbo].[RangeOptions] ([RangeOption], [OptionType]) VALUES ( N'Custom', N'C')
		END
	-- End of Data for [RangeOptions]

	-- Data for [StatusCodes]
	IF NOT EXISTS(select * from StatusCodes where StatusID = 100 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (100, N'Job Received', N'Job Received', N'', N'', N'NotStarted', N'', N'', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 110 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (110, N'Job Transcoded', N'Job Transcoded', N'', N'', N'NotStarted', N'', N'', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 115 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (115, N'Dist. Detected Job', N'Dist. Detected Job', N'', N'', N'NotStarted', N'', N'', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 120 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (120, N'Dist. Sends Job To Rec Server', N'Dist. Sends Job To Rec Server', N'', N'', N'NotStarted', N'', N'', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 130 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (130, N'Recognizer Starts', N'Recognizer Starts', N'', N'', N'NotStarted', N'', N'', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 140 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (140, N'Recognizer Finishes', N'Recognizer Finishes', N'JobAvailable', N'Editor', N'Editor', N'', N'SpeechDataProcessFolder', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 150 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (150, N'Recognition Process Failed', N'Recognition Process Failed', N'', N'', N'NotStarted', N'', N'SpeechDataErrorsFolder', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 160 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (160, N'Job Downloaded for Editing', N'Job Downloaded for Editing', N'JobDownloaded', N'Editor', N'Editor', N'Editor_ID', N'SpeechDataProcessFolder', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 170 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (170, N'Job Corrected', N'Job Corrected', N'JobReturned', N'Editor', N'Editor', N'In Process', N'SpeechDataProcessFolder', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 175 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (175, N'Demographics Updated Editor', N'Demographics Updated Editor', N'', N'', N'Editor', N'', N'SpeechDataProcessFolder', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 180 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (180, N'Job Available for QA', N'Job Available for QA', N'JobAvailable', N'QA1', N'QA', N'In Process', N'SpeechDataProcessFolder', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 190 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (190, N'Job Downloaded for QA', N'Job Downloaded for QA', N'JobDownloaded', N'QA1', N'QA', N'QA1_ID', N'SpeechDataProcessFolder', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 200 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (200, N'Job Returned from QA', N'Job Returned from QA', N'JobReturned', N'QA1', N'QA', N'In Process', N'SpeechDataProcessFolder', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 205 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (205, N'Demographics Updated QA', N'Demographics Updated QA', N'', N'', N'QA', N'', N'SpeechDataProcessFolder', 1, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 210 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (210, N'Job Available for QA2', N'Job Available for QA2', N'JobAvailable', N'QA2', N'QA', N'In Process', N'SpeechDataProcessFolder', 0, 0, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 220 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (220, N'Job Downloaded for QA2', N'Job Downloaded for QA2', N'JobDownloaded', N'QA2', N'QA', N'QA2_ID', N'SpeechDataProcessFolder', 0, 0, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 230 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (230, N'Job Returned from QA2', N'Job Returned from QA2', N'JobReturned', N'QA2', N'QA', N'In Process', N'SpeechDataProcessFolder', 0, 0, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 235 and StatusGroupId = 1)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (235, N'Demographics Updated QA2', N'Demographics Updated QA2', N'', N'', N'QA', N'', N'SpeechDataProcessFolder', 0, 1, 0, 1)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 240 and StatusGroupId = 2)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (240, N'Job Available for CR', N'Job Available for CR', N'JobAvailable', N'CR', N'CR', N'CR', N'SpeechDataProcessFolder', 1, 1, 0, 2)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 250 and StatusGroupId = 3)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (250, N'Job Corrected by CR', N'Job Corrected by CR', N'', N'CR', N'CR', N'CR', N'SpeechDataProcessFolder', 0, 1, 0, 3)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 260 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (260, N'Job Editing Complete', N'Job Editing Complete', N'JobEditingComplete', N'', N'Completed', N'', N'SpeechDataProcessFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 265 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (265, N'Job Editing Complete', N'Job Editing Complete', N'', N'', N'Completed', N'', N'SpeechDataProcessFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 270 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (270, N'Demographics Updated', N'Demographics Updated', N'', N'', N'Completed', N'', N'SpeechDataProcessFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 280 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (280, N'Word Document Stored', N'Word Document Stored', N'', N'', N'Completed', N'', N'SpeechDataProcessFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 290 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (290, N'Text Corrected Stored', N'Text Corrected Stored', N'', N'', N'Completed', N'', N'SpeechDataProcessFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 300 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (300, N'Temp Files Deleted', N'Temp Files Deleted', N'', N'', N'Completed', N'', N'SpeechDataProcessFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 310 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (310, N'Job Sent To Updater', N'Job Sent To Updater', N'', N'', N'Completed', N'', N'SpeechDataTransFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 315 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (315, N'Document Downloaded', N'Document Downloaded', N'', N'', N'Completed', N'', N'SpeechDataTransFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 320 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (320, N'Job Removed from SpeechDataOut', N'Job Removed from SpeechDataOut', N'', N'', N'Completed', N'', N'SpeechDataTransFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 330 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (330, N'Job Moved to Data Storage', N'Job Moved to Data Storage', N'', N'', N'Completed', N'', N'SpeechDataTransFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 340 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (340, N'Job Forked', N'Job Forked', N'', N'', N'Completed', N'', N'SpeechDataTransFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 350 and StatusGroupId = 4)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (350, N'Job Removed from SpeechDataUpdated', N'Job Removed from SpeechDataUpdated', N'', N'', N'Completed', N'', N'SpeechDataFinishFolder', 0, 1, 0, 4)
		END
	IF NOT EXISTS(select * from StatusCodes where StatusID = 360 and StatusGroupId = 5)
		BEGIN
			INSERT [dbo].[StatusCodes] ([StatusID], [StatusName], [FriendlyStatusName], [StatusClass], [StatusStage], [EditionStage], [CurrentEditorRule], [SpeechFolderTag], [IsActiveJobStatus], [IsJobSearchStatus], [IsSpecialCaseStatus], [StatusGroupId]) 
			VALUES (360, N'Job Complete', N'Job Complete', N'', N'', N'Completed', N'', N'SpeechDataFinishFolder', 0, 1, 0, 5)
		END
	-- End of Data for [StatusCodes]

--END #3770 and 3774#
END
