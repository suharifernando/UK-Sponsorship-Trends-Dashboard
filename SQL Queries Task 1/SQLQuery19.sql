-- 1. Aggregated by Year, Quarter, Source, Nationality
IF OBJECT_ID('dbo.vw_Sponsorship_Agg_Year_Nat','V') IS NOT NULL DROP VIEW dbo.vw_Sponsorship_Agg_Year_Nat;
GO
CREATE VIEW dbo.vw_Sponsorship_Agg_Year_Nat AS
SELECT
  f.Year,
  d.YearQuarter,
  f.SourceDataset,
  f.NationalityID,
  n.NationalityName,
  f.VisaCategoryID,
  vc.Category,
  vc.SubCategory,
  SUM(f.Applications) AS Applications
FROM dbo.FactSponsorship f
LEFT JOIN dbo.DimNationality n ON f.NationalityID = n.NationalityID
LEFT JOIN dbo.DimVisaCategory vc ON f.VisaCategoryID = vc.VisaCategoryID
LEFT JOIN dbo.DimDate d ON f.DateKey = d.DateKey
GROUP BY f.Year, d.YearQuarter, f.SourceDataset, f.NationalityID, n.NationalityName, f.VisaCategoryID, vc.Category, vc.SubCategory;
GO

-- 2. Aggregated by Year & Source only
IF OBJECT_ID('dbo.vw_Sponsorship_ByYear','V') IS NOT NULL DROP VIEW dbo.vw_Sponsorship_ByYear;
GO
CREATE VIEW dbo.vw_Sponsorship_ByYear AS
SELECT Year, SourceDataset, SUM(Applications) AS TotalApplications
FROM dbo.FactSponsorship
GROUP BY Year, SourceDataset;
GO
