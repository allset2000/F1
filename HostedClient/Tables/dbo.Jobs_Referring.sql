CREATE TABLE [dbo].[Jobs_Referring]
(
[JobID] [bigint] NOT NULL,
[ReferringID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Referring] ADD CONSTRAINT [PK_Jobs_Referring] PRIMARY KEY CLUSTERED  ([JobID], [ReferringID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Referring] ADD CONSTRAINT [FK_Jobs_Referring_ReferringPhysicians] FOREIGN KEY ([ReferringID]) REFERENCES [dbo].[ReferringPhysicians] ([ReferringID]) ON DELETE CASCADE
GO
