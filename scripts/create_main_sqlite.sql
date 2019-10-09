CREATE TABLE DbTypes (
	DBType integer NOT NULL ,
	DbTypeDescription varchar (50),
	CONSTRAINT DbTypesPK PRIMARY KEY (DBType)
) ;


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
	IUserTypeDescription varchar (50),
	CONSTRAINT UserTypesPK PRIMARY KEY (iUserType) 
) ;


insert into UserTypes (iUserType,IUserTypeDescription) values (0,'Registered User/Guest - no access');
insert into UserTypes (iUserType,IUserTypeDescription) values (1,'Operator (add/edit/delete Datacards)');
insert into UserTypes (iUserType,IUserTypeDescription) values (20,'Administrator (+ Event/Geography Management)');
insert into UserTypes (iUserType,IUserTypeDescription) values (40,'Owner (+Region & User Management)');
insert into UserTypes (iUserType,IUserTypeDescription) values (99,'Superuser (+ALL other privileges)');

-- once created, execute the following to create all tables:
CREATE TABLE Country (
	sCountryId varchar (30)  NOT NULL ,
	sCountryName varchar (50) NOT NULL ,
	sPeriod varchar (50),
	sLastUpdated varchar (50),
	sDescriptionES varchar(2000),
	sDescriptionEN varchar(2000),
	sPageES varchar (250),
	sPageEN varchar (250)   ,
	bPublic integer  ,
	sInstitution varchar (150)   ,
	sDriver varchar (150)   ,
	sDatabaseName varchar (250)   ,
	sODBCDriver varchar (250)   ,
	sODBCDatabaseConnect varchar (250)   ,
	sJetFileName varchar (255)   ,
	sUsername varchar (50)   ,
	sPassword varchar (50)   ,
	nDbType integer , 
	CONSTRAINT countryPK PRIMARY KEY (sCountryId ),
	FOREIGN KEY (nDbType) REFERENCES DbTypes(DbType)
) ;




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
	sMemberOrganizationId varchar (30)  NULL,
	CONSTRAINT  usersPK PRIMARY KEY (sUserId),
 	FOREIGN KEY (iUserType) REFERENCES UserTypes (iUserType)
) ;


CREATE TABLE user_permissions (
	userid varchar (30)  NOT NULL ,
	country varchar (30) NOT NULL ,
	CONSTRAINT user_permissionsPK PRIMARY KEY (userid,country),
	FOREIGN KEY (userid) REFERENCES users (sUserId) ON DELETE CASCADE,
	FOREIGN KEY (country) REFERENCES country (sCountryId) ON DELETE CASCADE
) ;


CREATE TABLE user_subpermissions (
	userid varchar(30)  NOT NULL ,
	country varchar(30) NOT NULL ,
        region_level  integer NOT NULL,
	region_code varchar (30) NOT NULL,
        CONSTRAINT user_subpermissionsPK PRIMARY KEY (userid,country,region_level,region_code),
	FOREIGN KEY (userid) REFERENCES users (suserid) ON DELETE CASCADE,
	FOREIGN KEY (country) REFERENCES country (scountryid) ON DELETE CASCADE
) ;


create table  media_type 
   (
   media_type int not null,
   media_type_name varchar(50),
   media_type_name_en varchar(50),
   media_type_extensions varchar(50)
   );
alter table media_type add constraint media_type_PK PRIMARY KEY (media_type);

insert into media_type (media_type, media_type_name, media_type_name_en ,media_type_extensions) values (1,'MS Word','','doc,docx');
insert into media_type (media_type, media_type_name, media_type_name_en ,media_type_extensions) values (2,'MS Excel','','xls,xlsx');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (3,'MS PowerPoint','ppt,pptx','');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (4,'PDF','','pdf');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (5,'Picture','','jpg,png,gif');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (6,'Video','','mpg4');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (7,'URL','','');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (8,'Text file','','txt,prn');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (9,'ZIP data file','','zip,7z,tar,gz');
update media_type set media_type_name_en=media_type_name;

create table  media_file 
   (
   imedia int not null,
   iclave int not null,
   media_type int,
   media_title varchar(50),
   media_title_en varchar(50),
   media_description_en varchar (255),
   media_link varchar (255)
   );

alter table media_file add constraint media_file_PK PRIMARY KEY (imedia);
alter table media_file add constraint media_file_fichasFK foreign key (iclave) references fichas(clave);
alter table media_file add constraint media_file_typeFK foreign key (media_type) references media_type(media_type);


create sequence media_seq;




create table  datamodel   (
	revision integer not null, 
	build integer,  
	slanguage varchar(10)
	);

insert into datamodel (revision, build, slanguage) values (1,0,'EN');


