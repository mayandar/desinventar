-- MySQL database script
create table  datamodel   (
	revision int(10) not null, 
	build int(10), 
	slanguage varchar(10),
	UNIQUE KEY `revision` (`revision`,`build`)
	);
insert into datamodel (revision, build) values (1,0);

create table  extensioncodes   (
	nsort int(10), 
	svalue varchar(40), 
	svalue_en varchar(40),
	field_name nvarchar2 (30) NOT NULL ,
	UNIQUE KEY `extensioncodesPK` (`field_name`)
	);

alter TABLE causas add causa_en varchar (25) NULL;
alter TABLE diccionario add	label_campo_en varchar (60)  NULL;
alter TABLE eventos add nombre_en varchar (15)   NULL;
alter TABLE lev0 add lev0_name_en varchar (30)  NULL; 
alter TABLE lev1 add lev1_name_en varchar (30)  NULL; 
alter TABLE lev2 add lev2_name_en varchar (30)  NULL; 
alter TABLE niveles add descripcion_en varchar (25)  NULL;
alter TABLE regiones add nombre_en varchar (30)  NULL;

