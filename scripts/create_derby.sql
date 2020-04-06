CREATE TABLE causas (
	causa varchar (25)  NOT NULL,
	causa_en varchar (25) 
); 

CREATE TABLE diccionario (
	orden smallint NOT NULL ,
	nombre_campo varchar (30)  NOT NULL ,
	descripcion_campo varchar (180) ,
	label_campo varchar (60) ,
	label_campo_en varchar (60) ,
	pos_x smallint ,
	pos_y smallint ,
	lon_x smallint ,
	lon_y smallint ,
	color int ,
	tabnumber smallint,
	fieldtype smallint
); 

CREATE TABLE eventos (
	serial smallint,
	nombre varchar (30)  NOT NULL ,
	nombre_en varchar (30),
	descripcion varchar (200), 
	parent varchar (30),
	terminal smallint,
	hlevel smallint
); 

CREATE TABLE extension (
	clave_ext int NOT NULL 
); 

CREATE TABLE fichas (
	serial varchar (15) ,
	level0 varchar (15) ,
	level1 varchar (15) ,
	level2 varchar (15) ,
	name0 varchar (30) ,
	name1 varchar (30) ,
	name2 varchar (30) ,
	evento varchar (30) ,
	lugar varchar (60) ,
	fechano smallint ,
	fechames smallint ,
	fechadia smallint ,
	muertos int ,
	heridos int ,
	desaparece int ,
	afectados int ,
	vivdest int ,
	vivafec int ,
	otros varchar (60) ,
	fuentes varchar (255) ,
	valorloc double,
	valorus double,
	fechapor varchar (12) ,
	fechafec varchar (12) ,
	hay_muertos smallint ,
	hay_heridos smallint ,
	hay_deasparece smallint,
	hay_afectados smallint,
	hay_vivdest smallint,
	hay_vivafec smallint,
	hay_otros smallint ,
	socorro smallint  ,
	salud smallint ,
	educacion smallint,
	agropecuario smallint ,
	industrias smallint,
	acueducto smallint  ,
	alcantarillado smallint ,
	energia smallint ,
	comunicaciones smallint ,
	causa varchar (25) ,
	descausa varchar (60) ,
	transporte smallint  ,
	Magnitud2 varchar (25) ,
	nhospitales int ,
	nescuelas int ,
	nhectareas double,
	cabezas int ,
	Kmvias double,
	duracion int ,
	damnificados int ,
	evacuados int ,
	hay_damnificados smallint ,
	hay_evacuados smallint,
	hay_reubicados smallint,
	reubicados int ,
	clave int NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) ,
	glide varchar (30) ,
	defaultab smallint ,
	approved  smallint,
	latitude  double, 
	longitude  double, 
	uu_id varchar(37),
	di_comments long varchar	
); 

CREATE TABLE lev0 (
	lev0_cod varchar (15)  NOT NULL ,
	lev0_name varchar (30), 
	lev0_name_en varchar (30) 
); 

CREATE TABLE lev1 (
	lev1_cod varchar (15)  NOT NULL ,
	lev1_name varchar (30) ,
	lev1_name_en varchar (30) ,
	lev1_lev0 varchar (15) 
); 

CREATE TABLE lev2 (
	lev2_cod varchar (15)  NOT NULL ,
	lev2_name varchar (30) ,
	lev2_name_en varchar (30) ,
	lev2_lev1 varchar (15) 
); 

CREATE TABLE niveles (
	nivel int NOT NULL ,
	descripcion varchar (25) ,
	descripcion_en varchar (25) ,
	longitud smallint 
); 

CREATE TABLE regiones (
	codregion varchar (15)  NOT NULL ,
	nombre varchar (30) ,
	nombre_en varchar (30) ,
	x double ,
	y double ,
	angulo double ,
	xmin double ,
	ymin double ,
	xmax double ,
	ymax double ,
	xtext double ,
	ytext double ,
	nivel int ,
	ap_lista int ,
	lev0_cod varchar (15) 
) ;

