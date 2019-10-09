ALTER TABLE lev1 ADD CONSTRAINT FK_lev1_lev0 FOREIGN KEY (lev1_lev0) REFERENCES lev0 (lev0_cod);
ALTER TABLE lev2 ADD CONSTRAINT FK_lev2_lev1 FOREIGN KEY (lev2_lev1) REFERENCES lev1 (lev1_cod) ;
delete from extension where clave_ext not in (select clave from fichas);
insert into extension (clave_ext) select clave from fichas where clave not in (select clave_ext from extension);
ALTER TABLE extension ADD CONSTRAINT FK_extension_fichas FOREIGN KEY (clave_ext) REFERENCES fichas (clave) ; 
insert into eventos (nombre, nombre_en) select evento,evento  from fichas where evento not in (select nombre from eventos);
ALTER TABLE fichas ADD CONSTRAINT FK_fichas_eventos FOREIGN KEY (evento) REFERENCES eventos (nombre);
insert into causas (causa, causa_en) select causa,causa  from fichas where causa not in (select causa from causas);
ALTER TABLE fichas ADD CONSTRAINT FK_fichas_causas FOREIGN KEY (causa) REFERENCES causas (causa) ;
ALTER TABLE fichas ADD CONSTRAINT FK_fichas_lev0 FOREIGN KEY (level0) REFERENCES lev0 (lev0_cod) ;
ALTER TABLE fichas ADD CONSTRAINT FK_fichas_lev1 FOREIGN KEY (level1) REFERENCES lev1 (lev1_cod) ;
ALTER TABLE fichas ADD CONSTRAINT FK_fichas_lev2 FOREIGN KEY (level2) REFERENCES lev2 (lev2_cod) ;
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo) ;
ALTER TABLE wordsdocs ADD CONSTRAINT FK_wordsdocs_fichas FOREIGN KEY (docid) REFERENCES fichas (clave) ;


