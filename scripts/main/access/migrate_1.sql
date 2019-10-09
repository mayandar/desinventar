-- ACCESS database script

-- this will contain the current model of the database
create table  datamodel   (
	revision integer not null, 
	build integer, 
	slanguage text(10)
	);


CREATE TABLE user_subpermissions (
	userid text(30)  NOT NULL ,
	country text(30) NOT NULL ,
        region_level  int NOT NULL,
	region_code text(30) NOT NULL
) ;

alter table user_subpermissions add CONSTRAINT user_subpermissionsPK PRIMARY KEY (userid,country,region_level,region_code);
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK1 FOREIGN KEY (userid) REFERENCES users (suserid) CASCADE;
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK2 FOREIGN KEY (country) REFERENCES country (scountryid) CASCADE;




