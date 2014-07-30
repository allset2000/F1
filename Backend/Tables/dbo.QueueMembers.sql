CREATE TABLE [dbo].[QueueMembers]
(
[QueueMemberId] [int] NOT NULL,
[QueueId] [int] NOT NULL,
[ClinicId] [int] NOT NULL,
[DictatorId] [int] NOT NULL,
[JobsFilter] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QueueMemberStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QueueMembers] ADD CONSTRAINT [PK_QueueMembers] PRIMARY KEY CLUSTERED  ([QueueMemberId]) ON [PRIMARY]
GO
