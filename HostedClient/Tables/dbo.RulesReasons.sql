CREATE TABLE [dbo].[RulesReasons]
(
[ID] [smallint] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[EHRCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesReasons] ADD CONSTRAINT [PK_Rules_Reasons] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesReasons] ADD CONSTRAINT [UN_Reason_Clinic_EHRCode] UNIQUE NONCLUSTERED  ([ClinicID], [EHRCode]) ON [PRIMARY]
GO
