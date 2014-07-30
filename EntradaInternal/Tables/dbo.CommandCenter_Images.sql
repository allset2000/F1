CREATE TABLE [dbo].[CommandCenter_Images]
(
[bintImageID] [bigint] NOT NULL IDENTITY(1, 1),
[sImageName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[iImage] [image] NOT NULL,
[bitActive] [bit] NOT NULL CONSTRAINT [DF_CommandCenter_Images_bitActive] DEFAULT ((1)),
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_CommandCenter_Images_dteCreated] DEFAULT (getdate()),
[dteModified] [datetime] NOT NULL CONSTRAINT [DF_CommandCenter_Images_dteModified] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
