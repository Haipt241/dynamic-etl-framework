ALTER TABLE evadb_stage.c1754_xeroblue_journals
ADD INDEX c1754_xeroblue_journals_OrgIDTC1IdTC1OId_idx (OrganisationID, LineItem_TrackingCategory1_CategoryId, LineItem_TrackingCategory1_OptionId);


ALTER TABLE evadb_stage.c1754_xeroblue_journals
ADD INDEX c1754_xeroblue_journals_OrgIDTC2IdTC2OId_idx (OrganisationID, LineItem_TrackingCategory2_CategoryId, LineItem_TrackingCategory2_OptionId);


UPDATE c1754_xeroblue_journals j
JOIN c1754_xeroblue_TrackingCategories tc
ON j.LineItem_TrackingCategory1_CategoryId  = tc.TrackingCategoryId
AND j.LineItem_TrackingCategory1_OptionId  = tc.TrackingOptionId
AND J.OrganisationID = tc.OrganisationID
SET
  j.LineItem_TrackingCategory1_OptionName = tc.OptionName
WHERE j.LineItem_TrackingCategory1_OptionName <> tc.OptionName;

UPDATE c1754_xeroblue_journals j
JOIN c1754_xeroblue_TrackingCategories tc
ON j.LineItem_TrackingCategory2_CategoryId  = tc.TrackingCategoryId
AND j.LineItem_TrackingCategory2_OptionId  = tc.TrackingOptionId
AND J.OrganisationID = tc.OrganisationID
SET
  j.LineItem_TrackingCategory2_OptionName = tc.OptionName
WHERE j.LineItem_TrackingCategory2_OptionName <> tc.OptionName;



ALTER TABLE evadb_stage.c1754_xeroblue_journalscash
ADD INDEX c1754_xeroblue_journals_OrgIDTC1IdTC1OId_idx (OrganisationID, LineItem_TrackingCategory1_CategoryId, LineItem_TrackingCategory1_OptionId);


ALTER TABLE evadb_stage.c1754_xeroblue_journalscash
ADD INDEX c1754_xeroblue_journals_OrgIDTC2IdTC2OId_idx (OrganisationID, LineItem_TrackingCategory2_CategoryId, LineItem_TrackingCategory2_OptionId);


UPDATE c1754_xeroblue_journalscash j
JOIN c1754_xeroblue_TrackingCategories tc
ON j.LineItem_TrackingCategory1_CategoryId  = tc.TrackingCategoryId
AND j.LineItem_TrackingCategory1_OptionId  = tc.TrackingOptionId
AND J.OrganisationID = tc.OrganisationID
SET
  j.LineItem_TrackingCategory1_OptionName = tc.OptionName
WHERE j.LineItem_TrackingCategory1_OptionName <> tc.OptionName;

UPDATE c1754_xeroblue_journalscash j
JOIN c1754_xeroblue_TrackingCategories tc
ON j.LineItem_TrackingCategory2_CategoryId  = tc.TrackingCategoryId
AND j.LineItem_TrackingCategory2_OptionId  = tc.TrackingOptionId
AND J.OrganisationID = tc.OrganisationID
SET
  j.LineItem_TrackingCategory2_OptionName = tc.OptionName
WHERE j.LineItem_TrackingCategory2_OptionName <> tc.OptionName;