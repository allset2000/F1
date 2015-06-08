/******************************
** File:  spGetClinicById.sql
** Name:  spGetClinicById
** Desc:  Get SreTypeId of Clinic  based on clinic id
** Auth:  Suresh
** Date:  30/05/2015
**************************
** Change History
******************
** PR   Date	    Author  Description	
** --   --------   -------   ------------------------------------
** 
*******************************/
CREATE PROCEDURE [dbo].[spGetClinicById]
(
	@vintClinicId int
)
AS
BEGIN
	SELECT  SreTypeId
	FROM	Clinics
	WHERE	clinicID = @vintClinicId
END
