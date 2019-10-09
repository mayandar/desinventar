
drop table  extensioncodes;

create table  extensioncodes (
	nsort number(5), 
	svalue nvarchar2(40), 
	svalue_en nvarchar2(40),
	field_name nvarchar2 (30) NOT NULL ,
	CONSTRAINT extensioncodesPK PRIMARY KEY (field_name,nsort)
	);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);


