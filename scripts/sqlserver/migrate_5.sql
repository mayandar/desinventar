-- SQL Server database script

drop table  extensioncodes;

create table  extensioncodes   (
	nsort integer, 
	svalue nvarchar(40), 
	svalue_en nvarchar(40),
	field_name nvarchar (30) NOT NULL ,
	CONSTRAINT extensioncodesPK PRIMARY KEY (field_name,nsort)
	);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);


