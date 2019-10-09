CREATE TABLE causas (
	causa varchar (25)  NOT NULL,
	causa_en varchar (25)  NULL,
	CONSTRAINT PK_causas PRIMARY KEY  (	causa)    
); 

CREATE TABLE diccionario (
	orden integer NOT NULL ,
	nombre_campo varchar (30)  NULL ,
	descripcion_campo varchar (180)  NULL ,
	label_campo varchar (60)  NULL ,
	label_campo_en varchar (60)  NULL ,
	pos_x integer NULL ,
	pos_y integer NULL ,
	lon_x integer NULL ,
	lon_y integer NULL ,
	color integer NULL,
	tabnumber integer NULL,
	fieldtype integer NULL,
	CONSTRAINT PK_diccionario PRIMARY KEY (nombre_campo )
); 

CREATE TABLE eventos (
	serial integer NULL ,
	nombre varchar (30)  NOT NULL ,
	nombre_en varchar (30)  NULL ,
	descripcion varchar (200)  NULL ,
	parent varchar (30),
	terminal int,
	hlevel int,
	CONSTRAINT PK_eventos PRIMARY KEY (nombre),
	constraint eventos_hierarchyFK foreign key (parent) references eventos(nombre) 
    );
 

CREATE TABLE lev0 (
	lev0_cod varchar (15)  NOT NULL ,
	lev0_name varchar (30)  NULL,
	lev0_name_en varchar (30)  NULL, 
	CONSTRAINT PK_lev0 PRIMARY KEY (lev0_cod)
); 

CREATE TABLE lev1 (
	lev1_cod varchar (15)  NOT NULL ,
	lev1_name varchar (30)  NULL ,
	lev1_name_en varchar (30)  NULL ,
	lev1_lev0 varchar (15)  NULL, 
	CONSTRAINT PK_lev1 PRIMARY KEY (lev1_cod)
); 

CREATE TABLE lev2 (
	lev2_cod varchar (15)  NOT NULL ,
	lev2_name varchar (30)  NULL ,
	lev2_name_en varchar (30)  NULL ,
	lev2_lev1 varchar (15)  NULL,
	CONSTRAINT PK_lev2 PRIMARY KEY (lev2_cod)  
 ); 

CREATE TABLE fichas (
	serial varchar (15)  NULL ,
	level0 varchar (15)  NULL ,
	level1 varchar (15)  NULL ,
	level2 varchar (15)  NULL ,
	name0 varchar (30)  NULL ,
	name1 varchar (30)  NULL ,
	name2 varchar (30)  NULL ,
	evento varchar (30)  NULL ,
	lugar varchar (60)  NULL ,
	fechano integer NULL ,
	fechames integer NULL ,
	fechadia integer NULL ,
	muertos integer NULL ,
	heridos integer NULL ,
	desaparece integer NULL ,
	afectados integer NULL ,
	vivdest integer NULL ,
	vivafec integer NULL ,
	otros varchar (60)  NULL ,
	fuentes varchar (255)  NULL ,
	valorloc float NULL ,
	valorus float NULL ,
	fechapor varchar (12)  NULL ,
	fechafec varchar (12)  NULL ,
	hay_muertos integer NULL ,
	hay_heridos integer NULL ,
	hay_deasparece integer NULL ,
	hay_afectados integer NULL ,
	hay_vivdest integer NULL ,
	hay_vivafec integer NULL ,
	hay_otros integer NULL ,
	socorro integer NULL ,
	salud integer NULL ,
	educacion integer NULL ,
	agropecuario integer NULL ,
	industrias integer NULL ,
	acueducto integer NULL ,
	alcantarillado integer NULL ,
	energia integer NULL ,
	comunicaciones integer NULL ,
	causa varchar (25)  NULL ,
	descausa varchar (60)  NULL ,
	transporte integer NULL ,
	Magnitud2 varchar (25)  NULL ,
	nhospitales integer NULL ,
	nescuelas integer NULL ,
	nhectareas float NULL ,
	cabezas integer NULL ,
	Kmvias float NULL ,
	duracion integer NULL ,
	damnificados integer NULL ,
	evacuados integer NULL ,
	hay_damnificados integer NULL ,
	hay_evacuados integer NULL ,
	hay_reubicados integer NULL ,
	reubicados integer NULL ,
	clave integer PRIMARY KEY AUTOINCREMENT,
	glide varchar (30)  NULL,
	defaultab integer NULL,
	approved  integer,
	latitude float NULL ,
	longitude float NULL,
	uu_id varchar(37),
	di_comments CLOB,
	CONSTRAINT FK_fichas_causas FOREIGN KEY (causa) REFERENCES causas (causa),
	CONSTRAINT FK_fichas_eventos FOREIGN KEY (evento) REFERENCES eventos (nombre),
	CONSTRAINT FK_fichas_lev0 FOREIGN KEY (level0) REFERENCES lev0 (lev0_cod),
	CONSTRAINT FK_fichas_lev1 FOREIGN KEY (level1) REFERENCES lev1 (lev1_cod),
	CONSTRAINT FK_fichas_lev2 FOREIGN KEY (level2) REFERENCES lev2 (lev2_cod)
); 

