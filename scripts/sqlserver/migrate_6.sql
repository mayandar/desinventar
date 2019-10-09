-- MS SQL Server database script - upgrade to data model version 6
alter table extensioncodes add code_value nvarchar(10) not null default '0';
alter table extensioncodes drop constraint extensioncodesPK;
alter table extensioncodes add constraint extensioncodesPK primary key (field_name, code_value);
 
 