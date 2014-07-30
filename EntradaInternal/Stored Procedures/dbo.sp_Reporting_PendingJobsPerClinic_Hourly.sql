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
8/9/13		jablumenthal	changed the grouping for edit type per Celeste Wickman. replaced
							the hard-coding of these edit types in the report with a new
							table created for this purpose. 
11/5/13		jablumenthal	changed edit types as follows per Sue Fleming:
							Partial Edit:  Memphis Orthopaedic Group, Slocum, NRS/Neurosurgical Associates
							Full Self Edit:  Appalachian Ortho Bristol
1/23/14		jablumenthal	Added the following clinics as Full Edit per Sue Fleming:
							Athens Medical Associates, Capital Primary Care, Great River Orthopedics and Sports,
							Millard Henry Clinic, Minnesota Gastroenterology, National Breast Center,
							Prospira PainCare, River City Neuro, The Hughston Clinic, Wyckoff Hospital



New Grouping from Celeste:
Full Edit
Advanced Neuroscience Institute
Alliance Primary Care
Athens Medical Associates
Bone and Joint Clinic
Boulder Orthopedics
Capital Primary Care
Cardiology Associates of Central CT
Central Indiana Ortho
East TN Medical Group
Excela Ortho
Great River Orthopedics and Sports
Heart & Vascular Institute of Texas
Heart of San Antonio
Henry County Hospital
Howell Allen Clinic
Mid-Maryland Musculoskeletal Institute
Millard Henry Clinic 
Minnesota Gastroenterology
Muskegon Surgical Institute
National Breast Center 
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
Ortho Tennessee Physical Therapy
Otolaryngology Associates Of Tennessee 
Palm Beach Orthopaedic Institute 
Pedi Ortho at Stone Oaks
Prospira PainCare 
RadSource
River City Neuro
Rowe Neurology Institute 
South Orange County 
Southern Joint Replacement Institute
Tennessee Orthopaedic Alliance
The Hughston Clinic 
The San Antonio Orthopeadic Group 
The Surgical Clinic
Vanderbilt Ortho
Watauga Orthopaedics
West Tennessee Bone and Joint
Wyckoff Hospital

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
CREATE PROCEDURE [dbo].[sp_Reporting_PendingJobsPerClinic_Hourly] 

@CR INT

AS
BEGIN

	IF @CR = 0
		SET @CR = 120
	ELSE
		SET @CR = -999

	SELECT ISNULL(ET.EditType, 'Other') as EditType, ClinicName,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11] 
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
		left outer join EntradaInternal.dbo.Reporting_EditType ET with (nolock) ON
		Clinics.ClinicID = ET.ClinicID
	WHERE Clinics.Active='True'
	ORDER BY ClinicName
	
END

GO
