CREATE TABLE [dbo].[RangeOptions]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RangeOption] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OptionType] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RangeOptions] ADD CONSTRAINT [PK_RangeOptions] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO