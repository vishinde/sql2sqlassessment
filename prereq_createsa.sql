USE [master]
GO
IF NOT EXISTS 
    (SELECT name  
     FROM master.sys.server_principals
     WHERE name = 'userfordma')
BEGIN
    CREATE LOGIN [userfordma] WITH PASSWORD=N'P@ssword135', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
END
GO
EXEC master..sp_addsrvrolemember @loginame = N'userfordma', @rolename = N'sysadmin'