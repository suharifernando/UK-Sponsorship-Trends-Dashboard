-- Create FactSponsorship (simple)
IF OBJECT_ID('dbo.FactSponsorship','U') IS NOT NULL DROP TABLE dbo.FactSponsorship;
CREATE TABLE dbo.FactSponsorship (
  FactID INT IDENTITY(1,1) PRIMARY KEY,
  Year INT NULL,
  Quarter NVARCHAR(50) NULL,
  DateKey INT NULL,
  SourceDataset NVARCHAR(20) NULL, -- 'Study' or 'Work'
  TypeOfApplication NVARCHAR(200) NULL,
  Category NVARCHAR(300) NULL,
  SubCategory NVARCHAR(300) NULL,
  GeographicalRegion NVARCHAR(200) NULL,
  Nationality NVARCHAR(200) NULL,
  Applications INT NULL,
  InsertedOn DATETIME DEFAULT GETDATE()
);

-- Insert from study CAS_D01 (institution type)
INSERT INTO dbo.FactSponsorship(Year, Quarter, SourceDataset, TypeOfApplication, Category, SubCategory, Applications)
SELECT TRY_CAST(Year AS INT), Quarter, 'Study', Type_of_application, Institution_type_group, Institution_type, TRY_CAST(Applications AS INT)
FROM dbo.CAS_D01
WHERE ISNULL(TRY_CAST(Applications AS INT),0) <> 0;

-- Insert from study CAS_D02 (nationality)
INSERT INTO dbo.FactSponsorship(Year, Quarter, SourceDataset, TypeOfApplication, Category, GeographicalRegion, Nationality, Applications)
SELECT TRY_CAST(Year AS INT), Quarter, 'Study', Type_of_application, Institution_type_group, Geographical_region, Nationality, TRY_CAST(Applications AS INT)
FROM dbo.CAS_D02
WHERE ISNULL(TRY_CAST(Applications AS INT),0) <> 0;

-- Insert from work CoS_D01
INSERT INTO dbo.FactSponsorship(Year, Quarter, SourceDataset, TypeOfApplication, Category, SubCategory, Applications)
SELECT TRY_CAST(Year AS INT), Quarter, 'Work', Type_of_application, Category_of_leave, Industry, TRY_CAST(Applications AS INT)
FROM dbo.CoS_D01
WHERE ISNULL(TRY_CAST(Applications AS INT),0) <> 0;

-- Insert from work CoS_D02
INSERT INTO dbo.FactSponsorship(Year, Quarter, SourceDataset, TypeOfApplication, Category, GeographicalRegion, Nationality, Applications)
SELECT TRY_CAST(Year AS INT), Quarter, 'Work', Type_of_application, Category_of_leave, Geographical_region, Nationality, TRY_CAST(Applications AS INT)
FROM dbo.CoS_D02
WHERE ISNULL(TRY_CAST(Applications AS INT),0) <> 0;
