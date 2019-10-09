-- MySQL database script
create table  datamodel   (
	revision int(10) not null, 
	build int(10), 
	slanguage varchar(10)
	);



CREATE TABLE user_subpermissions (
	userid varchar(30)  NOT NULL ,
	country varchar(30) NOT NULL ,
        region_level  integer NOT NULL,
	region_code varchar (30) NOT NULL,
	primary key user_subpermissionspk (userid,country,region_level,region_code) 

) ;

alter table user_subpermissions add constraint user_subpermissionsFK1 foreign key (userid) references users (suserid) on delete cascade;
alter table user_subpermissions add constraint user_subpermissionsFK2 foreign key  (country) references country (scountryid) on delete cascade;


