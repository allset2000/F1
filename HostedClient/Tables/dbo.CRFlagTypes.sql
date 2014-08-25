CREATE TABLE [dbo].[CRFlagTypes]
(
[CRFlagType] [int] NOT NULL,
[CRFlagName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CRFlagTypes] ADD CONSTRAINT [PK_CRFlagTypes] PRIMARY KEY CLUSTERED  ([CRFlagType]) ON [PRIMARY]
GO
