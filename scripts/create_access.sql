CREATE TABLE causas (
	causa text (25)  NOT NULL,
	causa_en text (25)  NULL 
); 

CREATE TABLE diccionario (
	orden smallint NOT NULL ,
	nombre_campo text (30)  NOT NULL ,
	descripcion_campo text (180)  NULL ,
	label_campo text (60)  NULL ,
	label_campo_en text (60)  NULL ,
	pos_x smallint NULL ,
	pos_y smallint NULL ,
	lon_x smallint NULL ,
	lon_y smallint NULL ,
	color int NULL ,
	tabnumber smallint NULL,
	fieldtype smallint NULL
); 

CREATE TABLE eventos (
	serial smallint NULL ,
	nombre text (30)  NOT NULL ,
	nombre_en text (30) NULL ,
	descripcion text (200)  NULL ,
	parent text (30) NULL,
	terminal smallint NULL,
	hlevel int NULL
); 


CREATE TABLE extension (
	clave_ext int NOT NULL 
); 

CREATE TABLE fichas (
	serial text (15)  NULL ,
	level0 text (15)  NULL ,
	level1 text (15)  NULL ,
	level2 text (15)  NULL ,
	name0 text (30)  NULL ,
	name1 text (30)  NULL ,
	name2 text (30)  NULL ,
	evento text (30)  NULL ,
	lugar text (60)  NULL ,
	fechano smallint NULL ,
	fechames smallint NULL ,
	fechadia smallint NULL ,
	muertos int NULL ,
	heridos int NULL ,
	desaparece int NULL ,
	afectados int NULL ,
	vivdest int NULL ,
	vivafec int NULL ,
	otros text (60)  NULL ,
	fuentes text (255)  NULL ,
	valorloc float NULL ,
	valorus float NULL ,
	fechapor text (12)  NULL ,
	fechafec text (12)  NULL ,
	hay_muertos smallint NOT NULL ,
	hay_heridos smallint NOT NULL ,
	hay_deasparece smallint NOT NULL ,
	hay_afectados smallint NOT NULL ,
	hay_vivdest smallint NOT NULL ,
	hay_vivafec smallint NOT NULL ,
	hay_otros smallint NOT NULL ,
	socorro smallint NOT NULL ,
	salud smallint NOT NULL ,
	educacion smallint NOT NULL ,
	agropecuario smallint NOT NULL ,
	industrias smallint NOT NULL ,
	acueducto smallint NOT NULL ,
	alcantarillado smallint NOT NULL ,
	energia smallint NOT NULL ,
	comunicaciones smallint NOT NULL ,
	causa text (25)  NULL ,
	descausa text (60)  NULL ,
	transporte smallint NOT NULL ,
	Magnitud2 text (25)  NULL ,
	nhospitales int NULL ,
	nescuelas int NULL ,
	nhectareas float NULL ,
	cabezas int NULL ,
	Kmvias float NULL ,
	duracion int NULL ,
	damnificados int NULL ,
	evacuados int NULL ,
	hay_damnificados smallint NOT NULL ,
	hay_evacuados smallint NOT NULL ,
	hay_reubicados smallint NOT NULL ,
	reubicados int NULL ,
	clave int IDENTITY (1, 1) NOT NULL ,
	glide text (30)  NULL ,
	defaultab smallint NULL ,
	approved  smallint NULL,
	latitude  float null,
	longitude  float null,
	uu_id text(37),
	di_comments memo	
); 

CREATE TABLE lev0 (
	lev0_cod text (15)  NOT NULL ,
	lev0_name text (30)  NULL, 
	lev0_name_en text (30)  NULL 
); 

CREATE TABLE lev1 (
	lev1_cod text (15)  NOT NULL ,
	lev1_name text (30)  NULL ,
	lev1_name_en text (30)  NULL ,
	lev1_lev0 text (15)  NULL 
); 

