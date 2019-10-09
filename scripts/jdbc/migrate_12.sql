--
-- SERIAL Sequence datacard_id  generator
-- 	
CREATE TABLE fichas_seq (
	nextval COUNTER,
	dum int  NULL 
);

insert into fichas_seq (dum) select clave from fichas;
delete from fichas_seq;

