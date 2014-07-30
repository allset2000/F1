CREATE TABLE [dbo].[DocumentSignatures]
(
[DocumentSignatureId] [int] NOT NULL,
[AppliedDocSignatureRuleId] [int] NOT NULL,
[DocSignatureMode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DocumentId] [int] NOT NULL,
[AppliedById] [int] NOT NULL,
[ESignature] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationTime] [datetime] NOT NULL,
[CancelationTime] [datetime] NOT NULL,
[SignatureStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AppliedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentSignatures] ADD CONSTRAINT [PK_DocumentSignature] PRIMARY KEY CLUSTERED  ([DocumentSignatureId]) ON [PRIMARY]
GO
