CREATE TABLE [dbo].[ClinicDocuments]
(
[ClinicDocumentID] [int] NOT NULL IDENTITY(1, 1),
[ClinicId] [smallint] NOT NULL,
[DocumentFile] [varbinary] (max) NOT NULL,
[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsAccountSpecific] [bit] NOT NULL CONSTRAINT [DF_ClinicDocuments_IsAccountSpecific] DEFAULT ((0)),
[DateCreated] [datetime] NOT NULL,
[DateUpdated] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClinicDocuments] ADD CONSTRAINT [PK_ClinicDocuments] PRIMARY KEY CLUSTERED  ([ClinicDocumentID]) ON [PRIMARY]
GO
