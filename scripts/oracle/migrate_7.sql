-- Oracle database script - upgrade to data model version 6
alter table fichas modify serial nvarchar2(15);

