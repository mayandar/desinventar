CREATE TABLE DbTypes (
	DBType int NOT NULL ,
	DbTypeDescription nvarchar (50)  NULL 
) ;

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
	IUserTypeDescription nvarchar (50)  NULL 
) ;
alter table UserTypes add CONSTRAINT UserTypesPK PRIMARY KEY (iUserType) ;


insert into UserTypes (iUserType,IUserTypeDescription) values (0,'Registered User/Guest - no access') ;
insert into UserTypes (iUserType,IUserTypeDescription) values (1,'Operator (add/edit/delete Datacards)') ;
insert into UserTypes (iUserType,IUserTypeDescription) values (20,'Administrator (+ Event/Geography Management)') ;
insert into UserTypes (iUserType,IUserTypeDescription) values (40,'Owner (+Region & User Management)') ;
insert into UserTypes (iUserType,IUserTypeDescription) values (99,'Superuser (+ALL other privileges)') ;


CREATE TABLE Country (
	sCountryId nvarchar (30)  NOT NULL ,
	sCountryName nvarchar (50)  NULL ,
	sPeriod nvarchar (50)  NULL ,
	sLastUpdated nvarchar (50)  NULL ,
	sDescriptionES ntext  NULL ,
	sDescriptionEN ntext  NULL ,
	sPageES nvarchar (250)  NULL ,
	sPageEN nvarchar (250)  NULL ,
	bPublic smallint NULL ,
	sInstitution nvarchar (150)  NULL ,
	sDriver nvarchar (150)  NULL ,
	sDatabaseName nvarchar (250)  NULL ,
	sODBCDriver nvarchar (250)  NULL ,
	sODBCDatabaseConnect nvarchar (250)  NULL ,
	sJetFileName nvarchar (255)  NULL ,
	sUsername nvarchar (50)  NULL ,
	sPassword nvarchar (50)  NULL ,
	nDbType int NULL 
) ;

alter table country add CONSTRAINT countryPK PRIMARY KEY (sCountryId );
alter table country add CONSTRAINT countryFK1 FOREIGN KEY (nDbType) REFERENCES DbTypes(DbType) ON DELETE CASCADE;

CREATE TABLE users (
	sUserId nvarchar (30)  NOT NULL ,
	sPassword nvarchar (50)  NULL ,
	iUserType int NULL ,
	sFirstName nvarchar (50)  NULL ,
	sLastName nvarchar (50)  NULL ,
	sOrganization nvarchar (50)  NULL ,
	sAddress1 nvarchar (50)  NULL ,
	sAddress2 nvarchar (50)  NULL ,
	sCity nvarchar (50)  NULL ,
	sStateProvince nvarchar (50)  NULL ,
	sCountry nvarchar (30)  NULL ,
	sPostalCode nvarchar (15)  NULL ,
	sEmailAddress nvarchar (255)  NULL ,
	sPhoneNumber nvarchar (50)  NULL ,
	sAlternatePhoneNumber nvarchar (50)  NULL ,
	sFAXNumber nvarchar (50)  NULL ,
	bNewUser smallint NULL ,
	bRecordStatus smallint NULL ,
	bActive smallint NULL ,
	dLastLoginDate smalldatetime NULL ,
	dUserSince smalldatetime NULL ,
	iFrequency int NULL ,
	bReceiveInstant smallint NULL ,
	sMemberOrganizationId nvarchar (30)  NULL 
) ;

alter table users add CONSTRAINT usersPK PRIMARY KEY (sUserId);;
alter table users add CONSTRAINT usersFK1 FOREIGN KEY (iUserType) REFERENCES UserTypes (iUserType) ON DELETE CASCADE;


CREATE TABLE user_permissions (
	userid nvarchar (30)  NOT NULL ,
	country nvarchar (30) NOT NULL 
) ;

alter table user_permissions add CONSTRAINT user_permissionsPK PRIMARY KEY (userid,country);
alter table user_permissions add CONSTRAINT user_permissionsFK1 FOREIGN KEY (userid) REFERENCES users (sUserId) ON DELETE CASCADE;
alter table user_permissions add CONSTRAINT user_permissionsFK2 FOREIGN KEY (country) REFERENCES country (sCountryId) ON DELETE CASCADE;

CREATE TABLE user_subpermissions (
	userid nvarchar(30)  NOT NULL ,
	country nvarchar(30) NOT NULL ,
        region_level  int NOT NULL,
	region_code nvarchar (30) NOT NULL
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

create table  datamodel   (
	revision integer not null, 
	build integer,  
	slanguage varchar(10)
	);

insert into datamodel (revision, build, slanguage) values (1,0,'EN');

