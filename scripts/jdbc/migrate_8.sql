-- Postgres database script - upgrade to data model version 8
alter table extensioncodes drop constraint extensioncodesFK;
update diccionario set nombre_campo=UPPER(nombre_campo);
update extensioncodes set field_name=UPPER(field_name);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);
 