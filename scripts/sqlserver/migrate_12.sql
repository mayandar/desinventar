--
-- SERIAL Sequence datacard_id  generator
-- 	
CREATE TABLE fichas_seq (
	nextval int IDENTITY (1, 1) NOT NULL ,
	dum int NULL 
);

insert into fichas_seq (dum) select clave from fichas;
delete from fichas_seq;

