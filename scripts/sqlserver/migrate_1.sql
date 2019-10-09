-- SQL Server database script

create table  datamodel   (revision integer not null, build integer,  slanguage varchar(10));
insert into datamodel (revision, build) values (1,0);
create table  extensioncodes   (nfield   integer not null, nsort integer, svalue nvarchar(40), svalue_en nvarchar(40));
alter table extensioncodes add constraint extensioncodesPK primary key (nfield);

alter TABLE causas add causa_en nvarchar (25)  NULL;
alter TABLE diccionario add	label_campo_en nvarchar (60)  NULL;
alter TABLE eventos add nombre_en nvarchar (15)   NULL;
alter TABLE lev0 add lev0_name_en nvarchar (30)  NULL; 
alter TABLE lev1 add lev1_name_en nvarchar (30)  NULL; 
alter TABLE lev2 add lev2_name_en nvarchar (30)  NULL; 
alter TABLE niveles add descripcion_en nvarchar (25)  NULL;
alter TABLE regiones add nombre_en nvarchar (30)  NULL;