CREATE TABLE lev2 (
	lev2_cod text (15)  NOT NULL ,
	lev2_name text (30)  NULL ,
	lev2_name_en text (30)  NULL ,
	lev2_lev1 text (15)  NULL 
); 

CREATE TABLE niveles (
	nivel int NOT NULL ,
	descripcion text (25)  NULL ,
	descripcion_en text (25)  NULL ,
	longitud smallint NULL 
); 

CREATE TABLE regiones (
	codregion text (15)  NOT NULL ,
	nombre text (30)  NULL ,
	nombre_en text (30)  NULL ,
	x float NULL ,
	y float NULL ,
	angulo float NULL ,
	xmin float NULL ,
	ymin float NULL ,
	xmax float NULL ,
	ymax float NULL ,
	xtext float NULL ,
	ytext float NULL ,
	nivel int NULL ,
	ap_lista int NULL ,
	lev0_cod text (15)  NULL 
) ;

CREATE TABLE words (
	wordid int NOT NULL ,
	word text (32)  NOT NULL ,
	occurrences int NULL 
); 

CREATE TABLE words_seq (
	nextval autoincrement,
	dum int NULL 
); 

CREATE TABLE wordsdocs (
	docid int NOT NULL ,
	wordid int NOT NULL ,
	occurrences int NULL 
);




ALTER TABLE causas WITH NOCHECK ADD 
	CONSTRAINT PK_causas PRIMARY KEY   
	(
		causa
	);
	
ALTER TABLE diccionario WITH NOCHECK ADD 
	CONSTRAINT PK_diccionario PRIMARY KEY   
	(
		nombre_campo 
	);   


ALTER TABLE eventos WITH NOCHECK ADD 
	CONSTRAINT PK_eventos PRIMARY KEY   
	(
		nombre
	);   

alter table eventos add		constraint eventos_hierarchyFK foreign key (parent) references eventos(nombre);
ALTER TABLE extension WITH NOCHECK ADD 
	CONSTRAINT PK_extension PRIMARY KEY   
	(
		clave_ext
	);   

ALTER TABLE fichas WITH NOCHECK ADD 
	CONSTRAINT PK_fichas PRIMARY KEY   
	(
		clave
	);   

ALTER TABLE lev0 WITH NOCHECK ADD 
	CONSTRAINT PK_lev0 PRIMARY KEY   
	(
		lev0_cod
	);   

ALTER TABLE lev1 WITH NOCHECK ADD 
	CONSTRAINT PK_lev1 PRIMARY KEY   
	(
		lev1_cod
	);   

ALTER TABLE lev2 WITH NOCHECK ADD 
	CONSTRAINT PK_lev2 PRIMARY KEY   
	(
		lev2_cod
	);   

ALTER TABLE niveles WITH NOCHECK ADD 
	CONSTRAINT PK_niveles PRIMARY KEY   
	(
		nivel
	);   


ALTER TABLE regiones WITH NOCHECK ADD 
	CONSTRAINT PK_regiones PRIMARY KEY   
	(
		codregion
	);  

ALTER TABLE words WITH NOCHECK ADD 
	CONSTRAINT WORDPK PRIMARY KEY   
	(
		word
	);   

ALTER TABLE wordsdocs WITH NOCHECK ADD 
	CONSTRAINT PK_wordsdocs PRIMARY KEY   
	(
		docid,
		wordid
	);   

 CREATE  INDEX IX_fichas ON fichas(serial); 

 CREATE  INDEX IX_fichas_1 ON fichas(level0); 

 CREATE  INDEX IX_fichas_2 ON fichas(level1);

 CREATE  INDEX IX_fichas_3 ON fichas(level2); 

 CREATE  INDEX IX_fichas_4 ON fichas(evento); 

 CREATE  INDEX IX_fichas_5 ON fichas(glide);

 CREATE  INDEX IX_regiones_parent ON regiones(lev0_cod); 

 create index fichasu_inx on fichas(uu_id); 

 create index clave_ext_inx on extension (clave_ext);

ALTER TABLE words ADD 
	CONSTRAINT IX_words UNIQUE 
	(
		wordid
	);

