ALTER TABLE dbo.FactSponsorship
ADD NationalityID INT NULL, VisaCategoryID INT NULL;
GO

-- map nationality
UPDATE f
SET NationalityID = n.NationalityID
FROM dbo.FactSponsorship f
LEFT JOIN dbo.DimNationality n
  ON LTRIM(RTRIM(f.Nationality)) = n.NationalityName;

-- map visa category
UPDATE f
SET VisaCategoryID = v.VisaCategoryID
FROM dbo.FactSponsorship f
LEFT JOIN dbo.DimVisaCategory v
  ON f.SourceDataset = v.SourceDataset
  AND ISNULL(f.Category,'') = ISNULL(v.Category,'')
  AND ISNULL(f.SubCategory,'') = ISNULL(v.SubCategory,'');
GO
