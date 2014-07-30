CREATE TABLE [dbo].[DocumentSignatureRules]
(
[DocSignatureRuleId] [int] NOT NULL,
[DocSignatureRuleType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClinicRuleID] [smallint] NOT NULL,
[LocationRuleID] [smallint] NOT NULL,
[JobTypeRule] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReviewerDictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SignerDictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReviewerStampLocation] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DocumentSignatureRules_ReviewerLocation] DEFAULT ('B'),
[SignerStampLocation] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DocumentSignatureRules_SignerLocation] DEFAULT ('B'),
[ReviewerStamp] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DocumentSignatureRules_ReviewerStamp] DEFAULT (''),
[SignerStamp] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DocumentSignatureRules_SignerStamp] DEFAULT (''),
[SignerUnsignStamp] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DocumentSignatureRules_SignerStamp1] DEFAULT (''),
[DocSignatureRuleStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentSignatureRules] ADD CONSTRAINT [PK_DocumentSignatureRules] PRIMARY KEY CLUSTERED  ([DocSignatureRuleId]) ON [PRIMARY]
GO
