CREATE TABLE DbTypes (
	DBType number(9) NOT NULL ,
	DbTypeDescription nvarchar2 (50)  NULL 
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
	iUserType number(9) NOT NULL ,
	IUserTypeDescription nvarchar2 (50)  NULL 
) 
;

alter table UserTypes add CONSTRAINT UserTypesPK PRIMARY KEY (iUserType);

insert into UserTypes (iUserType,IUserTypeDescription) values (0,'Registered User/Guest - no access');
insert into UserTypes (iUserType,IUserTypeDescription) values (1,'Operator (add/edit/delete Datacards)');
insert into UserTypes (iUserType,IUserTypeDescription) values (20,'Administrator (+ Event/Geography Management)');
insert into UserTypes (iUserType,IUserTypeDescription) values (40,'Owner (+Region and User Management)');
insert into UserTypes (iUserType,IUserTypeDescription) values (99,'Superuser (+ALL other privileges)');

-- once created, execute the following to create all tables:
CREATE TABLE Country (
	sCountryId nvarchar2 (30)  NOT NULL ,
	sCountryName nvarchar2 (50) NOT NULL ,
	sPeriod nvarchar2 (50)  NULL ,
	sLastUpdated nvarchar2 (50)  NULL ,
	sDescriptionES nvarchar2(2000)  NULL ,
	sDescriptionEN nvarchar2(2000)  NULL ,
	sPageES nvarchar2 (250)  NULL ,
	sPageEN nvarchar2 (250)  NULL ,
	bPublic number(2) NULL ,
	sInstitution nvarchar2 (150)  NULL ,
	sDriver nvarchar2 (150)  NULL ,
	sDatabaseName nvarchar2 (250)  NULL ,
	sODBCDriver nvarchar2 (250)  NULL ,
	sODBCDatabaseConnect nvarchar2 (250)  NULL ,
	sJetFileName nvarchar2 (255)  NULL ,
	sUsername nvarchar2 (50)  NULL ,
	sPassword nvarchar2 (50)  NULL ,
	nDbType number(9) NULL 
) 
;

alter table country add CONSTRAINT countryPK PRIMARY KEY (sCountryId );
alter table country add CONSTRAINT countryFK1 FOREIGN KEY (nDbType) REFERENCES DbTypes(DbType) ON DELETE CASCADE;



CREATE TABLE users (
	sUserId nvarchar2 (30)  NOT NULL ,
	sPassword nvarchar2 (50)  NULL ,
	iUserType number(9) NULL ,
	sFirstName nvarchar2 (50)  NULL ,
	sLastName nvarchar2 (50)  NULL ,
	sOrganization nvarchar2 (50)  NULL ,
	sAddress1 nvarchar2 (50)  NULL ,
	sAddress2 nvarchar2 (50)  NULL ,
	sCity nvarchar2 (50)  NULL ,
	sStateProvince nvarchar2 (50)  NULL ,
	sCountry nvarchar2 (30)  NULL ,
	sPostalCode nvarchar2 (15)  NULL ,
	sEmailAddress nvarchar2 (255)  NULL ,
	sPhoneNumber nvarchar2 (50)  NULL ,
	sAlternatePhoneNumber nvarchar2 (50)  NULL ,
	sFAXNumber nvarchar2 (50)  NULL ,
	bNewUser number(2) NULL ,
	bRecordStatus number(8) NULL ,
	bActive number(2) NULL ,
	dLastLoginDate date NULL ,
	dUserSince date NULL ,
	iFrequency number(9) NULL ,
	bReceiveInstant number(2) NULL ,
	sMemberOrganizationId nvarchar2 (30)  NULL 
) 
;

alter table users add CONSTRAINT  usersPK PRIMARY KEY (sUserId);
alter table users add CONSTRAINT usersFK1 FOREIGN KEY (iUserType) REFERENCES UserTypes (iUserType);

CREATE TABLE user_permissions (
	userid nvarchar2 (30)  NOT NULL ,
	country nvarchar2 (30) NOT NULL 
) 
;
alter table user_permissions add CONSTRAINT user_permissionsPK PRIMARY KEY (userid,country);
alter table user_permissions add CONSTRAINT user_permissionsFK1 FOREIGN KEY (userid) REFERENCES users (sUserId) ON DELETE CASCADE;
alter table user_permissions add CONSTRAINT user_permissionsFK2 FOREIGN KEY (country) REFERENCES country (sCountryId) ON DELETE CASCADE;


CREATE TABLE user_subpermissions (
	userid nvarchar2 (30)  NOT NULL ,
	country nvarchar2 (30) NOT NULL ,
        region_level  integer NOT NULL,
	region_code nvarchar2 (30) NOT NULL
) ;
alter table user_subpermissions add CONSTRAINT user_subpermissionsPK PRIMARY KEY (userid,country,region_level,region_code);
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK1 FOREIGN KEY (userid) REFERENCES users (suserid) ON DELETE CASCADE;
alter table user_subpermissions add CONSTRAINT user_subpermissionsFK2 FOREIGN KEY (country) REFERENCES country (scountryid) ON DELETE CASCADE;

create table  datamodel   (
	revision number(5) not null, 
	build number(5),  
	slanguage varchar2(10)
);
insert into datamodel (revision, build, slanguage) values (1,0,'EN');


