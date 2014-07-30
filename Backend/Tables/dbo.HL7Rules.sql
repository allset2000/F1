CREATE TABLE [dbo].[HL7Rules]
(
[ClinicID] [smallint] NULL,
[LocationID] [smallint] NULL,
[DictatorName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldData] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
