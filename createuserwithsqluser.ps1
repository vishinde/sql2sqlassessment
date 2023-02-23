# Parameter help description
Param(
[Parameter(Mandatory=$true)][string]$user,
[Parameter(Mandatory=$true)][string]$pwd
)
$objs = Import-Csv -Delimiter "," sqlsrv.csv
foreach($item in $objs) {
    $sqlsrv = $item.InstanceName
    sqlcmd -H $sqlsrv -i prereq_createsa.sql -U $user -P $pwd -m 1
}
