$objs = Import-Csv -Delimiter "," sqlsrv.csv
$foldername = ""
foreach($item in $objs) {
    sqlcmd -H $sqlsrv -i prereq_createsa.sql
}
