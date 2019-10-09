-- MySQL database script

drop table extensioncodes;

create table  extensioncodes   (
	nsort int(10), 
	svalue varchar(40), 
	svalue_en varchar(40),
	field_name nvarchar2 (30) NOT NULL ,
	UNIQUE KEY `extensioncodesPK` (`field_name`,`nsort`)
	);

	
