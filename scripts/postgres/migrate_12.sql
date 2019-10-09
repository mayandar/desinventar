--
-- SERIAL Sequence datacard_id  generator
-- 	
CREATE sequence fichas_seq;
select nextval('fichas_seq'), clave from fichas;

