CREATE TABLE dbo.SREEngineType
            (
            SRETypeId int NOT NULL,
            SREType varchar(30) NULL
            ) ON [PRIMARY]
GO
ALTER TABLE [dbo].SREEngineType ADD CONSTRAINT [PK_SREEngineType] PRIMARY KEY CLUSTERED  (SRETypeId) ON [PRIMARY]
GO 
ALTER TABLE dbo.Clinics ADD SRETypeId int null CONSTRAINT fk_clinic_SRETypeId FOREIGN KEY (SRETypeId) REFERENCES SREEngineType (SRETypeId)
GO
ALTER TABLE dbo.Dictators ADD SRETypeId int null CONSTRAINT fk_dictators_SRETypeId FOREIGN KEY (SRETypeId) REFERENCES SREEngineType (SRETypeId)
GO

