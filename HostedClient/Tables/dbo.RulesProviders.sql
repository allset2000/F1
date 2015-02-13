CREATE TABLE [dbo].[RulesProviders]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[EHRCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[RulesProviders] ADD 
CONSTRAINT [PK_RulesProviders] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_RulesProviders_EHRCode] ON [dbo].[RulesProviders] ([EHRCode]) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RulesProviders] ADD CONSTRAINT [UN_Providers_Clinic_EHRCode] UNIQUE NONCLUSTERED  ([ClinicID], [EHRCode]) ON [PRIMARY]
GO
