-- ACCESS database script - upgrade to data model version 8
alter TABLE eventos alter column nombre text (30)   NULL;
alter TABLE eventos alter column nombre_en text (30)   NULL;
alter table fichas alter column causa text(25);

alter table extensioncodes drop constraint extensioncodesFK;
update diccionario set nombre_campo=ucase(nombre_campo);
update extensioncodes set field_name=ucase(field_name);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);
 
 



