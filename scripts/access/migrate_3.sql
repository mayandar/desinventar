-- ACCESS database upgrade script 3
alter TABLE diccionario add	tabnumber integer;
alter TABLE diccionario add	fieldtype integer;
alter TABLE fichas add	defaultab integer;

ALTER TABLE diccionario ADD CONSTRAINT PK_diccionario PRIMARY KEY (nombre_campo);

alter table extensioncodes drop constraint extensioncodesPK;
alter table extensioncodes add	field_name text (30) NOT NULL;
alter table extensioncodes drop column nfield;
alter table extensioncodes add CONSTRAINT extensioncodesPK PRIMARY KEY (field_name);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);

create table extensiontabs (
	ntab   integer not null, 
	nsort integer, 
	svalue text(40), 
	svalue_en text(40));  -- tabs for extension fields
alter table extensiontabs add constraint extensiontabsPK primary key (ntab);



