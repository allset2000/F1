SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[qryGetAllJobData]
	-- Add the parameters for the stored procedure here
	@JobNumber varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT     dbo.Jobs.JobNumber, dbo.Jobs_Client.FileName, dbo.Jobs.DictatorID, dbo.Clinics.ClinicName, dbo.Jobs.AppointmentDate, dbo.Jobs.AppointmentTime, 
						  dbo.Jobs.JobType, dbo.Jobs.ContextName, dbo.Jobs.Stat, dbo.Jobs_Patients.AlternateID, dbo.Jobs_Patients.MRN, dbo.Jobs_Patients.FirstName, 
						  dbo.Jobs_Patients.MI, dbo.Jobs_Patients.LastName, dbo.Jobs_Patients.DOB, dbo.Jobs_Referring.PhysicianID, dbo.Jobs_Referring.FirstName AS Expr1, 
						  dbo.Jobs_Referring.MI AS Expr2, dbo.Jobs_Custom.Custom1, dbo.Jobs_Custom.Custom2, dbo.Jobs_Custom.Custom3, dbo.Jobs_Custom.Custom4, 
						  dbo.Jobs_Custom.Custom5, dbo.Jobs_Custom.Custom6, dbo.Jobs_Custom.Custom7, dbo.Jobs_Custom.Custom8, dbo.Jobs_Custom.Custom9, 
						  dbo.Jobs_Custom.Custom10, dbo.Jobs_Custom.Custom11, dbo.Jobs_Custom.Custom12, dbo.Jobs_Custom.Custom13, dbo.Jobs_Custom.Custom14, 
						  dbo.Jobs_Custom.Custom15, dbo.Jobs_Custom.Custom16, dbo.Jobs_Custom.Custom17, dbo.Jobs_Custom.Custom18, dbo.Jobs_Custom.Custom19, 
						  dbo.Jobs_Custom.Custom20
	FROM         dbo.Jobs_Client INNER JOIN
						  dbo.Jobs ON dbo.Jobs_Client.JobNumber = dbo.Jobs.JobNumber INNER JOIN
						  dbo.Jobs_Patients ON dbo.Jobs.JobNumber = dbo.Jobs_Patients.JobNumber INNER JOIN
						  dbo.Jobs_Referring ON dbo.Jobs.JobNumber = dbo.Jobs_Referring.JobNumber INNER JOIN
						  dbo.Jobs_Custom ON dbo.Jobs.JobNumber = dbo.Jobs_Custom.JobNumber INNER JOIN
						  dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID
	WHERE Jobs.JobNumber=@JobNumber
END
GO
