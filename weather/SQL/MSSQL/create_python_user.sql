USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [python]    Script Date: 9/29/2024 5:18:23 PM ******/
CREATE LOGIN [python] WITH PASSWORD=N'Trustno1@all', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [python]
GO

