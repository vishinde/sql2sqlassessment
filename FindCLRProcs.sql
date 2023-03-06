DECLARE @command VARCHAR(5000);
IF OBJECT_ID('tempdb..#CLRCode') is not null
BEGIN
	DROP TABLE #CLRCode
END

CREATE TABLE #CLRCode ( 
ServerName varchar(100),
DBNAME varchar(100),
objectid varchar(100),
assemblyID varchar(100),
assemblyName varchar(100),
CLRObjectName varchar(100),
CLRType varchar(100),
DateCreated varchar(100),
SateModified varchar(100),
CLRPermission varchar(100)
);

SELECT @command = 'SELECT  @@servername AS ServerName,
(Select db_name() as DBNAME) as DBNAME,
o.object_id AS [object_ID]
, a.assembly_id AS [assemblyID]
,a.name AS [assemblyName]
,schema_name(o.schema_id) + o.[name] AS [CLRObjectName]
,o.type_desc AS [CLRType]
,o.create_date AS [DateCreated]
,o.modify_date AS [SateModified]
,a.permission_set_desc AS [CLRPermission]
FROM sys.objects o
INNER JOIN sys.module_assembly_usages ma
ON o.object_id = ma.object_id
INNER JOIN sys.assemblies a
ON ma.assembly_id = a.assembly_id';

INSERT INTO #CLRCode
EXEC sp_MSForEachDB @command

SELECT * FROM #CLRCode;