-- ALWAYS CREATE DESINVENTAR DATABASES WITH UTF8:
-- CREATE SCHEMA `desinventar` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE dbtypes(
	dbtype integer not null ,
	dbtypedescription varchar (50)  null,
	primary key dbtypespk (dbtype) 
) ENGINE=InnoDB;




insert into dbtypes(dbtype,dbtypedescription) values (0,'Oracle');
insert into dbtypes(dbtype,dbtypedescription) values (1,'ODBC no auth(MS Access)');
insert into dbtypes(dbtype,dbtypedescription) values (2,'SQL Server');
insert into dbtypes(dbtype,dbtypedescription) values (3,'MySQL');
insert into dbtypes(dbtype,dbtypedescription) values (4,'ODBC authenticated');
insert into dbtypes(dbtype,dbtypedescription) values (5,'PostgreSQL');
insert into dbtypes(dbtype,dbtypedescription) values (6,'Derby');
insert into dbtypes(dbtype,dbtypedescription) values (7,'SQLite');
insert into dbtypes(dbtype,dbtypedescription) values (8,'JDBC generic');



CREATE TABLE usertypes(
	iusertype integer not null ,
	iusertypedescription varchar (50)  null,
	primary key usertypespk (iusertype) 
) ENGINE=InnoDB;


insert into usertypes(iusertype,iusertypedescription) values (0,'Registered User/Guest - no access');
insert into usertypes(iusertype,iusertypedescription) values (1,'Operator (add/edit/delete Datacards)');
insert into usertypes(iusertype,iusertypedescription) values (20,'Administrator (+ Event/Geography Management)');
insert into usertypes(iusertype,iusertypedescription) values (40,'Owner (+Region & User Management)');
insert into usertypes(iusertype,iusertypedescription) values (99,'Superuser (+ALL other privileges)');

-- once created, execute the following to create all tables:
CREATE TABLE country (
	scountryid varchar (30)  not null ,
	scountryname varchar (50) not null ,
	speriod varchar (50)  null ,
	slastupdated varchar (50)  null ,
	sdescriptiones varchar(2000)  null ,
	sdescriptionen varchar(2000)  null ,
	spagees varchar (250)  null ,
	spageen varchar (250)  null ,
	bpublic integer null ,
	sinstitution varchar (150)  null ,
	sdriver varchar (150)  null ,
	sdatabasename varchar (250)  null ,
	sodbcdriver varchar (250)  null ,
	sodbcdatabaseconnect varchar (250)  null ,
	sjetfilename varchar (255)  null ,
	susername varchar (50)  null ,
	spassword varchar (50)  null ,
	ndbtype integer null,
	primary key countrypk (scountryid ) 
) ENGINE=InnoDB;

alter table country add constraint countryfk1 foreign key (ndbtype) references dbtypes(dbtype) on delete cascade;



CREATE TABLE users (
	suserid varchar (30)  not null ,
	spassword varchar (50)  null ,
	iusertype integer null ,
	sfirstname varchar (50)  null ,
	slastname varchar (50)  null ,
	sorganization varchar (50)  null ,
	saddress1 varchar (50)  null ,
	saddress2 varchar (50)  null ,
	scity varchar (50)  null ,
	sstateprovince varchar (50)  null ,
	scountry varchar (30)  null ,
	spostalcode varchar (15)  null ,
	semailaddress varchar (255)  null ,
	sphonenumber varchar (50)  null ,
	salternatephonenumber varchar (50)  null ,
	sfaxnumber varchar (50)  null ,
	bnewuser integer null ,
	brecordstatus integer null ,
	bactive integer null ,
	dlastlogindate date null ,
	dusersince date null ,
	ifrequency integer null ,
	breceiveinstant integer null ,
	smemberorganizationid varchar (30)  null,
	primary key userspk (suserid) 
) ENGINE=InnoDB;


alter table users add constraint usersfk1 foreign key (iusertype) references usertypes(iusertype);

CREATE TABLE user_permissions (
	userid varchar (30)  not null ,
	country varchar (30) not null,
	primary key user_permissionspk (userid,country) 
) ENGINE=InnoDB;


alter table user_permissions add constraint user_permissionsfk1 foreign key (userid) references users (suserid) on delete cascade;
alter table user_permissions add constraint user_permissionsfk2 foreign key (country) references country (scountryid) on delete cascade;

CREATE TABLE user_subpermissions (
	userid varchar(30)  NOT NULL ,
	country varchar(30) NOT NULL ,
        region_level  integer NOT NULL,
	region_code varchar (30) NOT NULL,
	primary key user_subpermissionspk (userid,country,region_level,region_code) 

) ;

alter table user_subpermissions add constraint user_subpermissionsFK1 foreign key (userid) references users (suserid) on delete cascade;
alter table user_subpermissions add constraint user_subpermissionsFK2 foreign key  (country) references country (scountryid) on delete cascade;




-- MySQL database script
create table  datamodel   (
	revision int(10) not null, 
	build int(10), 
	slanguage varchar(10)
	);

insert into datamodel (revision, build, slanguage) values (1,0,'EN');
