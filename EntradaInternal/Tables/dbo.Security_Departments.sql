CREATE TABLE [dbo].[Security_Departments]
(
[intDepartmentID] [int] NOT NULL IDENTITY(1, 1),
[sDepartmentName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sDepartmentDesc] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bitActive] [bit] NOT NULL CONSTRAINT [DF_Security_Departments_bitActive] DEFAULT ((1)),
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_Security_Departments_dteCreated] DEFAULT (getdate()),
[dteModified] [datetime] NOT NULL CONSTRAINT [DF_Security_Departments_dteModified] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