CREATE TABLE extension (
	clave_ext integer NOT NULL,	
	CONSTRAINT PK_extension PRIMARY KEY (clave_ext),   
	CONSTRAINT FK_extension_fichas FOREIGN KEY (clave_ext) REFERENCES fichas (clave)
); 



CREATE TABLE niveles (
	nivel integer NOT NULL ,
	descripcion varchar (25)  NULL ,
	descripcion_en varchar (25)  NULL ,
	longitud integer NULL,
	CONSTRAINT PK_niveles PRIMARY KEY (nivel)
); 

CREATE TABLE regiones (
	codregion varchar (15)  NOT NULL ,
	nombre varchar (30)  NULL ,
	nombre_en varchar (30)  NULL ,
	x float NULL ,
	y float NULL ,
	angulo float NULL ,
	xmin float NULL ,
	ymin float NULL ,
	xmax float NULL ,
	ymax float NULL ,
	xtext float NULL ,
	ytext float NULL ,
	nivel integer NULL ,
	ap_lista integer NULL ,
	lev0_cod varchar (15)  NULL,
	CONSTRAINT PK_regiones PRIMARY KEY  (codregion)
) ;

CREATE TABLE words (
	wordid integer NOT NULL ,
	word varchar (32)  NOT NULL ,
	occurrences integer NULL,
	CONSTRAINT WORDPK PRIMARY KEY (word),
	CONSTRAINT IX_words UNIQUE (wordid)	 
); 

CREATE TABLE words_seq (
	nextval integer PRIMARY KEY AUTOINCREMENT ,
	dum int NULL 
); 


CREATE TABLE wordsdocs (
	docid integer NOT NULL ,
	wordid integer NOT NULL ,
	occurrences integer NULL, 
	CONSTRAINT PK_wordsdocs PRIMARY KEY (docid,	wordid),
	CONSTRAINT FK_wordsdocs_fichas FOREIGN KEY (docid) REFERENCES fichas (clave)
	);   

 CREATE  INDEX IX_fichas ON fichas(serial);

 CREATE  INDEX IX_fichas_1 ON fichas(level0) ;

 CREATE  INDEX IX_fichas_2 ON fichas(level1) ;

 CREATE  INDEX IX_fichas_3 ON fichas(level2) ;

 CREATE  INDEX IX_fichas_4 ON fichas(evento) ;

 CREATE  INDEX IX_fichas_5 ON fichas(glide) ;

 CREATE  INDEX IX_regiones_parent ON regiones(lev0_cod); 

 create index fichasu_inx on fichas(uu_id); 
 

create index clave_ext_inx on extension (clave_ext);



create table  datamodel   (
	revision integer not null, 
	build integer,  
	slanguage varchar(10),
	CONSTRAINT PK_datamodel PRIMARY KEY (revision,build)
	);


create table  extensioncodes   (
	nsort integer, 
	svalue varchar(40), 
	svalue_en varchar(40),
	field_name varchar (30) NOT NULL ,
	code_value varchar (30) NOT NULL ,
	CONSTRAINT extensioncodesPK PRIMARY KEY (field_name,code_value),
	constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo)
	);

create table  extensiontabs(
	ntab   integer not null, 
	nsort integer, 
	svalue varchar(40), 
	svalue_en varchar(40),
	constraint extensiontabsPK primary key (ntab)
	);


CREATE TABLE attribute_metadata (
	field_table varchar (50)  NOT NULL ,
	field_name varchar (50)  NOT NULL ,
	field_label varchar (50)  NULL ,
	field_label_en varchar (50)  NULL ,
	field_description varchar (255)  NULL ,
	field_description_en varchar (255)  NULL ,
	field_date varchar (50)  NULL ,
	field_source varchar (50)  NULL, 
	CONSTRAINT PK_attribute_metadata PRIMARY KEY (field_table,field_name)	
);

CREATE TABLE info_maps (
	filename varchar (255)  NOT NULL ,
	layer_name varchar (50)  NULL ,
	layer_name_en varchar (50)  NULL ,
	layer integer NULL ,
	visible integer NULL ,
	filetype varchar (50)  NULL ,
	color_red integer NULL ,
	color_green integer NULL ,
	color_blue integer NULL ,
	line_thickness integer NULL ,
	line_type integer NULL ,
	projection_system integer NULL ,
	projection_type integer NULL ,
	projection_driver varchar (255)  NULL ,
	projection_par0 float NULL ,
	projection_par1 float NULL ,
	projection_par2 float NULL ,
	projection_par3 float NULL ,
	projection_par4 float NULL ,
	projection_par5 float NULL ,
	projection_par6 float NULL ,
	projection_par7 float NULL ,
	projection_par8 float NULL ,
	projection_par9 float NULL ,
	CONSTRAINT PK_info_maps PRIMARY KEY (filename)
	);

