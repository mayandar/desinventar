-- SQL Server database script

create table  datamodel   (
	revision integer not null, 
	build integer,  
	slanguage varchar(10)
);

CREATE TABLE user_subpermissions (
	userid nvarchar(30)  NOT NULL ,
	country nvarchar(30) NOT NULL ,
        region_level  int NOT NULL,
	region_code nvarchar (30) NOT NULL
) ;

alter table user_subpermissions add CONSTRAINT user_subpermissionsPK PRIMARY KEY (userid,country,region_level,region_code);
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK1 FOREIGN KEY (userid) REFERENCES users (suserid) ON DELETE CASCADE;
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK2 FOREIGN KEY (country) REFERENCES country (scountryid) ON DELETE CASCADE;


