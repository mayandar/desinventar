-- SQL Server database script

alter TABLE diccionario add	tabnumber integer;
alter TABLE diccionario add	fieldtype integer;
alter TABLE fichas add defaultab integer;

ALTER TABLE diccionario DROP CONSTRAINT PK_diccionario;
ALTER TABLE diccionario ALTER COLUMN nombre_campo nvarchar(30) NOT NULL;
ALTER TABLE diccionario ADD CONSTRAINT PK_diccionario PRIMARY KEY (nombre_campo);


alter table extensioncodes drop constraint extensioncodesPK;
alter table extensioncodes add	field_name nvarchar(30) NOT NULL default 'F1';
alter table extensioncodes drop column nfield;
alter table extensioncodes add CONSTRAINT extensioncodesPK PRIMARY KEY (field_name);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);

create table  extensiontabs(
	ntab   integer not null, 
	nsort integer, 
	svalue nvarchar(40), 
	svalue_en nvarchar(40));
alter table extensiontabs add constraint extensiontabsPK primary key (ntab);

