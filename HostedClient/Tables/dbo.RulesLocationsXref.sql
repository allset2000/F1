CREATE TABLE [dbo].[RulesLocationsXref]
(
[RuleID] [smallint] NOT NULL,
[ActionID] [int] NOT NULL IDENTITY(1, 1),
[LocationID] [smallint] NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[RulesLocationsXref] ADD 
CONSTRAINT [PK_Rules_LocationsXref] PRIMARY KEY CLUSTERED  ([RuleID], [ActionID]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RulesLocationsXref] ADD CONSTRAINT [FK_RulesLocations_LocationsXref_Rules] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[RulesLocations] ([ID])
GO
ALTER TABLE [dbo].[RulesLocationsXref] ADD CONSTRAINT [FK_Rules_LocationsXref_Rules] FOREIGN KEY ([RuleID]) REFERENCES [dbo].[Rules] ([RuleID])
GO
ALTER TABLE [dbo].[RulesLocationsXref] ADD CONSTRAINT [FK_Rules_LocationXref_Rules] FOREIGN KEY ([RuleID]) REFERENCES [dbo].[Rules] ([RuleID])
GO
