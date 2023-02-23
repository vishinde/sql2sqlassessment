Param(
[string]$user = "userfordma",
[string]$pwd = "P@ssword135"
)


$objs = Import-Csv -Delimiter "," sqlsrv.csv
$foldername = ""
foreach($item in $objs) {
    $sqlsrv = $item.InstanceName
    $obj = sqlcmd -S $sqlsrv -i foldername.sql -U $user -P $pwd | findstr /v /c:"---"
    $splitobj = $obj[1].Split('')
    $values = $splitobj | ForEach-Object { if($_.Trim() -ne '') { $_ } }

    $dbversion = $values[0]                                                                                                                                                                       
    $machinename = $values[1]                                                                                                                                                                       
    $dbname = $values[2]                                                                                                                                                                       
    $instancename = $values[3]                                                                                                                                                                       
    $current_ts = $values[4]  

   
    $op_version = '4.2.0'                                                                                                                                                                     

    $foldername = 'opdb' + '_' + 'sqlsrv' + '_' + 'NoPerfCounter' + '_' + $dbversion + '_' + $op_version + '_' + $machinename + '_' + $dbname + '_' + $instancename + '_' + $current_ts

    New-Item -Name $foldername -ItemType Directory

    $compFileName = 'opdb' + '_' + 'ComponentsInstalled' + '_' + $dbversion + '_' + $machinename + '_' + $dbname + '_' + $instancename + '_' + $current_ts + '.csv'
    $srvFileName = 'opdb' + '_' + 'ServerProperties' + '_' + $dbversion + '_' + $machinename + '_' + $dbname + '_' + $instancename + '_' + $current_ts + '.csv'
    $blockingFeatures = 'opdb' + '_' + 'BlockingFeatures' + '_' + $dbversion + '_' + $machinename + '_' + $dbname + '_' + $instancename + '_' + $current_ts + '.csv'
    $linkedServers = 'opdb' + '_' + 'LinkedServers' + '_' + $dbversion + '_' + $machinename + '_' + $dbname + '_' + $instancename + '_' + $current_ts + '.csv'

    sqlcmd -S $sqlsrv -i ComponentsInstalled.sql -U $user -P $pwd -s"|" | findstr /v /c:"---" > $foldername\$compFileName
    sqlcmd -S $sqlsrv -i ServerProperties.sql -U $user -P $pwd -s"|" | findstr /v /c:"---" > $foldername\$srvFileName
    sqlcmd -S $sqlsrv -i Features.sql -U $user -P $pwd -m 1 -s"|" | findstr /v /c:"---" > $foldername\$blockingFeatures
    sqlcmd -S $sqlsrv -i LinkedServers.sql -U $user -P $pwd -m 1 -s"|" | findstr /v /c:"---" > $foldername\$linkedServers

    $zippedopfolder = $foldername + '.zip'
    Compress-Archive -Path $foldername -DestinationPath $zippedopfolder
    Remove-Item -Path $foldername -Recurse -Force
}
