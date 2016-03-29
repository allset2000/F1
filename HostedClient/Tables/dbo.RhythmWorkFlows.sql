CREATE TABLE [dbo].[RhythmWorkFlows]
(
[RhythmWorkFlowID] [int] NOT NULL,
[RhythmWorkFlowName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RhythmWorkFlows] ADD CONSTRAINT [PK_RhythmWorkFlows] PRIMARY KEY CLUSTERED  ([RhythmWorkFlowID]) ON [PRIMARY]
GO
