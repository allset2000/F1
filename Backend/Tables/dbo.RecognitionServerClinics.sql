CREATE TABLE [dbo].[RecognitionServerClinics]
(
[RecServerGroupId] [smallint] NOT NULL,
[ClinicID] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RecognitionServerClinics] ADD CONSTRAINT [PK_RecognitionServerClinics] PRIMARY KEY CLUSTERED  ([RecServerGroupId], [ClinicID]) ON [PRIMARY]
GO
