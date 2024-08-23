Clear-Host

Prompt the user for SQL Server credentials
$credential = Get-Credential
$credential.Password.MakeReadOnly()

$localServerName = "localhost"

$serverList = get-content -Path .\ServerList.txt

$sqlQuery = @"
DECLARE @sql nvarchar(max),
        @dbname nvarchar(130)

drop table if exists #alpha;

create table #alpha (ApplicationHostName  varchar(128) null,
                     ServerName varchar(128) null, 
                     ApplicationName varchar(256) null,
                     ImportDate datetime null,
                     LoginName nvarchar(128) null)

drop table if exists #dbnames;

select name as dbname
into #dbnames 
from master.sys.databases
where name like 'SQLSTAT%'
order by name 

while (1 = 1)
begin
    select top 1 @dbname = dbname
    from #dbnames; 

    if @@rowcount = 0
        break; 

    delete #dbnames 
    where dbname = @dbname;

    raiserror(@dbname, 0, 1) with nowait

    select @sql = '
SELECT HostName as ApplicationHostName, ''' + 
       substring(@dbname, charindex('_', @dbname) + 1, 256) + ''' AS ServerName, 
       ApplicationName,
       ImportDate,
       LoginName 
FROM ' + @dbname + '.dbo.LoginTrace a with (nolock)
where LoginName = ''readonly''
  and ImportDate = (select max(ImportDate)
                    from ' + @dbname + '.dbo.LoginTrace b with (nolock)
                    where b.HostName = a.HostName
                      and b.ApplicationName = a.ApplicationName
                      and b.LoginName = a.LoginName)
order by ImportDate desc
'
    --print @sql

    insert #alpha (ApplicationHostName, ServerName, ApplicationName, ImportDate, LoginName)
    exec sp_executesql @sql

end; 

select ServerName,
       ApplicationHostName,
       ApplicationName,
       ImportDate,
       LoginName
from #alpha 

"@

foreach ($server in $serverList) {
    write-host $server

    try {
        $readOnlyData = Invoke-Sqlcmd -ServerInstance $server -Database "master" -Credential $credential -Query $sqlQuery -TrustServerCertificate

        if ($readOnlyData){
            try {
                Write-SqlTableData -ServerInstance $localServerName -DatabaseName "IT" -SchemaName "dbo" -TableName "ReadOnlyLogins_v2" -InputData $readOnlyData -Credential $credential -TrustServerCertificate
            }
            catch{
                Write-Host $PSItem.ToString()
            }
        }
    }
    catch {
        Write-Host $PSItem.ToString()
    }
}