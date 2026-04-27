USE UK_Immigration;
GO

-- 1. DimDate (if not created)
IF OBJECT_ID('dbo.DimDate','U') IS NULL
BEGIN
  CREATE TABLE dbo.DimDate(
    DateKey INT PRIMARY KEY, -- YYYYMMDD
    [Date] DATE,
    [Year] INT,
    [Month] INT,
    MonthName NVARCHAR(20),
    Quarter INT,
    YearQuarter NVARCHAR(10) -- '2010 Q1'
  );

  DECLARE @d DATE = '2008-01-01'; -- adjust start
  WHILE @d <= '2030-12-31'
  BEGIN
    INSERT INTO dbo.DimDate(DateKey,[Date],[Year],[Month],MonthName,Quarter,YearQuarter)
    VALUES (
      CONVERT(INT,CONVERT(CHAR(8),@d,112)),
      @d,
      YEAR(@d),
      MONTH(@d),
      DATENAME(MONTH,@d),
      DATEPART(QUARTER,@d),
      CONCAT(YEAR(@d),' Q', DATEPART(QUARTER,@d))
    );
    SET @d = DATEADD(DAY,1,@d);
  END
END
GO

-- 2. DimNationality
IF OBJECT_ID('dbo.DimNationality','U') IS NOT NULL DROP TABLE dbo.DimNationality;
CREATE TABLE dbo.DimNationality (
  NationalityID INT IDENTITY(1,1) PRIMARY KEY,
  NationalityName NVARCHAR(200) UNIQUE
);

INSERT INTO dbo.DimNationality(NationalityName)
SELECT DISTINCT LTRIM(RTRIM(Nationality))
FROM dbo.FactSponsorship
WHERE ISNULL(LTRIM(RTRIM(Nationality)),'') <> ''
ORDER BY 1;
GO

-- 3. DimVisaCategory (generic)
IF OBJECT_ID('dbo.DimVisaCategory','U') IS NOT NULL DROP TABLE dbo.DimVisaCategory;
CREATE TABLE dbo.DimVisaCategory (
  VisaCategoryID INT IDENTITY(1,1) PRIMARY KEY,
  SourceDataset NVARCHAR(20),
  Category NVARCHAR(300),
  SubCategory NVARCHAR(300)
);

INSERT INTO dbo.DimVisaCategory (SourceDataset, Category, SubCategory)
SELECT DISTINCT SourceDataset, Category, SubCategory
FROM dbo.FactSponsorship
WHERE ISNULL(Category,'') <> '' OR ISNULL(SubCategory,'') <> '';
GO
