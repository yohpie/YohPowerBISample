SELECT 
	ger.GroupLevelMemberID 
	, m.MemberID
	, m.FulfillmentID
	, ger.ReportYear
	, ger.Amount
	, ger.StartDate
 FROM GroupLevelEarningsReport ger 
 LEFT JOIN GroupLevelMember glm ON ger.GroupLevelMemberID = glm.GroupLevelMemberID 
 LEFT JOIN Member M ON glm.MemberID = M.MemberID