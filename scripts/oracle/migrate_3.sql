-- ORACLE database script
alter TABLE diccionario add	tabnumber number(4);
alter TABLE diccionario add	fieldtype number(4);
alter TABLE fichas add defaultab number(4);

ALTER TABLE diccionario DROP CONSTRAINT PK_diccionario;
ALTER TABLE diccionario ADD CONSTRAINT PK_diccionario PRIMARY KEY (nombre_campo);

alter table extensioncodes drop constraint extensioncodesPK;
alter table extensioncodes add	field_name nvarchar2(30) NOT NULL;
alter table extensioncodes drop column nfield;
alter table extensioncodes add CONSTRAINT extensioncodesPK PRIMARY KEY (field_name);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);


create table  extensiontabs(
	ntab   number(4) not null, 
	nsort number(4), 
	svalue nvarchar2(40), 
	svalue_en nvarchar2(40));
alter table extensiontabs add constraint extensiontabsPK primary key (ntab);

