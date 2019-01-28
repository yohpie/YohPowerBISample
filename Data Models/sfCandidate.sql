WITH Opportunity AS
(
   SELECT o."Opportunity ID" AS OpportunityID, 
          o."Created Date" AS OpportunityDate,
          o."Account ID" AS AccountID, 
          o."Participant Status" AS ParticipantStatus,
          o.Status AS OpportunityStatus, 
          O.fitbitenrollmentstatus,
          o."Fulfillment ID" AS FullfillmentID,
          o."Program Code" AS ProgramCode, 
          o.srckeyfieldnm1 AS SrcKeyFieldNm1,
          o.srckeyid1 AS SrcKeyID1,
          o."Recruiting Method" AS RecruitingMethod,
          o."Enrollment Channel" AS EnrollmentMethod,
          o.dayssincelastsync AS DaysSinceLastSync,
          o."First Data Sync Date / Time" AS FirstSyncDateTime,
          o."No Data Sync Ever" AS NoDataSyncEver,
          o."Last Sync Date Time" AS LastSyncDateTime,
          o."Last Step Minute" AS LastStepMinute,
          o."Total Coaching Calls" AS TotalCoachingCalls,
          o."Is Eligible for SPE?" AS SPEEligible,
          Row_Number() OVER (PARTITION BY o."Account ID" ORDER BY o."Created Date" desc) AS RowNo
     FROM salesforce.opportunity o
    WHERE o."Primary Treatment Description" IS NOT NULL
      AND o."Cohort Description" = 'Glucose Management Program'           
      AND o.deleted IS FALSE
      AND o."Test Record" IS FALSE
      --AND o."Program Code" in ('T2D-UHC AL Individual','T2D-UHC AL Group', 'T2D-UHC GA Group', 'T2D-UHC GA Individual')  
),
 Candidate AS
(
   SELECT ld.id18 AS CandidateID, 
          ld."Created Date" AS CreatedDate,
          ld."Converted Date" AS ConvertedDate, 
          ld."Time Zone" AS TimeZone, 
          ld."Cohort Description" AS CohortDescription,
          ld."Primary Treatment Description" AS Lead_PrimaryTreatmentDescription, 
          ld."Secondary Treatment Description" AS Lead_SecondaryTreatmentDescription, 
          ld."Program Code" AS ProgramCode, 
          ld."Patient Source" AS PatientSource,
          ld."Candidate Source" AS CandidateSource,
          ld."Candidate Status" AS CandidateStatus,
          ld."Primary Phone" AS PrimaryPhone,
          ld.srckeyfieldnm1 AS SrcKeyFieldNm1,
          ld.srckeyid1 AS SrcKeyID1,
          
          a."Account ID" AS AccountID,
          a."Created Date" AS EnrollmentDate,
          a."Do Not Call"AS DoNotCall, 
          a."Program Code" AS ProgramCode, 
          a."Participant ID" AS Acct_ParticipantID, 
          a."External Member ID" AS ExternalMemberID, 
          CASE WHEN a."GMP ID" = '"Duplicate EmailAddress"' THEN NULL ELSE a."GMP ID" END AS GMPMemberID,
          a."Studybase Participant ID" AS StudybaseParticipantID,
          
          o.OpportunityID, 
          o.OpportunityDate,
          o.ParticipantStatus,
          o.OpportunityStatus, 
          O.fitbitenrollmentstatus,
          o.FullfillmentID,
          o.srckeyfieldnm1 AS SrcKeyFieldNm1,
          o.srckeyid1 AS SrcKeyID1,
          o.RecruitingMethod,
          o.EnrollmentMethod,
          o.DaysSinceLastSync,
          o.FirstSyncDateTime,
          o.NoDataSyncEver,
          o.LastSyncDateTime,
          o.LastStepMinute,
          o.TotalCoachingCalls,
          o.SPEEligible,
          Row_Number() OVER (PARTITION BY ld.id18 ORDER BY ld."Created Date") AS RowNo
     FROM salesforce.lead AS ld 
          LEFT OUTER JOIN salesforce.account AS a ON a."Candidate ID" = ld.id18 -- ld."Converted Account ID"  = a."Account ID"
                                                 AND a.deleted IS FALSE
	                                         AND a."Test Record" IS FALSE
          LEFT OUTER JOIN Opportunity AS o on a."Account ID" = o.AccountID AND o.RowNo = 1
          
    WHERE ld."Cohort Description" = 'Glucose Management Program'
      AND ld."Primary Treatment Description" IN ('GMP - AL Individual','GMP - AL PEEHIP')
      AND ld."Test Record" IS FALSE
      AND ld.Deleted IS FALSE
      --AND ld."Program Code" in ('T2D-UHC AL Individual','T2D-UHC AL Group', 'T2D-UHC GA Group', 'T2D-UHC GA Individual') 
      
      
    ORDER BY ld."Candidate ID"	  
)

SELECT *
  FROM Candidate c
 WHERE RowNo = 1
 