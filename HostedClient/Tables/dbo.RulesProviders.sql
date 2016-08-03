CREATE TABLE [dbo].[RulesProviders]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[EHRCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDateInUTC] [datetime] NULL CONSTRAINT [DF_RulesProviders_UpdatedDateInUTC] DEFAULT (getutcdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesProviders] ADD CONSTRAINT [PK_RulesProviders] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UN_Providers_Clinic_EHRCode] ON [dbo].[RulesProviders] ([ClinicID], [EHRCode]) INCLUDE ([Description], [UpdatedDateInUTC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RulesProviders_EHRCode] ON [dbo].[RulesProviders] ([EHRCode]) ON [PRIMARY]
GO
