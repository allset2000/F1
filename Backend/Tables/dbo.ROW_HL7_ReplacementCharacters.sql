CREATE TABLE [dbo].[ROW_HL7_ReplacementCharacters]
(
[SourceCharacter] [int] NOT NULL,
[Destination] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROW_HL7_ReplacementCharacters] ADD CONSTRAINT [PK_ROW_HL7_ReplacementCharacters] PRIMARY KEY CLUSTERED  ([SourceCharacter]) ON [PRIMARY]
GO