ALTER TABLE extension ADD 
	CONSTRAINT FK_extension_fichas FOREIGN KEY 
	(
		clave_ext
	) REFERENCES fichas (
		clave
	); 


ALTER TABLE fichas ADD 
	CONSTRAINT FK_fichas_causas FOREIGN KEY 
	(
		causa
	) REFERENCES causas (
		causa
	),
	CONSTRAINT FK_fichas_eventos FOREIGN KEY 
	(
		evento
	) REFERENCES eventos (
		nombre
	) ,
	CONSTRAINT FK_fichas_lev0 FOREIGN KEY 
	(
		level0
	) REFERENCES lev0 (
		lev0_cod
	) ,
	CONSTRAINT FK_fichas_lev1 FOREIGN KEY 
	(
		level1
	) REFERENCES lev1 (
		lev1_cod
	) ,
	CONSTRAINT FK_fichas_lev2 FOREIGN KEY 
	(
		level2
	) REFERENCES lev2 (
		lev2_cod
	) ;

ALTER TABLE wordsdocs ADD 
	CONSTRAINT FK_wordsdocs_fichas FOREIGN KEY 
	(
		docid
	) REFERENCES fichas (
		clave
	) ;
	
create table  datamodel   (
	revision integer not null, 
	build integer,  
	slanguage text(10),
	CONSTRAINT PK_datamodel PRIMARY KEY (revision,build)   
);


create table  extensioncodes   (
	nsort integer, 
	svalue text(40), 
	svalue_en text(40),
	field_name text (30) NOT NULL ,
	code_value text (30) NOT NULL ,
	CONSTRAINT extensioncodesPK PRIMARY KEY (field_name,code_value)
	);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);

create table  extensiontabs(
	ntab   integer not null, 
	nsort integer, 
	svalue text(40), 
	svalue_en text(40));
alter table extensiontabs add constraint extensiontabsPK primary key (ntab);


CREATE TABLE attribute_metadata (
	field_table text (50)  NOT NULL ,
	field_name text (50)  NOT NULL ,
	field_label text (50)  NULL ,
	field_label_en text (50)  NULL ,
	field_description text (255)  NULL ,
	field_description_en text (255)  NULL ,
	field_date text (50)  NULL ,
	field_source text (50)  NULL 
);

CREATE TABLE info_maps (
	filename text (255)  NOT NULL ,
	layer_name text (50)  NULL ,
	layer_name_en text (50)  NULL ,
	layer smallint NULL ,
	visible smallint NULL ,
	filetype text (50)  NULL ,
	color_red smallint NULL ,
	color_green smallint NULL ,
	color_blue smallint NULL ,
	line_thickness smallint NULL ,
	line_type smallint NULL ,
	projection_system int NULL ,
	projection_type int NULL ,
	projection_driver text (255)  NULL ,
	projection_par0 float NULL ,
	projection_par1 float NULL ,
	projection_par2 float NULL ,
	projection_par3 float NULL ,
	projection_par4 float NULL ,
	projection_par5 float NULL ,
	projection_par6 float NULL ,
	projection_par7 float NULL ,
	projection_par8 float NULL ,
	projection_par9 float NULL 
);

CREATE TABLE level_attributes (
	table_level int NOT NULL ,
	table_name text (50)  NULL ,
	table_code text (50)  NULL 
);

CREATE TABLE level_maps (
	map_level int NOT NULL ,
	filename text (255)  NULL ,
	lev_code text (50)  NULL ,
	lev_name text (50)  NULL ,
	filetype text (50)  NULL ,
	color_red smallint NULL ,
	color_green smallint NULL ,
	color_blue smallint NULL ,
	line_thickness smallint NULL ,
	line_type smallint NULL ,
	projection_system int NULL ,
	projection_type int NULL ,
	projection_driver text (255)  NULL ,
	projection_par0 float NULL ,
	projection_par1 float NULL ,
	projection_par2 float NULL ,
	projection_par3 float NULL ,
	projection_par4 float NULL ,
	projection_par5 float NULL ,
	projection_par6 float NULL ,
	projection_par7 float NULL ,
	projection_par8 float NULL ,
	projection_par9 float NULL 
);

