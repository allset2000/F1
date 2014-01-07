CREATE TABLE [dbo].[EHRVendors]
(
[EHRVendorID] [smallint] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CanAck] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EHRVendors] ADD CONSTRAINT [PK_EhrVendors] PRIMARY KEY CLUSTERED  ([EHRVendorID]) ON [PRIMARY]
GO
