-- Postgres database script
drop table  extensioncodes;

create table  extensioncodes   (
	nsort integer, 
	svalue varchar(40), 
	svalue_en varchar(40),
	field_name varchar (30) NOT NULL ,
	CONSTRAINT extensioncodesPK PRIMARY KEY (field_name,nsort)
	);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);


