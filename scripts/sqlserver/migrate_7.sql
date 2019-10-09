-- MS SQL Server database script - upgrade to data model version 7
alter table fichas alter column serial nvarchar(15);

 