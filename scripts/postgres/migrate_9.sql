ALTER TABLE fichas drop CONSTRAINT FK_fichas_eventos;
alter TABLE fichas alter column evento type varchar (30);
ALTER TABLE fichas ADD 	CONSTRAINT FK_fichas_eventos FOREIGN KEY (evento) REFERENCES eventos (nombre);
alter table fichas add latitude float;
alter table fichas add longitude float;


