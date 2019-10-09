CREATE TABLE DbTypes (
	DBType integer NOT NULL ,
	DbTypeDescription varchar (50)  NULL 
) 
;


alter table DbTypes add CONSTRAINT DbTypesPK PRIMARY KEY (DBType);

insert into DbTypes (DBType,DbTypeDescription) values (0,'Oracle');
insert into DbTypes (DBType,DbTypeDescription) values (1,'ODBC no auth(MS Access)');
insert into DbTypes (DBType,DbTypeDescription) values (2,'SQL Server');
insert into DbTypes (DBType,DbTypeDescription) values (3,'MySQL');
insert into DbTypes (DBType,DbTypeDescription) values (4,'ODBC authenticated');
insert into DbTypes (DBType,DbTypeDescription) values (5,'PostgreSQL');
insert into DbTypes (DBType,DbTypeDescription) values (6,'Derby');
insert into DbTypes (DBType,DbTypeDescription) values (7,'SQLite');
insert into DbTypes (DBType,DbTypeDescription) values (8,'JDBC generic');



CREATE TABLE UserTypes (
	iUserType integer NOT NULL ,
	IUserTypeDescription varchar (50)  NULL 
) 
;

alter table UserTypes add CONSTRAINT UserTypesPK PRIMARY KEY (iUserType);

insert into UserTypes (iUserType,IUserTypeDescription) values (0,'Registered User/Guest - no access');
insert into UserTypes (iUserType,IUserTypeDescription) values (1,'Operator (add/edit/delete Datacards)');
insert into UserTypes (iUserType,IUserTypeDescription) values (20,'Administrator (+ Event/Geography Management)');
insert into UserTypes (iUserType,IUserTypeDescription) values (40,'Owner (+Region & User Management)');
insert into UserTypes (iUserType,IUserTypeDescription) values (99,'Superuser (+ALL other privileges)');

-- once created, execute the following to create all tables:
CREATE TABLE Country (
	sCountryId varchar (30)  NOT NULL ,
	sCountryName varchar (50) NOT NULL ,
	sPeriod varchar (50)  NULL ,
	sLastUpdated varchar (50)  NULL ,
	sDescriptionES varchar(2000)  NULL ,
	sDescriptionEN varchar(2000)  NULL ,
	sPageES varchar (250)  NULL ,
	sPageEN varchar (250)  NULL ,
	bPublic integer NULL ,
	sInstitution varchar (150)  NULL ,
	sDriver varchar (150)  NULL ,
	sDatabaseName varchar (250)  NULL ,
	sODBCDriver varchar (250)  NULL ,
	sODBCDatabaseConnect varchar (250)  NULL ,
	sJetFileName varchar (255)  NULL ,
	sUsername varchar (50)  NULL ,
	sPassword varchar (50)  NULL ,
	nDbType integer NULL 
) 
;

alter table country add CONSTRAINT countryPK PRIMARY KEY (sCountryId );
alter table country add CONSTRAINT countryFK1 FOREIGN KEY (nDbType) REFERENCES DbTypes(DbType) ON DELETE CASCADE;



CREATE TABLE users (
	sUserId varchar (30)  NOT NULL ,
	sPassword varchar (50)  NULL ,
	iUserType integer NULL ,
	sFirstName varchar (50)  NULL ,
	sLastName varchar (50)  NULL ,
	sOrganization varchar (50)  NULL ,
	sAddress1 varchar (50)  NULL ,
	sAddress2 varchar (50)  NULL ,
	sCity varchar (50)  NULL ,
	sStateProvince varchar (50)  NULL ,
	sCountry varchar (30)  NULL ,
	sPostalCode varchar (15)  NULL ,
	sEmailAddress varchar (255)  NULL ,
	sPhoneNumber varchar (50)  NULL ,
	sAlternatePhoneNumber varchar (50)  NULL ,
	sFAXNumber varchar (50)  NULL ,
	bNewUser integer NULL ,
	bRecordStatus integer NULL ,
	bActive integer NULL ,
	dLastLoginDate date NULL ,
	dUserSince date NULL ,
	iFrequency integer NULL ,
	bReceiveInstant integer NULL ,
	sMemberOrganizationId varchar (30)  NULL 
) 
;

alter table users add CONSTRAINT  usersPK PRIMARY KEY (sUserId);
alter table users add CONSTRAINT usersFK1 FOREIGN KEY (iUserType) REFERENCES UserTypes (iUserType);

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

alter table user_subpermissions add CONSTRAINT user_subpermissionsPK PRIMARY KEY (userid,country,region_level,region_code);
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK1 FOREIGN KEY (userid) REFERENCES users (suserid) ON DELETE CASCADE;
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK2 FOREIGN KEY (country) REFERENCES country (scountryid) ON DELETE CASCADE;

create table  datamodel   (
	revision integer not null, 
	build integer,  
	slanguage varchar(10)
	);

insert into datamodel (revision, build, slanguage) values (1,0,'EN');




