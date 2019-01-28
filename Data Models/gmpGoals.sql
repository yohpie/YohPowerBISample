WITH AllGoal AS 
                     ( 
                           SELECT  glm.GroupLevelMemberID, gl.GroupName,m.FulfillmentID, glm.MemberID, rt.RuleTypeDesc, g.GoalDate, g.GoalAmount, g.GoalPoints, g.TotalSteps, g.TotalBouts, g.isAchieved, g.Miles, 
                                         rgd.RuleTypeID, g.RowCreatedDateTime 
                                  FROM Goal g 
                                  INNER JOIN GroupLevelMember glm ON g.GroupLevelMemberID = glm.GroupLevelMemberID 
								  INNER JOIN GroupLevel gl ON glm.GroupLevelID = gl.GroupLevelID
								  INNER JOIN Member m ON glm.MemberID = m.MemberID
                                  INNER JOIN RuleGroupDetail rgd ON g.RuleGroupDetailID = rgd.RuleGroupDetailID 
                                  INNER JOIN RuleType rt ON rgd.RuleTypeID = rt.RuleTypeID 
                                  WHERE rt.RuleTypeID <> 2  --removing hourly activity

                           UNION  
 
                           SELECT  glm.GroupLevelMemberID, gl.GroupName,m.FulfillmentID, glm.MemberID, rt.RuleTypeDesc, gs.GoalDate, gs.GoalAmount, gs.GoalPoints, gs.TotalSteps, gs.TotalBouts, gs.isAchieved, gs.Miles, 
                                         rgd.RuleTypeID, gs.RowCreatedDateTime 
                                  FROM GoalStage gs 
                                  INNER JOIN GroupLevelMember glm ON gs.GroupLevelMemberID = glm.GroupLevelMemberID 
								  INNER JOIN GroupLevel gl ON glm.GroupLevelID = gl.GroupLevelID
								  INNER JOIN Member m ON glm.MemberID = m.MemberID
                                  INNER JOIN RuleGroupDetail rgd ON gs.RuleGroupDetailID = rgd.RuleGroupDetailID 
                                  INNER JOIN RuleType rt ON rgd.RuleTypeID = rt.RuleTypeID 
                                  WHERE rt.RuleTypeID <> 2   --removing hourly activity
                     ), final AS 
                     ( 
                           SELECT * 
                                  , DATEPART(qq, ag.GoalDate) AS DQuarter 
                                  , ROW_NUMBER() OVER (PARTITION BY ag.GroupLevelMemberID, YEAR(ag.GoalDate), DATEPART(QQ, ag.GoalDate) ORDER BY ag.GoalDate)   AS RCount
                                  , ROW_NUMBER() OVER (PARTITION BY ag.GroupLevelMemberID, ag.GoalDate, ag.RuleTypeID ORDER BY ag.RowCreatedDateTime DESC) AS Number 
                           FROM AllGoal ag             
                      )
              
              SELECT 
				F.FulfillmentID
				, F.MemberID
				, glm.GroupLevelMemberID
				, glm.GroupLevelID
				, f.GroupName
				, F.GoalDate
				, F.GoalAmount
				, F.isAchieved
				, F.Miles
				, F.RuleTypeDesc
				, F.TotalBouts
				, F.TotalSteps
				, M.ProgramStartDate
				, M.CancelledDateTime
              FROM Final F
              INNER JOIN  GroupLevelMember glm ON f.GroupLevelMemberId = glm.GroupLevelMemberID
			  LEFT JOIN Member M ON F.MemberID = M.MemberID
              WHERE 
                     glm.GroupLevelID IN (8,10)
                     AND F.Number = 1