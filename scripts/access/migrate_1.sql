-- ACCESS database script
create table  datamodel   (
	revision integer not null, 
	build integer, 
	slanguage text(10)
	);  -- this will contain the current model and language of the database

create table  extensioncodes   (
	nfield   integer not null, 
	nsort integer, 
	svalue text(40), 
	svalue_en text(40));  -- tabs for extension fields
alter table extensioncodes add constraint extensioncodesPK primary key (nfield);

alter TABLE causas add causa_en text(25)  NULL;
alter TABLE diccionario add	label_campo_en text (60)  NULL;
alter TABLE eventos add nombre_en text (30)   NULL;
alter TABLE eventos alter column nombre text (30)   NULL;
alter TABLE lev0 add lev0_name_en text (30)  NULL; 
alter TABLE lev1 add lev1_name_en text (30)  NULL; 
alter TABLE lev2 add lev2_name_en text (30)  NULL; 
alter TABLE niveles add descripcion_en text (25)  NULL;
alter TABLE regiones add nombre_en text (30)  NULL;