CREATE TABLE words (
	wordid int NOT NULL ,
	word varchar (32)  NOT NULL ,
	occurrences int 
); 

create sequence words_seq  START WITH 1;

CREATE TABLE wordsdocs (
	docid int NOT NULL ,
	wordid int NOT NULL ,
	occurrences int 
);

ALTER TABLE causas ADD CONSTRAINT PK_causas PRIMARY KEY  (causa);

ALTER TABLE diccionario ADD
 CONSTRAINT PK_diccionario PRIMARY KEY (nombre_campo);

ALTER TABLE eventos ADD 
	CONSTRAINT PK_eventos PRIMARY KEY   
	(
		nombre
	);   

alter table eventos add		constraint eventos_hierarchyFK foreign key (parent) references eventos(nombre);

ALTER TABLE extension ADD 
	CONSTRAINT PK_extension PRIMARY KEY   
	(
		clave_ext
	);   

ALTER TABLE fichas ADD 
	CONSTRAINT PK_fichas PRIMARY KEY   
	(
		clave
	);   

ALTER TABLE lev0 ADD 
	CONSTRAINT PK_lev0 PRIMARY KEY   
	(
		lev0_cod
	);   

ALTER TABLE lev1 ADD 
	CONSTRAINT PK_lev1 PRIMARY KEY   
	(
		lev1_cod
	);   

ALTER TABLE lev2 ADD 
	CONSTRAINT PK_lev2 PRIMARY KEY   
	(
		lev2_cod
	);   

ALTER TABLE niveles ADD 
	CONSTRAINT PK_niveles PRIMARY KEY   
	(
		nivel
	);   


ALTER TABLE regiones ADD 
	CONSTRAINT PK_regiones PRIMARY KEY   
	(
		codregion
	);  

ALTER TABLE words ADD 
	CONSTRAINT WORDPK PRIMARY KEY   
	(
		word
	);   

ALTER TABLE wordsdocs ADD 
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
	);
 
ALTER TABLE fichas ADD 
	CONSTRAINT FK_fichas_eventos FOREIGN KEY 
	(
		evento
	) REFERENCES eventos (
		nombre
	);
ALTER TABLE fichas ADD 
	CONSTRAINT FK_fichas_lev0 FOREIGN KEY 
	(
		level0
	) REFERENCES lev0 (
		lev0_cod
	);
ALTER TABLE fichas ADD 
	CONSTRAINT FK_fichas_lev1 FOREIGN KEY 
	(
		level1
	) REFERENCES lev1 (
		lev1_cod
	) ;
ALTER TABLE fichas ADD 
	CONSTRAINT FK_fichas_lev2 FOREIGN KEY 
	(
		level2
	) REFERENCES lev2 (
		lev2_cod
	);

ALTER TABLE wordsdocs ADD 
	CONSTRAINT FK_wordsdocs_fichas FOREIGN KEY 
	(
		docid
	) REFERENCES fichas (
		clave
	);
	
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
	CONSTRAINT extensioncodesPK PRIMARY KEY (field_name,code_value)
	);
alter table extensioncodes add constraint extensioncodesFK foreign key (field_name) references diccionario(nombre_campo);

create table  extensiontabs(
	ntab   integer not null, 
	nsort integer, 
	svalue varchar(40), 
	svalue_en varchar(40));
alter table extensiontabs add constraint extensiontabsPK primary key (ntab);


CREATE TABLE attribute_metadata (
	field_table varchar (50)  NOT NULL ,
	field_name varchar (50)  NOT NULL ,
	field_label varchar (50) ,
	field_label_en varchar (50) ,
	field_description varchar (255) ,
	field_description_en varchar (255) ,
	field_date varchar (50) ,
	field_source varchar (50) 
);

