CREATE TABLE [dbo].[EditorTimesheet]
(
[TimesheetItemId] [int] NOT NULL,
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SignInTime] [datetime] NOT NULL,
[SignOffTime] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EditorTimesheet] ADD CONSTRAINT [PK_EditorTimesheet] PRIMARY KEY CLUSTERED  ([TimesheetItemId]) ON [PRIMARY]
GO
