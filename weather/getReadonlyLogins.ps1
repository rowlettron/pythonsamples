Clear-Host

# Prompt the user for SQL Server credentials
$credential = Get-Credential
$credential.Password.MakeReadOnly()

$localServerName = "localhost"

# Define the SQL query to get the list of servers
$serverQuery = "SELECT DISTINCT DNSName FROM BackupMaster.Audit.BackupStatus WHERE bkupDate > GETDATE() - 7 ORDER BY DNSName;"

#Query to determine if server has the events turned on
$eventsQuery = @"

SELECT substring(cast(value AS NVARCHAR(max)), 1, charindex('_', cast(value AS NVARCHAR(max))) - 1) + '*' + substring(cast(value AS NVARCHAR(max)), charindex('.x', cast(value AS NVARCHAR(max))), 255)
FROM sys.server_event_session_fields
WHERE name = 'filename'
    AND cast(value AS NVARCHAR(max)) LIKE '%RCPEIT%'

"@

# Define the instance to get the list of servers from
$serverListInstance = "DBAMNT"

# Get the list of servers
$servers = Invoke-Sqlcmd -ServerInstance $serverListInstance -Database "BackupMaster" -Credential $credential -Query $serverQuery -TrustServerCertificate | Select-Object -ExpandProperty DNSName

#Write-Host $servers

$sqlQuery = @"
DECLARE @filename NVARCHAR(500),
    @sql NVARCHAR(max)

SELECT @filename = substring(cast(value AS NVARCHAR(max)), 1, charindex('_', cast(value AS NVARCHAR(max))) - 1) + '*' + substring(cast(value AS NVARCHAR(max)), charindex('.x', cast(value AS NVARCHAR(max))), 255)
FROM sys.server_event_session_fields
WHERE name = 'filename'
    AND cast(value AS NVARCHAR(max)) LIKE '%RCPEIT%'

IF @filename IS NULL
BEGIN
    PRINT 'Could not get event file name for ' + @@SERVERNAME
    RETURN
END

SELECT @sql = 
    'DROP TABLE IF EXISTS #t;

SELECT event_data = CONVERT(XML, event_data) 
INTO #t
FROM sys.fn_xe_file_target_read_file(N''\\RCPEITAPSTAT503.realpage.com\SQLStats\RCPSCRDBGEN001A\SQLStats_*.xel'', NULL, NULL, NULL);

SELECT distinct @@SERVERNAME AS ServerName,
       /*t.value(''@name[1]'', ''varchar(500)'') AS loginName,*/
       t.value(''value[1]'', ''varchar(500)'') AS loginName,
       t.value(''(/event/@timestamp)[1]'', ''varchar(50)'') AS collectionDate,
       t.value(''(/event/action/value)[3]'', ''varchar(8000)'') AS databaseName, 
       t.value(''(/event/action/value)[2]'', ''varchar(8000)'') AS sessionID, 
       t.value(''(/event/action/value)[5]'', ''varchar(8000)'') AS clientHostName, 
       t.value(''(/event/action/value)[6]'', ''varchar(8000)'') AS clientAppName, 
       t.value(''(/event/data/value)[10]'', ''varchar(8000)'') AS sqlText
FROM #t t
CROSS APPLY t.event_data.nodes(''/event/action'') AS h(t)
WHERE t.value(''@name[1]'', ''varchar(500)'') = ''session_server_principal_name''
  AND t.value(''value[1]'', ''varchar(500)'') = ''readonly''
'

EXEC sp_executesql @sql

"@

# Define SQL query for AG state
$sqlQueryAGState = @"
SELECT ar.replica_id, ar.role_desc
FROM sys.dm_hadr_availability_replica_states AS ar
INNER JOIN sys.dm_hadr_availability_group_states AS ags ON ar.group_id = ags.group_id
WHERE ar.is_local = 1
"@

# Loop through list of servers
foreach ($server in $servers){
    Write-Host $server 

    #Check if the server is part of an AG setup
    $isAgPrimary = $false
    $isAgSecondary = $false
    $isAgMember = $false

    try {
        $agState = Invoke-Sqlcmd -ServerInstance $server -Database "master" -Credential $credential -Query $sqlQueryAGState -TrustServerCertificate
        if ($agState) {
            $isAgMember = $true
            foreach ($replica in $agState) {
                if ($replica.role_desc -eq "PRIMARY") {
                    $isAgPrimary = $true
                } elseif ($replica.role_desc -eq "SECONDARY") {
                    $isAgSecondary = $true
                }
            }
        }
    } catch {
        # Log error or handle exception if necessary
        Write-Host "An error occurred for server $server"
    }

    #Skip the server if it is a secondary replica
    if ($isAgSecondary) {
        Write-Host "Skipping server $server since it is a secondary replica"
        continue
    }

    try {
        $readOnlyData = Invoke-Sqlcmd -ServerInstance $server -Database "master" -Credential $credential -Query $sqlQuery -TrustServerCertificate

#        $readOnlyData.GetType()

#        foreach ($row in $readOnlyData){
#            $row.serverName 
#            $row.loginName
#            $row.collectionDate
#            $row.databaseName
#            $row.clientHostName
#            $row.clientAppName,
#            $row.sqlText
#        }

        if ($readOnlyData) {
            try {
                Write-SqlTableData -ServerInstance $localServerName -DatabaseName "IT" -SchemaName "dbo" -TableName "ReadOnlyLogins" -InputData $readOnlyData -Credential $credential -TrustServerCertificate
            }
            catch{
                Write-Host $PSItem.ToString()
            }
        }

    }
    catch{
        Write-Host "An error occurred for server $server"
    }

}

