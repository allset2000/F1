
/****** Object:  StoredProcedure [dbo].[proc_GetDictatorsBasedonSelectedClinics]    Script Date: 9/24/2015 7:59:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************
** File:  proc_GetDictatorsBasedonSelectedClinics.sql
** Name:  proc_GetDictatorsBasedonSelectedClinics
** Desc:  Get all the dictators on userId ,that is get all the dictators to which a user is tagged
** Auth:   Tamojit Chakraborty
**************************
** Change History
******************
** Ticket       Date	    Author           Description	
** --           --------    -------          ------------------------------------
** D.2    6/8        Tamojit Chakraborty     Get all the dictators on userId ,that is get all the dictators to which a user is tagged
**
*******************************/
CREATE PROCEDURE [dbo].[proc_GetDictatorsBasedonSelectedClinics] 
 
@userid int
AS  
BEGIN 
  
	SELECT D.*,concat(C.cliniccode,D.DictatorName) as BackendDictatorID , C.Name + ' (' + CAST(C.ClinicId as varchar(10)) + ')' as 'ClinicName' ,C.ClinicID FROM Dictators D
			INNER JOIN Clinics C on C.ClinicID=D.ClinicID
			INNER JOIN UserClinicXref UCX on UCX.ClinicID=C.ClinicID
		WHERE  D.Deleted = 0 and UCX.UserID=@userid and UCX.IsDeleted=0


	
END  


