
WITH Qualification AS
(
   SELECT LD."Candidate ID" AS CandidateID,
          AC."Participant ID" AS ParticipantID,
          QD."Record ID" AS QualificationID,
          QD."Qualification Data Record Type ID Label" AS QualificationRecordType,        
          CASE WHEN QD."Created Date" IS NOT NULL THEN QD."Created Date"
               WHEN RD."Created Date" IS NOT NULL THEN RD."Created Date"
               WHEN AC."Created Date" IS NOT NULL THEN AC."Created Date" END AS CreatedDate,
          CASE WHEN QD."Are you interested in participating?" IS NULL AND AC."Account ID" IS NOT NULL THEN 1
               WHEN QD."Are you interested in participating?" = 'Y' THEN 1 ELSE 0 END AS InterestToParticipate,
          CASE WHEN QD."Lead Routing" IS NOT NULL THEN QD."Lead Routing"
               WHEN QD."Do you have a Fitbit device?" = 'Yes' OR RD."Do you have a Fitbit device?" = 'Yes' THEN 'Referred to website enrollment'
               ELSE 'None' END AS LeadRouting,
          CASE WHEN QD."Recruiting Method" IS NOT NULL THEN QD."Recruiting Method"
               WHEN OP."Recruiting Method" IS NOT NULL THEN OP."Recruiting Method"
               ELSE 'Unknown' END AS RecruitingMethod,     
          CASE WHEN QD."Do you have a Fitbit device?" = 'Yes' OR RD."Do you have a Fitbit device?" = 'Yes' OR
                    RD."Do you have a Fitbit device?" = 'true' THEN 1 ELSE 0 END AS HasFitbit,
          CASE WHEN QD."Do you have a Smartphone?" = 'Yes' OR RD."Do you have a Smartphone?" = 'Yes' OR
                    RD."Do you have a Smartphone?" = 'true' THEN 1 ELSE 0 END AS HasSmartphone,
          CASE WHEN RD."What model of cellphone do you own?" IS NULL THEN 'Model Not Listed' 
	       ELSE RD."What model of cellphone do you own?" END AS MobileModel,
	  CASE WHEN RD."What model of cellphone do you own?" Like '%Apple%' OR
                    RD."What model of cellphone do you own?" Like '%iPad%' OR
                    RD."What model of cellphone do you own?" Like '%iPhone%' THEN 'IOS'
               WHEN RD."What model of cellphone do you own?" Like '%Android%' OR
                    RD."What model of cellphone do you own?" Like '%LG%' OR                   
                    RD."What model of cellphone do you own?" Like '%Google%' OR                   
                    RD."What model of cellphone do you own?" Like '%Nexus%' OR 
                    RD."What model of cellphone do you own?" Like '%HTC%' OR                                     
                    RD."What model of cellphone do you own?" Like '%Lumia%' OR                   
                    RD."What model of cellphone do you own?" Like '%Nokia%' OR      
                    RD."What model of cellphone do you own?" Like '%Motorola%' OR                  
                    RD."What model of cellphone do you own?" Like '%Samsung%' THEN 'Android'  
              ELSE 'Model Not Listed' END AS MobileGroup,    
          QD."Reasons to decline invitation?" AS DeclinedReason,
          QD.Notes
From Salesforce.Lead LD
        left join Salesforce.Qualification_Data QD ON LD."Candidate ID" = QD."Related Candidate"
             AND QD."Test Record" = 'false'
        left join Salesforce.Account AC ON LD."Candidate ID" = AC."Candidate ID"
        left join Salesforce.Research_Data RD ON AC."Account ID" = RD."Related Participant"
             AND RD."Test Record" = 'false'
        left join Salesforce.Opportunity OP ON AC."Account ID" = OP."Account ID"
WHERE LD."Cohort Description" = 'Glucose Management Program'
        AND LD."Primary Treatment Description" IN ('GMP - AL Individual','GMP - AL PEEHIP')  
        AND LD."Test Record" IS FALSE
        AND LD.Deleted IS FALSE
),
QualificationDetail AS
(
   SELECT q.CandidateID,
          MAX(q.QualificationID) AS QualificationID,
          MAX(q.QualificationRecordType) AS QualificationRecordType,        
          MAX(q.CreatedDate) AS CreatedDate,
          MAX(q.InterestToParticipate) AS InterestToParticipate,
          MAX(q.LeadRouting) AS LeadRouting,
          MAX(q.RecruitingMethod) AS RecruitingMethod,     
          MAX(q.HasFitbit) AS HasFitbit,
          MAX(q.HasSmartphone) AS HasSmartphone,
          MAX(q.MobileModel) AS MobileModel,
	  MAX(q.MobileGroup) AS MobileGroup,    
          MAX(q.DeclinedReason) AS DeclinedReason,
          MAX(q.Notes) AS Notes
   FROM Qualification q  
        Join (Select q2.CandidateID, Max(q2.CreatedDate) AS CreatedDate
                From Qualification q2
               Group By q2.CandidateID ) q2 ON q2.CandidateID = q.CandidateID
                                           AND q2.CreatedDate = q.CreatedDate
  Group By  q.CandidateID

)      
SELECT *  FROM QualificationDetail



