SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =============================================
Author:		Charles Arnold
Create date: 3/14/2012
Description:	Retrieves pending jobs in pivot format broken down
				into an hourly basis.
				If @CR = 1, omit jobs with a Jobs.DocumentStatus of "140" (Customer Review)
				If @CR = 0, don't filter anything.
				For report "Pending Jobs Per Clinic (Hourly Analysis).rdl"

change log:

date		username		description
6/12/13		jablumenthal	divided data by self-edit, full edit & mixed clients
							per Bill Brown request.
8/9/13		jablumenthal	excluded JobStatusA.Status of 240 & 250 per request
							from Sue Fleming.
8/9/13		jablumenthal	changed the grouping for edit type per Celeste Wickman.

New Grouping from Celeste:
Full Edit
Advanced Neuroscience Institute
Alliance Primary Care
Bone and Joint Clinic
Boulder Orthopedics
Cardiology Associates of Central CT
Central Indiana Ortho
East TN Medical Group
Excela Ortho
Heart & Vascular Institute of Texas
Heart of San Antonio
Howell Allen Clinic
Mid-Maryland Musculoskeletal Institute
Muskegon Surgical Institute
Neuroscience Associates
Newport Orthopedic Institute
Northern California Orthopedic Specialists
Olympia Orthopaedic Associates
Ortho Associates of Michigan
Ortho Georgia
Ortho Tennessee KOC
Ortho Tennessee MOC 
Ortho Tennessee OSOR
Ortho Tennessee UOS
OrthoAtlanta 
Orthopaedic Associates 
Otolaryngology Associates Of Tennessee 
Palm Beach Orthopaedic Institute 
RadSource
Rowe Neurology Institute 
South Orange County 
Southern Joint Replacement Institute
Tennessee Orthopaedic Alliance
The San Antonio Orthopeadic Group 
Vanderbilt Ortho
Watauga Orthopaedics
West Tennessee Bone and Joint
Henry County Hospital
Ortho Tennessee Physical Therapy
The Surgical Clinic
Pedi Ortho at Stone Oaks

Full Self-Edit
Broadway Medical Clinic
Carolina Regional Orthopaedics
Comprehensive Cardiovascular
Memphis Orthopeadic Group
Mowery Clinic
Neurosurgical Associates
SMOC 
Slocum Center for Orthopedics & Sports Medicine
Willis-Knighton Health System


Partial Self-Edit
Advanced Heart Care 
Appalachian Orthopaedic Associates -Bristol
Appalachian Orthopaedic Associates - Johnson
Cardiovascular Associates
Carolina Medical Affiliates
Comprehensive Orthopaedics
Panorama Ortho 
St. Croix Ortho
Twin Cities Spine

============================================= */
create PROCEDURE [dbo].[archive_sp_Reporting_PendingJobsPerClinic_Hourly2] 

@CR INT

AS
BEGIN

	IF @CR = 0
		SET @CR = 120
	ELSE
		SET @CR = -999

	SELECT CASE
				WHEN Clinics.ClinicCode in ('AHC','AOA','AOA','CVA','CMA','CMC','PAN','SCO','TCS') then 'Partial Self-Edit'
				WHEN Clinics.ClinicCode in ('BMC','CRO','CCV','MOG','MWR','NRS','SMOC') then 'Full Self-Edit'
				ELSE 'Full Edit'  --anything not self-edit I am putting in full edit/jb
			END as EditType, ClinicName,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11] 
	FROM [Entrada].[dbo].Clinics 
		LEFT OUTER JOIN
			(SELECT ClinicID, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11] 
			FROM
				(SELECT Count(*) As NumJobs, ClinicID, NumCat 
				FROM
						(SELECT Jobs.JobNumber, 
						Jobs.ClinicID,
						CASE WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 360 THEN 1
							   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 720 THEN 2
							   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1080 THEN 3
							   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1440 THEN 4
							   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1440 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1680 THEN 5
							   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1680 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1920 THEN 6
							   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1920 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 2160 THEN 7
							   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 2160 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 2400 THEN 8
							   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 2400 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 2640 THEN 9
							   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 2640 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 2880 THEN 10
							  WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 2880 THEN 11
						END AS NumCat
						FROM [Entrada].[dbo].Jobs 
						INNER JOIN [Entrada].[dbo].JobStatusA ON 
							Jobs.JobNumber=JobStatusA.JobNumber 
						INNER JOIN [Entrada].[dbo].Clinics ON
							Jobs.ClinicID = Clinics.ClinicID
						WHERE (JOBS.DocumentStatus != @CR 
						   OR Jobs.DocumentStatus IS NULL)
						  and JobStatusA.[Status] not in (240, 250)) t
					GROUP BY ClinicID, NumCat) t1
				PIVOT (MAX(NumJobs) 
				FOR NumCat IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11])) pvt) C ON 
		Clinics.ClinicID=C.ClinicID
	WHERE Clinics.Active='True'
	ORDER BY ClinicName
	
END

GO
