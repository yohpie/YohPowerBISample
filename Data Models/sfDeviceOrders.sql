WITH SalesforceDiviceOrders AS
(       
        SELECT OU."Related Participant" AS RelatedParticipantID,
               OU.OrderNumber AS OrderNo, 
               OU.OrderDate, 
               OU.CurrOrderStatus,
               OU.OrderStatusDate,
               OU.Kit_Type AS KitType, 
               OU."Kit Selection" AS KitSelection,
        
               OU."Related Opportunity" AS RelatedOpportunity,
               OU."Program Code" AS ProgramCode,
               OU."Cohort Description" AS CohortDescription,
               OU."DERM Pairing Status" AS DermPairingStatus,
               OU."Guide Uploaded" AS GuideUploaded,
               
               MAX(CASE WHEN OU.devicename ILIKE '%Bayer Glucometer%' OR OU.devicename ILIKE '%Transmitter%' THEN 1 ELSE 0 END) AS GlucoseDevice,
               MAX(CASE WHEN OU.devicename ILIKE '%Fitbit%' OR OU.devicename ILIKE '%Smart Watch%' OR OU.devicename ILIKE '%Tracker%'
                        THEN 1 ELSE 0 END) AS StepTrackerDevice
               
          FROM salesforce.savvysherpa_order_unpivot AS ou
                INNER JOIN (SELECT OU."Related Participant", 
                                   OU."Related Opportunity", 
                                   MIN(OU.orderdate) AS OrderDate, 
                                   OU."Program Code" AS Program_Code,
                                   OU."Kit Selection"
                              FROM salesforce.savvysherpa_order_unpivot AS ou
                             WHERE OU."Program Code" IN ('T2D-UHC AL Individual','T2D-UHC AL Group')
                               AND OU."Kit Selection" IN ('Fitbit Only','Document/User Guide')
                             GROUP BY OU."Related Participant", OU."Related Opportunity", OU."Program Code",OU."Kit Selection"
                            ) AS mo ON OU."Related Participant" = mo."Related Participant"
                                   AND OU."Related Opportunity" = mo."Related Opportunity"
                                   AND OU.orderdate = mo.OrderDate
                                   
          WHERE OU."Program Code" IN ('T2D-UHC AL Individual','T2D-UHC AL Group')
            AND OU."Kit Selection" IN ('Fitbit Only','Document/User Guide')
            
          GROUP BY OU."Related Participant", OU."Related Opportunity", OU."Program Code",
                   OU."Cohort Description", OU."DERM Pairing Status",
                   OU.ordernumber, OU.orderdate, OU.currorderstatus, OU.orderstatusdate,
                   OU."Guide Uploaded", OU.Kit_Type, OU."Kit Selection"
)
SELECT *
  FROM SalesforceDiviceOrders
  