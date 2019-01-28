select 	msh.MemberID, 
		msh.SyncDateTime, 
		msh.SyncRecordCount, 
		m.FulfillmentID
from MemberSyncHistory msh
left join Member m on msh.MemberID = m.MemberID