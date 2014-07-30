CREATE TABLE [dbo].[JobEditingTasksData]
(
[JobEditingTaskId] [int] NOT NULL,
[NumPages] [int] NOT NULL,
[NumLines] [int] NOT NULL,
[NumChars] [int] NOT NULL,
[NumVBC] [int] NOT NULL,
[NumCharsPC] [int] NOT NULL,
[BodyWSpaces] [int] NOT NULL,
[HeaderFirstWSpaces] [int] NOT NULL,
[HeaderPrimaryWSpaces] [int] NOT NULL,
[HeaderEvenWSpaces] [int] NOT NULL,
[FooterFirstWSpaces] [int] NOT NULL,
[FooterPrimaryWSpaces] [int] NOT NULL,
[FooterEvenWSpaces] [int] NOT NULL,
[HeaderTotalWSpaces] [int] NOT NULL,
[FooterTotalWSpaces] [int] NOT NULL,
[HeaderFooterTotalWSpaces] [int] NOT NULL,
[DocumentWSpaces] [int] NOT NULL,
[NumTotalMacros] [int] NOT NULL,
[NumMacrosUnEdited] [int] NOT NULL,
[NumMacrosEdited] [int] NOT NULL,
[NumCharsUnEditedMacros] [int] NOT NULL,
[NumCharsEditedMacros] [int] NOT NULL,
[NumCharsChangedMacros] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobEditingTasksData] ADD CONSTRAINT [PK_JobEditingTrackCounters] PRIMARY KEY CLUSTERED  ([JobEditingTaskId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in Document', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'BodyWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces including Headers and Footers', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'DocumentWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in Even Page Footer', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'FooterEvenWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in First Page Footer', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'FooterFirstWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in Odd Page Footer', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'FooterPrimaryWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in All Footers', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'FooterTotalWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in Even Page Header', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'HeaderEvenWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in First Page Header', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'HeaderFirstWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in Headers and Footers', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'HeaderFooterTotalWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in Odd Page Header', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'HeaderPrimaryWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters with spaces in All Headers', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'HeaderTotalWSpaces'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TaskId', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'JobEditingTaskId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters WITHOUT spaces', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumChars'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Total Characters Changed in Macros', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumCharsChangedMacros'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Total Characters of Macros after Edit is Complete', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumCharsEditedMacros'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters in PullCorrector', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumCharsPC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Total Characters of Macros without any Edit', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumCharsUnEditedMacros'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of RAW Lines', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumLines'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Macros Edited/Changed in Document', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumMacrosEdited'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Macros UnEdited/UnChanged in Document', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumMacrosUnEdited'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Pages', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumPages'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Macros in Document', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumTotalMacros'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters WITH spaces', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTasksData', 'COLUMN', N'NumVBC'
GO
