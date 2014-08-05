CREATE TABLE [dbo].[ROWOverrideFields]
(
[FieldID] [smallint] NOT NULL IDENTITY(1, 1),
[FieldName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EHRVendorId] [smallint] NOT NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[ROWOverrideFields] ADD
CONSTRAINT [FK_ROWOverrideFields_EHRVendor] FOREIGN KEY ([EHRVendorId]) REFERENCES [dbo].[EHRVendors] ([EHRVendorID])
ALTER TABLE [dbo].[ROWOverrideFields] ADD 
CONSTRAINT [PK_ROWOverrideFields] PRIMARY KEY CLUSTERED  ([FieldID]) ON [PRIMARY]
GO
