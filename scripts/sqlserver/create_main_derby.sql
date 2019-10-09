CREATE TABLE DbTypes (
	DBType int not null,
	DbTypeDescription varchar (50)
);

alter table DbTypes add CONSTRAINT DbTypesPK PRIMARY KEY (DBType);


insert into DbTypes (DBType ,DbTypeDescription) values (0,'Oracle');
insert into DbTypes (DBType ,DbTypeDescription) values (1,'ODBC no auth(MS Access)');
insert into DbTypes (DBType ,DbTypeDescription) values (2,'SQL Server');
insert into DbTypes (DBType ,DbTypeDescription) values (3,'MySQL');
insert into DbTypes (DBType ,DbTypeDescription) values (4,'ODBC authenticated');
insert into DbTypes (DBType ,DbTypeDescription) values (5,'PostgreSQL');
insert into DbTypes (DBType ,DbTypeDescription) values (6,'Derby');
insert into DbTypes (DBType ,DbTypeDescription) values (7,'SQLite');
insert into DbTypes (DBType ,DbTypeDescription) values (8,'JDBC generic');



CREATE TABLE UserTypes (
	iUserType int NOT NULL ,
	IUserTypeDescription varchar (50) 
) ;
alter table UserTypes add CONSTRAINT UserTypesPK PRIMARY KEY (iUserType) ;


insert into UserTypes (iUserType,IUserTypeDescription) values (0,'Registered User/Guest - no access') ;
insert into UserTypes (iUserType,IUserTypeDescription) values (1,'Operator (add/edit/delete Datacards)') ;
insert into UserTypes (iUserType,IUserTypeDescription) values (20,'Administrator (+ Event/Geography Management)') ;
insert into UserTypes (iUserType,IUserTypeDescription) values (40,'Owner (+Region & User Management)') ;
insert into UserTypes (iUserType,IUserTypeDescription) values (99,'Superuser (+ALL other privileges)') ;


CREATE TABLE Country (
	sCountryId varchar (30)  NOT NULL,
	sCountryName varchar (50) ,
	sPeriod varchar (50) ,
	sLastUpdated varchar (50) ,
	sDescriptionES LONG VARCHAR,
	sDescriptionEN LONG VARCHAR,
	sPageES varchar (250) ,
	sPageEN varchar (250) ,
	bPublic smallint,
	sInstitution varchar (150) ,
	sDriver varchar (150) ,
	sDatabaseName varchar (250) ,
	sODBCDriver varchar (250) ,
	sODBCDatabaseConnect varchar (250) ,
	sJetFileName varchar (255) ,
	sUsername varchar (50) ,
	sPassword varchar (50) ,
	nDbType int 
);

alter table country add CONSTRAINT countryPK PRIMARY KEY (sCountryId );
alter table country add CONSTRAINT countryFK1 FOREIGN KEY (nDbType) REFERENCES DbTypes(DbType) ON DELETE CASCADE;

CREATE TABLE users (
	sUserId varchar (30)  NOT NULL ,
	sPassword varchar (50) ,
	iUserType int ,
	sFirstName varchar (50) ,
	sLastName varchar (50) ,
	sOrganization varchar (50) ,
	sAddress1 varchar (50) ,
	sAddress2 varchar (50) ,
	sCity varchar (50) ,
	sStateProvince varchar (50) ,
	sCountry varchar (30) ,
	sPostalCode varchar (15) ,
	sEmailAddress varchar (255) ,
	sPhoneNumber varchar (50) ,
	sAlternatePhoneNumber varchar (50) ,
	sFAXNumber varchar (50) ,
	bNewUser smallint ,
	bRecordStatus smallint ,
	bActive smallint ,
	dLastLoginDate timestamp,
	dUserSince timestamp,
	iFrequency int ,
	bReceiveInstant smallint ,
	sMemberOrganizationId varchar (30) 
) 
;

alter table users add CONSTRAINT usersPK PRIMARY KEY (sUserId);

alter table users add CONSTRAINT usersFK1 FOREIGN KEY (iUserType) REFERENCES UserTypes (iUserType) ON DELETE CASCADE;


CREATE TABLE user_permissions (
	userid varchar (30)  NOT NULL ,
	country varchar (30) NOT NULL 
) 
;

alter table user_permissions add CONSTRAINT user_permissionsPK PRIMARY KEY (userid,country);
alter table user_permissions add CONSTRAINT user_permissionsFK1 FOREIGN KEY (userid) REFERENCES users (sUserId) ON DELETE CASCADE;
alter table user_permissions add CONSTRAINT user_permissionsFK2 FOREIGN KEY (country) REFERENCES country (sCountryId) ON DELETE CASCADE;

CREATE TABLE user_subpermissions (
	userid varchar(30)  NOT NULL ,
	country varchar(30) NOT NULL ,
        region_level  integer NOT NULL,
	region_code varchar (30) NOT NULL
) ;

aalter table user_subpermissions add CONSTRAINT user_subpermissionsPK PRIMARY KEY (userid,country,region_level,region_code);
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK1 FOREIGN KEY (userid) REFERENCES users (suserid) ON DELETE CASCADE;
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK2 FOREIGN KEY (country) REFERENCES country (scountryid) ON DELETE CASCADE;




create table  datamodel   (
	revision smallint not null, 
	build smallint,
	slanguage varchar(10)
	);
insert into datamodel (revision, build, slanguage) values (1,0,'EN');
