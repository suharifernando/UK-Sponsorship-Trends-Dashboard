-- 1. Missing Nationality or Category
SELECT COUNT(*) AS MissingNationality FROM dbo.FactSponsorship WHERE ISNULL(Nationality,'')='';
SELECT COUNT(*) AS MissingCategory FROM dbo.FactSponsorship WHERE ISNULL(Category,'')='';

-- 2. Rows with NULL DateKey
SELECT COUNT(*) AS MissingDateKey FROM dbo.FactSponsorship WHERE DateKey IS NULL;

-- 3. Check negative/zero Applications
SELECT COUNT(*) AS ZeroOrNegative FROM dbo.FactSponsorship WHERE ISNULL(Applications,0) <= 0;

-- 4. Top nationalities (sanity)
SELECT TOP 20 Nationality, SUM(Applications) AS Total FROM dbo.FactSponsorship
WHERE ISNULL(Nationality,'') <> ''
GROUP BY Nationality ORDER BY Total DESC;

