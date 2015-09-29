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
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 1 and Name = N'Job Number')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'Job Number', N'150px', NULL)
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
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'Appointment Date', N'130px', N'{0:dd-MMM-yyyy}')
		END
	IF NOT EXISTS(select * from PortalJobReportAvailableColumns where Id = 5 and Name = N'MRN')
		BEGIN
			INSERT [dbo].[PortalJobReportAvailableColumns] ([Name], [Width], [DisplayFormat]) VALUES ( N'MRN', N'', NULL)
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
		UPDATE StatusCodes Set StatusGroupId = 1 where StatusID IN (100, 110, 115, 120, 130, 140, 150, 160, 170, 175, 180, 190, 200, 205, 210, 220, 230, 235)
		UPDATE StatusCodes Set StatusGroupId = 2 where StatusID IN (240)
		UPDATE StatusCodes Set StatusGroupId = 3 where StatusID IN (250)
		UPDATE StatusCodes Set StatusGroupId = 4 where StatusID IN (260, 265, 270, 280, 290, 300, 310, 315, 320, 330, 340, 350)
		UPDATE StatusCodes Set StatusGroupId = 5 where StatusID IN (360)
	-- End of Data for [StatusCodes]

--END #3770 and 3774#
END

GO

