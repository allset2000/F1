CREATE TABLE [dbo].[RecognitionFailedJobs]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NumTries] [tinyint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RecognitionFailedJobs] ADD CONSTRAINT [PK_RecognitionFailedJobs] PRIMARY KEY CLUSTERED  ([JobNumber]) ON [PRIMARY]
GO
