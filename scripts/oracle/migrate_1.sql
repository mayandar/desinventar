-- ORACLE database script
create table  datamodel   (
	revision number(5) not null, 
	build number(6),  
	slanguage varchar2(10));
insert into datamodel (revision, build) values (1,0);

create table  extensioncodes   (
	nfield   number(5) not null, 
	nsort number(5), 
	svalue nvarchar2(40), 
	svalue_en nvarchar2(40));
alter table extensioncodes add constraint extensioncodesPK primary key (nfield);

alter TABLE causas add causa_en nvarchar2 (25)   NULL;
alter TABLE diccionario add	label_campo_en nvarchar2 (60)  NULL;
alter TABLE eventos add nombre_en nvarchar2 (15)   NULL;
alter TABLE lev0 add lev0_name_en nvarchar2 (30)  NULL; 
alter TABLE lev1 add lev1_name_en nvarchar2 (30)  NULL; 
alter TABLE lev2 add lev2_name_en nvarchar2 (30)  NULL; 
alter TABLE niveles add descripcion_en nvarchar2 (25)  NULL;
alter TABLE regiones add nombre_en nvarchar2 (30)  NULL;

