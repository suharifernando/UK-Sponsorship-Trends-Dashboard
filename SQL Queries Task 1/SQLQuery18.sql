CREATE INDEX IX_Fact_DateKey ON dbo.FactSponsorship(DateKey);
CREATE INDEX IX_Fact_NationalityID ON dbo.FactSponsorship(NationalityID);
CREATE INDEX IX_Fact_VisaCatID ON dbo.FactSponsorship(VisaCategoryID);
CREATE INDEX IX_Fact_Source_Year ON dbo.FactSponsorship(SourceDataset, Year);
GO