ALTER TABLE attribute_metadata WITH NOCHECK ADD 
	CONSTRAINT PK_attribute_metadata PRIMARY KEY   
	(
		field_table,field_name
	);
	

ALTER TABLE info_maps WITH NOCHECK ADD 
	CONSTRAINT PK_info_maps PRIMARY KEY   
	(
		filename
	);
	
ALTER TABLE level_attributes WITH NOCHECK ADD 
	CONSTRAINT PK_level_attributes PRIMARY KEY   
	(
		table_level
	);
	

ALTER TABLE level_maps WITH NOCHECK ADD 
	CONSTRAINT PK_level_maps PRIMARY KEY   
	(
		map_level
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
	nextval autoincrement,
	dum int NULL 
);


create table  LEC_cpi (
   lec_year  smallint not null,
   lec_cpi  float);
alter table LEC_cpi  add constraint LEC_cpiPK PRIMARY KEY (lec_year);

create table  LEC_exchange (
   lec_year  smallint not null,
   lec_rate  float);
alter table LEC_exchange  add constraint LEC_exchangePK PRIMARY KEY (lec_year);

CREATE TABLE event_grouping (
	nombre text (30)  NOT NULL ,
	lec_grouping_days smallint,
	category  text(30)
); 
alter table event_grouping add constraint event_groupingPK PRIMARY KEY (nombre);
alter table event_grouping add constraint eventos_h_hierarchyFK foreign key (nombre) references eventos(nombre);

create index approved_inx on fichas (approved);





create table  media_type 
   (
   media_type int,
   media_type_name text(50),
   media_type_name_en text(50),
   media_type_extensions text(50)
   );
alter table media_type add constraint media_type_PK PRIMARY KEY (media_type);

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
   media_title text(50),
   media_title_en text(50),
   media_file text (50),
   media_description text (255),
   media_description_en text (255),
   media_link text (255)
   );

alter table media_file add constraint media_file_PK PRIMARY KEY (imedia);
alter table media_file add constraint media_file_fichasFK foreign key (iclave) references fichas(clave);
alter table media_file add constraint media_file_typeFK foreign key (media_type) references media_type(media_type);


CREATE TABLE media_seq (
	nextval autoincrement,
	dum int NULL 
);


-- National parameters required for methodologies (Population, GDP, No. of Households, Average per household, etc.)
create table metadata_national
(
metadata_key int not null,
metadata_country text(10) not null,
metadata_variable TEXT(30) not null,
metadata_description  TEXT(250),
metadata_source  TEXT(250),
metadata_default_value DOUBLE,
metadata_default_value_us DOUBLE
) ;

alter table metadata_national add constraint metadata_national_PK primary KEY (metadata_key, metadata_country);


create table metadata_national_values
(
metadata_key INT not null,
metadata_country text(10) not null,
metadata_year INT not null,
metadata_value DOUBLE,
metadata_value_us DOUBLE
) ;
alter table metadata_national_values add constraint metadata_national_valuePK primary KEY (metadata_key, metadata_country, metadata_year);
alter table metadata_national_values add constraint metadata_national_valueFK foreign KEY (metadata_key, metadata_country) references metadata_national(metadata_key,metadata_country) ;


create table metadata_national_lang
(
metadata_key INT not null,
metadata_country text(10) not null,
metadata_lang TEXT(10) not null,
metadata_description  TEXT(250)
) ;
alter table metadata_national_lang add constraint metadata_national_langPK primary KEY (metadata_key, metadata_country, metadata_lang);
alter table metadata_national_lang add constraint metadata_national_langFK foreign KEY (metadata_key, metadata_country) references metadata_national(metadata_key, metadata_country);




