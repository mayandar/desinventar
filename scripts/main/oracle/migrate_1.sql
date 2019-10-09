-- ORACLE database script
create table  datamodel   (
	revision number(5) not null, 
	build number(6),  
	slanguage varchar2(10)
);

CREATE TABLE user_subpermissions (
	userid nvarchar2 (30)  NOT NULL ,
	country nvarchar2 (30) NOT NULL ,
        region_level  integer NOT NULL,
	region_code nvarchar2 (30) NOT NULL
) ;
alter table user_subpermissions add CONSTRAINT user_subpermissionsPK PRIMARY KEY (userid,country,region_level,region_code);
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK1 FOREIGN KEY (userid) REFERENCES users (suserid) ON DELETE CASCADE;
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK2 FOREIGN KEY (country) REFERENCES country (scountryid) ON DELETE CASCADE;

