if exists (select * from dbo.sysobjects where id = object_id(N'palabras') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table palabras
GO

if exists (select * from dbo.sysobjects where id = object_id(N'user_permissions') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table user_permissions
GO

if exists (select * from dbo.sysobjects where id = object_id(N'users') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table users
GO

if exists (select * from dbo.sysobjects where id = object_id(N'Country') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table Country 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'DbTypes') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table DbTypes
GO

if exists (select * from dbo.sysobjects where id = object_id(N'UserTypes') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table UserTypes
GO