-- Tables required for metadata-based metadata-declared disaggregation (Agriculture, Productive Assets, Infrastructure, Services)


-- Indicators (n:1)
-- ISIC or International Code
-- Group or Economic Sector/Activity in ISIC or adopted FAO/UNISDR classification
-- Description of type of asset	
-- Information Source	
-- Element Units (facility, plant, road, etc.)	
-- Measurement Units (m2, meter, hectare, km, ton, etc.)	
-- Average size	
--  of value for equipment, furniture, materials, product (if applicable)	
--  of value for associated physical infrastructure (if applicable)	
-- Average damage ratio	
-- Average number of workers per facility or infrastructure unit	
-- Formula or description of method to calculate economic value	
-- Default Unit price (2015 price)


create table metadata_element 
(
metadata_element_key  int not null,
metadata_country text(10) not null,
metadata_element_code TEXT(15),
metadata_element_fao TEXT(15),
metadata_element_sector TEXT(250),
metadata_element_source TEXT(250),
metadata_element_description TEXT(250),
metadata_element_unit TEXT(30),
metadata_element_measurement  TEXT(10),
metadata_element_average_size DOUBLE,
metadata_element_equipment DOUBLE,
metadata_element_infrastr DOUBLE,
metadata_element_damage_r DOUBLE,
metadata_element_formula MEMO,
metadata_element_workers INT,
metadata_element_price DOUBLE,
metadata_element_price_us DOUBLE
);
alter table metadata_element  add constraint metadata_element_key_PK primary KEY (metadata_element_key, metadata_country);

create table metadata_element_lang
(
metadata_element_key INT not null,
metadata_country text(10) not null,
metadata_lang text(10) not null,
metadata_element_sector text(250),
metadata_element_source text(250),
metadata_element_description text(250),
metadata_element_unit text(30),
metadata_element_measurement  text(10)
) ;
alter table metadata_element_lang add constraint metadata_element_langPK primary KEY (metadata_element_key, metadata_country, metadata_lang);
alter table metadata_element_lang add constraint metadata_element_langFK foreign KEY (metadata_element_key, metadata_country) references metadata_element(metadata_element_key, metadata_country);

create table metadata_element_costs 
(
metadata_element_key INT not null,
metadata_country text(10) not null,
metadata_element_year   INT not null,
metadata_element_unit_cost DOUBLE,
metadata_element_unit_cost_us DOUBLE
) ;

alter table metadata_element_costs add constraint metadata_element_costs_PK primary KEY (metadata_element_key, metadata_country, metadata_element_year);
alter table metadata_element_costs add constraint metadata_national_costFK foreign KEY (metadata_element_key, metadata_country) references metadata_element(metadata_element_key, metadata_country);

create table metadata_indicator
(
indicator_key  int NOT NULL,
indicator_code TEXT(10),
indicator_description TEXT(250)
) ;
alter table metadata_indicator add constraint metadata_ind_PK primary KEY (indicator_key);

create table metadata_indicator_lang
(
indicator_key int not null,
metadata_lang TEXT(10) not null,
indicator_description TEXT(250)
) ;
alter table metadata_indicator_lang add constraint metadata_indicator_langPK primary KEY (indicator_key, metadata_lang);
alter table metadata_indicator_lang add constraint metadata_indicator_langFK foreign KEY (indicator_key) references metadata_indicator(indicator_key);

create table metadata_element_indicator 
(
metadata_element_key  INT not null,
metadata_country text(10) not null,
indicator_key INT not null
) ;
alter table metadata_element_indicator add constraint metadata_element_ind_PK primary KEY (metadata_element_key, metadata_country, indicator_key);
alter table metadata_element_indicator add constraint metadata_indFK1 foreign KEY (metadata_element_key, metadata_country) references metadata_element(metadata_element_key, metadata_country);
alter table metadata_element_indicator add constraint metadata_indFK2 foreign KEY (indicator_key) references metadata_indicator(indicator_key) ;




delete from datamodel;
insert into datamodel (revision, build) values (15,0);


