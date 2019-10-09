
delete from wordsdocs;
delete from words;
delete from extension;
delete from fichas;
delete from lev2;
delete from lev1;
delete from lev0;
delete from regiones;

delete from LEC_cpi;
delete from LEC_exchange;

delete from event_grouping;
delete from eventos;
delete from causas;
delete from info_maps;
delete from level_maps;
delete from level_attributes;
delete from attribute_metadata;
delete from niveles;

-- up to here deletes data. next statements will drop the extension definition
delete from diccionario;
delete from extensioncodes;
delete from extensiontabs;
drop table extension;

CREATE TABLE extension (clave_ext integer NOT NULL ) ;
ALTER TABLE extension ADD CONSTRAINT PK_extension PRIMARY KEY   (clave_ext)  ;
ALTER TABLE extension ADD CONSTRAINT FK_extension_fichas FOREIGN KEY (clave_ext) REFERENCES fichas (clave) ;
