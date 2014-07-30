CREATE TABLE [dbo].[MonitoringThreshold]
(
[Status] [smallint] NOT NULL,
[NumJobs] [int] NULL,
[NumMinutes] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MonitoringThreshold] ADD CONSTRAINT [PK_MonitoringThreshold] PRIMARY KEY CLUSTERED  ([Status]) ON [PRIMARY]
GO
