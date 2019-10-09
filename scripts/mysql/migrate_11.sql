alter TABLE fichas alter fuentes varchar (255)   NULL;

alter TABLE fichas add di_comments TEXT;
update fichas set di_comments= concat(concat(ifnull(observa,''),ifnull(observa2,'')),ifnull(observa3,''));

alter table fichas add uu_id varchar(37);
update fichas set uu_id=UUID();

alter table fichas add KEY fichasu_inx (uu_id); 


drop view datacards;

create view datacards as
 Select serial, 
	   clave, 
	   evento as event, 
	   level0, 
	   name0, 
	   level1, 
	   name1, 
	   level2, 
	   name2,
	   lugar as place,
	   fechano as d_year,
	   fechames as d_month,
 	   fechadia as d_day,
	   duracion as duration, 
	   causa as cause, 
	   descausa as descr_cause, 
	   fuentes as sources, 
	   magnitud2 as magnitude, 
	   glide , 
	   otros as other, 
	   muertos as killed, 
	   heridos as injured, 
	   desaparece as missing, 
	   vivdest as houses_destroyed, 
	   vivafec as houses_damaged, 
	   damnificados as victims, 
	   afectados as affected, 
	   reubicados as relocated, 
	   evacuados as evacuated, 
	   valorus as value_us, 
	   valorloc as value_local, 
	   nescuelas as nschools, 
	   nhospitales as nhospitals, 
	   nhectareas as nhectares, 
	   cabezas as ncatle, 
	   kmvias as mts_roads, 
	   hay_muertos as with_killed, 
	   hay_heridos as with_injured, 
	   hay_deasparece as with_missing, 
	   hay_vivdest as with_houses_destroyed, 
	   hay_vivafec as with_hauses_damaged, 
	   hay_damnificados as with_victims, 
	   hay_afectados as with_affected, 
	   hay_reubicados as with_relocated, 
	   hay_evacuados as with_evacuated, 
	   educacion as education, 
	   salud as health, 
	   agropecuario as agriculture, 
	   acueducto as water, 
	   alcantarillado as sewage, 
	   industrias as industries, 
	   comunicaciones as communications, 
	   transporte as transportation, 
	   energia as power, 
	   socorro as relief, 
	   hay_otros as with_other, 
	   latitude, 
	   longitude,
	   di_comments as comments, 
	   defaultab,
	   approved,
	   uu_id from fichas;
	   
