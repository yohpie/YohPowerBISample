SELECT c."Record ID" AS ConsentRecordID,
       c."Created Date" AS CreatedDate,
       c."Cohort Description" AS CohortDescription,
       c."Program Code" AS ProgramCode,
       c."Participant Name" AS ParticipantID,
       c."Related Opportunity" AS OpportunityID,
       c."Consent Source" AS ConsentSource,
       c."Consent Status" AS ConsentStatus 
  FROM salesforce.consent AS c
  WHERE c."Cohort Description" = 'Glucose Management Program'
    AND c."Program Code" in ('T2D-UHC AL Individual','T2D-UHC AL Group', 'T2D-UHC GA Group', 'T2D-UHC GA Individual') 
    AND c."Test Record" IS FALSE
    AND c.Deleted IS FALSE


