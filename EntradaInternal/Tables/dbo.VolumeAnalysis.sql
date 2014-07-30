CREATE TABLE [dbo].[VolumeAnalysis]
(
[Facility] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExamDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExamStartTime] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExamEndTime] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccessionNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Modality] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Procedure] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExamStatus] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Day] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineCount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
