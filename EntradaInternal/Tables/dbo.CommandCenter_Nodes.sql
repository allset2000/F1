CREATE TABLE [dbo].[CommandCenter_Nodes]
(
[bintNodeID] [bigint] NOT NULL IDENTITY(1, 1),
[sNodeName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sNodeToolTip] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sNodeDesc] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bintParentNode] [bigint] NOT NULL,
[sImageName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CommandCenter_Tasks_bintImageID] DEFAULT ('Folder'),
[bitIsContainer] [bit] NOT NULL CONSTRAINT [DF_CommandCenter_Nodes_bitIsContainer] DEFAULT ((1)),
[bitActive] [bit] NOT NULL CONSTRAINT [DF_ControlPanel_Tasks_bitActive] DEFAULT ((1)),
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_ControlPanel_Tasks_dteCreated] DEFAULT (getdate()),
[dteModified] [datetime] NOT NULL CONSTRAINT [DF_ControlPanel_Tasks_dteModified] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