CREATE TABLE level_attributes (
	table_level integer NOT NULL ,
	table_name varchar (50)  NULL ,
	table_code varchar (50)  NULL ,
	CONSTRAINT PK_level_attributes PRIMARY KEY (table_level)	
);

CREATE TABLE level_maps (
	map_level integer NOT NULL ,
	filename varchar (255)  NULL ,
	lev_code varchar (50)  NULL ,
	lev_name varchar (50)  NULL ,
	filetype varchar (50)  NULL ,
	color_red integer NULL ,
	color_green integer NULL ,
	color_blue integer NULL ,
	line_thickness integer NULL ,
	line_type integer NULL ,
	projection_system integer NULL ,
	projection_type integer NULL ,
	projection_driver varchar (255)  NULL ,
	projection_par0 float NULL ,
	projection_par1 float NULL ,
	projection_par2 float NULL ,
	projection_par3 float NULL ,
	projection_par4 float NULL ,
	projection_par5 float NULL ,
	projection_par6 float NULL ,
	projection_par7 float NULL ,
	projection_par8 float NULL ,
	projection_par9 float NULL ,
	CONSTRAINT PK_level_maps PRIMARY KEY (map_level)
);

	

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
	   
CREATE view causes as select causa as cause, causa_en as cause_en from causas;

CREATE view dictionary as 
  select orden as sort_order, 
	nombre_campo as field_name,
	descripcion_campo as field_description,
	label_campo as field_label ,
	label_campo_en as field_label_en,
	pos_x ,
	pos_y ,
	lon_x ,
	lon_y ,
	color,
	tabnumber,
	fieldtype from diccionario;

CREATE view events as 
  select serial,
	nombre as name,
	nombre_en as name_en,
	descripcion as description from eventos;

CREATE view levels as
	select nivel as nlevel,
	descripcion as description,
	descripcion_en as description_en,
	longitud as code_length 
	from niveles;
	
CREATE view region  as 
 select codregion,
 	nombre as name,
	nombre_en as name_en,
	x,
	y,
	angulo as angle,
	xmin,
	ymin,
	xmax,
	ymax,
	xtext,
	ytext,
	nivel as nlevel,
	ap_lista as ptr_list,
	lev0_cod from regiones;
	
--
-- SERIAL Sequence datacard_id  generator
-- 	
CREATE TABLE fichas_seq (
	nextval integer PRIMARY KEY AUTOINCREMENT ,
	dum int NULL 
); 


create table  LEC_cpi (
   lec_year  int not null,
   lec_cpi  float,
   constraint LEC_cpiPK PRIMARY KEY (lec_year)
   );

create table  LEC_exchange (
   lec_year  int not null,
   lec_rate  float,
   constraint LEC_exchangePK PRIMARY KEY (lec_year)
   );

CREATE TABLE event_grouping (
	nombre varchar (30)  NOT NULL ,
	lec_grouping_days int,
	category  varchar(30),
	constraint event_groupingPK PRIMARY KEY (nombre),
	constraint eventos_h_hierarchyFK foreign key (nombre) references eventos(nombre)
); 

create index approved_inx on fichas (approved);

create table  media_type 
   (
   media_type int not null,
   media_type_name varchar(50),
   media_type_name_en varchar(50),
   media_type_extensions varchar(50),
   constraint media_type_PK PRIMARY KEY (media_type)
   );

insert into media_type (media_type, media_type_name, media_type_name_en ,media_type_extensions) values (1,'MS Word','','doc,docx');
insert into media_type (media_type, media_type_name, media_type_name_en ,media_type_extensions) values (2,'MS Excel','','xls,xlsx');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (3,'MS PowerPoint','ppt,pptx','');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (4,'PDF','','pdf');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (5,'Picture','','jpg,png,gif');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (6,'Video','','mpg4');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (7,'URL','','');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (8,'Text file','','txt,prn');
insert into media_type (media_type, media_type_name, media_type_name_en, media_type_extensions) values (9,'ZIP data file','','zip,7z,tar,gz');
update media_type set media_type_name_en=media_type_name;

create table  media_file 
   (
   imedia int not null,
   iclave int not null,
   media_type int,
   media_title varchar(50),
   media_title_en varchar(50),
   media_file varchar (50),
   media_description varchar (255),
   media_description_en varchar (255),
   media_link varchar (255),
   constraint media_file_PK PRIMARY KEY (imedia),
   constraint media_file_fichasFK foreign key (iclave) references fichas(clave),
   constraint media_file_typeFK foreign key (media_type) references media_type(media_type)
   );



CREATE TABLE media_seq (
	nextval integer PRIMARY KEY AUTOINCREMENT ,
	dum int NULL
); 


 
delete from datamodel;
insert into datamodel (revision, build) values (13,0);