CREATE TABLE info_maps (
	filename varchar (255)  NOT NULL ,
	layer_name varchar (50) ,
	layer_name_en varchar (50) ,
	layer smallint ,
	visible smallint ,
	filetype varchar (50) ,
	color_red smallint ,
	color_green smallint ,
	color_blue smallint ,
	line_thickness smallint ,
	line_type smallint ,
	projection_system int ,
	projection_type int ,
	projection_driver varchar (255) ,
	projection_par0 double ,
	projection_par1 double ,
	projection_par2 double ,
	projection_par3 double ,
	projection_par4 double ,
	projection_par5 double ,
	projection_par6 double ,
	projection_par7 double ,
	projection_par8 double ,
	projection_par9 double 
);

CREATE TABLE level_attributes (
	table_level int NOT NULL ,
	table_name varchar (50) ,
	table_code varchar (50) 
);

CREATE TABLE level_maps (
	map_level int NOT NULL ,
	filename varchar (255) ,
	lev_code varchar (50) ,
	lev_name varchar (50) ,
	filetype varchar (50) ,
	color_red smallint ,
	color_green smallint ,
	color_blue smallint ,
	line_thickness smallint ,
	line_type smallint ,
	projection_system int ,
	projection_type int ,
	projection_driver varchar (255) ,
	projection_par0 double ,
	projection_par1 double ,
	projection_par2 double ,
	projection_par3 double ,
	projection_par4 double ,
	projection_par5 double ,
	projection_par6 double ,
	projection_par7 double ,
	projection_par8 double ,
	projection_par9 double 
);

ALTER TABLE attribute_metadata ADD 
	CONSTRAINT PK_attribute_metadata PRIMARY KEY   
	(
		field_table,field_name
	);
	

ALTER TABLE info_maps ADD 
	CONSTRAINT PK_info_maps PRIMARY KEY   
	(
		filename
	);
	
ALTER TABLE level_attributes ADD 
	CONSTRAINT PK_level_attributes PRIMARY KEY   
	(
		table_level
	);
	

ALTER TABLE level_maps ADD 
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
CREATE sequence fichas_seq START WITH 1;


create table  LEC_cpi (
   lec_year  smallint not null,
   lec_cpi  double);
alter table LEC_cpi  add constraint LEC_cpiPK PRIMARY KEY (lec_year);

create table  LEC_exchange (
   lec_year  smallint not null,
   lec_rate  double);
alter table LEC_exchange  add constraint LEC_exchangePK PRIMARY KEY (lec_year);

CREATE TABLE event_grouping (
	nombre varchar (30)  NOT NULL ,
	lec_grouping_days smallint,
    category varchar(30)
); 

alter table event_grouping add constraint event_groupingPK PRIMARY KEY (nombre);
alter table event_grouping add	constraint eventos_h_hierarchyFK foreign key (nombre) references eventos(nombre);


create index approved_inx on fichas (approved);


create table  media_type 
   (
   media_type int not null,
   media_type_name varchar(50),
   media_type_name_en varchar(50),
   media_type_extensions varchar(50)
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
   media_title varchar(50),
   media_title_en varchar(50),
   media_file varchar (50),
   media_description varchar (255),
   media_description_en varchar (255),
   media_link varchar (255)
   );

alter table media_file add constraint media_file_PK PRIMARY KEY (imedia);
alter table media_file add constraint media_file_fichasFK foreign key (iclave) references fichas(clave);
alter table media_file add constraint media_file_typeFK foreign key (media_type) references media_type(media_type);


create sequence media_seq  START WITH 1;



-- DERBY
-- National parameters required for methodologies (Population, GDP, No. of Households, Average per household, etc.)


create table metadata_national
(
metadata_key int NOT NULL,
metadata_country VARCHAR(10) not null,
metadata_variable VARCHAR(30) not null,
metadata_description  VARCHAR(250),
metadata_source  VARCHAR(250),
metadata_default_value DOUBLE,
metadata_default_value_us DOUBLE,

constraint metadata_national_PK primary KEY (metadata_key, metadata_country)
) ;

