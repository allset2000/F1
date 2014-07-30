CREATE TABLE [dbo].[HVRSite]
(
[SiteID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SiteName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HVRSite] ADD CONSTRAINT [PK_HVRSiteID] PRIMARY KEY CLUSTERED  ([SiteID]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[HVRSite] TO [carnold]
GRANT UPDATE ON  [dbo].[HVRSite] TO [carnold]
GO
