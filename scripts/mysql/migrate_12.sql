--
-- SERIAL Sequence datacard_id  generator
-- 	
CREATE TABLE fichas_seq (
  nextval int(10) NOT NULL auto_increment,
  dum int(10)  NULL,
  PRIMARY KEY words_seq (nextval)
) ENGINE=InnoDB ;


insert into fichas_seq (dum) select clave from fichas;
delete from fichas_seq;

