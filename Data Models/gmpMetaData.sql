select distinct m.FulfillmentID, 
       smd.memberid,
       case when smd.LastSyncDatetime = '01-01-1900' 
	        then null else smd.LastSyncDatetime 
	   end LastSyncDatetime, 
	   DATEDIFF(day,smd.LastSyncDatetime,Getdate()) [Days],
	   gl.GroupName, 
	   gl.GroupLevelID
from Member m 
inner join MetaDataStepMember smd on m.MemberID = smd.MemberID
inner join GroupLevelMember glm on m.MemberID = glm.MemberID
inner join GroupLevel gl on glm.GroupLevelID = gl.GroupLevelID
where gl.GroupLevelID <> 11  -- Test Group