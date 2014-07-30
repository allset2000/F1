CREATE TABLE [dbo].[Document_TAT]
(
[uidDocUID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Document_TAT_uidDocUID] DEFAULT (newid()),
[intClinicID] [int] NOT NULL,
[sDocCode] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sDocType] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tintDocTAT] [tinyint] NOT NULL,
[decDocTechRate] [decimal] (18, 5) NOT NULL CONSTRAINT [DF_Document_TAT_decDocTechRate] DEFAULT ((0.03)),
[decDocEditRate] [decimal] (18, 5) NOT NULL CONSTRAINT [DF_Document_TAT_decDocEditRate] DEFAULT ((0.105)),
[decDocStatSurcharge] [decimal] (18, 5) NULL,
[decDocPenaltyAmt] [decimal] (18, 5) NOT NULL,
[intDocPenaltyTerm] [tinyint] NOT NULL CONSTRAINT [DF_Table_1_intDocPenaltyPer] DEFAULT ((1)),
[intDocPenaltyPer] [tinyint] NOT NULL CONSTRAINT [DF_Document_TAT_intDocPenaltyPer] DEFAULT ((1)),
[bitActive] [bit] NOT NULL CONSTRAINT [DF_Document_TAT_bitActive] DEFAULT ((1)),
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_Document_TAT_dteCreated] DEFAULT (getdate()),
[dteModified] [datetime] NOT NULL CONSTRAINT [DF_Document_TAT_dteModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Document_TAT] ADD CONSTRAINT [PK_Document_TAT] PRIMARY KEY CLUSTERED  ([uidDocUID]) ON [PRIMARY]
GO
