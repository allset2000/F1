CREATE TABLE [dbo].[JobStatusDashboard]
(
[StatusID] [bigint] NOT NULL IDENTITY(1, 1),
[Timestamp] [datetime] NOT NULL CONSTRAINT [DF_JobStatusDashboard_Timestamp] DEFAULT (getdate()),
[Code100] [int] NOT NULL,
[Code110] [int] NOT NULL,
[Code120] [int] NOT NULL,
[Code130] [int] NOT NULL,
[Code140] [int] NOT NULL,
[Code150] [int] NOT NULL,
[Code160] [int] NOT NULL,
[Code170] [int] NOT NULL,
[Code180] [int] NOT NULL,
[Code190] [int] NOT NULL,
[Code200] [int] NOT NULL,
[Code230] [int] NOT NULL,
[Code240] [int] NOT NULL,
[Code250] [int] NOT NULL,
[Code260] [int] NOT NULL,
[Code270] [int] NOT NULL,
[Code280] [int] NOT NULL,
[Code290] [int] NOT NULL,
[Code300] [int] NOT NULL,
[Code310] [int] NOT NULL,
[Code320] [int] NOT NULL,
[Code330] [int] NOT NULL,
[Code340] [int] NOT NULL,
[Code350] [int] NOT NULL,
[Code360] [int] NOT NULL,
[Code500] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobStatusDashboard] ADD CONSTRAINT [PK_JobStatusDashboard] PRIMARY KEY CLUSTERED  ([StatusID]) ON [PRIMARY]
GO
