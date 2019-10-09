-- ACCESS database script - upgrade to data model version 5
drop table  extensioncodes;

create table  extensioncodes   (
	nsort integer not null, 
	svalue text(40), 
	svalue_en text(40),
	field_name text (30) NOT NULL 
	);  -- tabs for extension fields	

alter table extensioncodes add constraint extensioncodesPK primary key (field_name,nsort);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);




