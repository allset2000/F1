CREATE TABLE [dbo].[RulesLocations]
(
[ID] [smallint] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[EHRCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesLocations] ADD CONSTRAINT [PK_Rules_Locations] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesLocations] ADD CONSTRAINT [UN_Locations_Clinic_EHRCode] UNIQUE NONCLUSTERED  ([ClinicID], [EHRCode]) ON [PRIMARY]
GO
GRANT VIEW DEFINITION ON  [dbo].[RulesLocations] TO [mmoscoso]
GRANT SELECT ON  [dbo].[RulesLocations] TO [mmoscoso]
GO
