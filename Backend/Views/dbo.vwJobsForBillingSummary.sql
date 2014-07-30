SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJobsForBillingSummary]
AS
SELECT     ClinicID, DictatorID, COUNT(JobId) AS JobsCount, SUM(CASE WHEN [Stat] = 1 THEN 1 ELSE 0 END) AS StatJobsCount, SUM(CASE WHEN [Stat] = 1 THEN 0 ELSE 1 END)
                       AS NoStatJobsCount, SUM(NumPages) AS NumPages, SUM(NumLines) AS NumLines, SUM(NumChars) AS NumChars, SUM(NumVBC) AS NumVBC, SUM(NumCharsPC)
                       AS NumCharsPC, SUM(BodyWSpaces) AS BodyWSpaces, SUM(HeaderFirstWSpaces) AS HeaderFirstWSpaces, SUM(HeaderPrimaryWSpaces) 
                      AS HeaderPrimaryWSpaces, SUM(HeaderEvenWSpaces) AS HeaderEvenWSpaces, SUM(FooterFirstWSpaces) AS FooterFirstWSpaces, SUM(FooterPrimaryWSpaces) 
                      AS FooterPrimaryWSpaces, SUM(FooterEvenWSpaces) AS FooterEvenWSpaces, SUM(HeaderTotalWSpaces) AS HeaderTotalWSpaces, SUM(FooterTotalWSpaces) 
                      AS FooterTotalWSpaces, SUM(HeaderFooterTotalWSpaces) AS HeaderFooterTotalWSpaces, SUM(DocumentWSpaces) AS DocumentWSpaces, SUM(NumTotalMacros) 
                      AS NumTotalMacros, SUM(NumMacrosUnEdited) AS NumMacrosUnEdited, SUM(NumMacrosEdited) AS NumMacrosEdited, SUM(NumCharsUnEditedMacros) 
                      AS NumCharsUnEditedMacros, SUM(NumCharsEditedMacros) AS NumCharsEditedMacros, SUM(NumCharsChangedMacros) AS NumCharsChangedMacros
FROM         dbo.vwJobsForBilling
GROUP BY ClinicID, DictatorID
GO
