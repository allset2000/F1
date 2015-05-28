CREATE TABLE dbo.SREEngineType
            (
            SRETypeId int NOT NULL,
            SREType varchar(30) NULL
            ) ON [PRIMARY]
GO
ALTER TABLE [dbo].SREEngineType ADD CONSTRAINT [pk_SRETypeId] PRIMARY KEY CLUSTERED  (SRETypeId) ON [PRIMARY]
