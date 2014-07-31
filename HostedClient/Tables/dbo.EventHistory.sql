CREATE TABLE [dbo].[EventHistory]
(
[EventHistoryID] [bigint] NOT NULL IDENTITY(1, 1),
[JobId] [bigint] NULL,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventMessage] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Parameters] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventHistory] ADD CONSTRAINT [PK_EventHistory] PRIMARY KEY CLUSTERED  ([EventHistoryID]) ON [PRIMARY]
GO