create table metadata_national_values
(
metadata_key INT not null,
metadata_country VARCHAR(10) not null,
metadata_year INT not null,
metadata_value DOUBLE,
metadata_value_us DOUBLE,
constraint metadata_national_valuePK primary KEY (metadata_key, metadata_country, metadata_year),
constraint metadata_national_valueFK foreign KEY (metadata_key, metadata_country) references metadata_national(metadata_key, metadata_country)
) ;

create table metadata_national_lang
(
metadata_key INT not null,
metadata_country VARCHAR(10) not null,
metadata_lang VARCHAR(10) not null,
metadata_description  VARCHAR(250),
constraint metadata_national_langPK primary KEY (metadata_key, metadata_country, metadata_lang),
constraint metadata_national_langFK foreign KEY (metadata_key, metadata_country) references metadata_national(metadata_key, metadata_country)
) ;



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
metadata_element_key  int NOT NULL,
metadata_country VARCHAR(10) not null,
metadata_element_code VARCHAR(15),
metadata_element_fao VARCHAR(15),
metadata_element_sector VARCHAR(250),
metadata_element_source VARCHAR(250),
metadata_element_description VARCHAR(250),
metadata_element_unit VARCHAR(30),
metadata_element_measurement  VARCHAR(10),
metadata_element_average_size DOUBLE,
metadata_element_equipment DOUBLE,
metadata_element_infrastr DOUBLE,
metadata_element_damage_r DOUBLE,
metadata_element_formula CLOB,
metadata_element_workers INT, 
metadata_element_price DOUBLE,
metadata_element_price_us DOUBLE,

constraint metadata_element_key_PK primary KEY (metadata_element_key, metadata_country) 
) ;

create table metadata_element_lang
(
metadata_element_key INT not null,
metadata_country VARCHAR(10) not null,
metadata_lang VARCHAR(10) not null,
metadata_element_sector VARCHAR(250),
metadata_element_source VARCHAR(250),
metadata_element_description VARCHAR(250),
metadata_element_unit VARCHAR(30),
metadata_element_measurement  VARCHAR(10),
constraint metadata_element_langPK primary KEY (metadata_element_key, metadata_country, metadata_lang),
constraint metadata_element_langFK foreign KEY (metadata_element_key, metadata_country) references metadata_element(metadata_element_key, metadata_country)
) ;


create table metadata_element_costs 
(
metadata_element_key INT not null,
metadata_country VARCHAR(10) not null,
metadata_element_year   INT not null,
metadata_element_unit_cost DOUBLE,
metadata_element_unit_cost_us DOUBLE,
constraint metadata_element_costs_PK primary KEY (metadata_element_key, metadata_country, metadata_element_year),
constraint metatdata_element_costFK foreign KEY (metadata_element_key, metadata_country) references metadata_element (metadata_element_key, metadata_country) 
) ;

create table metadata_indicator
(
indicator_key  int not null,
indicator_code VARCHAR(10),
indicator_description VARCHAR(250),
constraint metadata_ind_PK primary KEY (indicator_key)
) ;

create table metadata_indicator_lang
(
indicator_key int not null,
metadata_lang varchar(10) not null,
indicator_description varchar(250),
constraint metadata_indicator_langPK primary KEY (indicator_key, metadata_lang),
constraint metadata_indicator_langFK foreign KEY (indicator_key) references metadata_indicator(indicator_key)
) ;


create table metadata_element_indicator 
(
metadata_element_key  INT not null,
metadata_country VARCHAR(10) not null,
indicator_key INT not null,
constraint metadata_element_ind_PK primary KEY (metadata_element_key, metadata_country, indicator_key),
constraint metadata_indFK1 foreign KEY (metadata_element_key, metadata_country) references metadata_element (metadata_element_key, metadata_country), 
constraint metadata_indFK2 foreign KEY (indicator_key) references metadata_indicator(indicator_key) 
) ;



delete from datamodel;
insert into datamodel (revision, build) values (16,0);


