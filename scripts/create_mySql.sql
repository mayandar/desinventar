-- ALWAYS CREATE DESINVENTAR DATABASES WITH UTF8:
-- CREATE SCHEMA `regionname` DEFAULT CHARACTER SET utf8 ;

-- IN workbench:    
-- USE regioname
--
-- Table structure for table causas
--

CREATE TABLE causas (
  causa varchar(25) NOT NULL,
  causa_en varchar(25) NULL,
  PRIMARY KEY CAUSAS_PK (causa )
) ENGINE=InnoDB;


--
-- Table structure for table diccionario
--

CREATE TABLE diccionario (
  orden smallint(5) NOT NULL,
  nombre_campo varchar(30)  NOT NULL,
  descripcion_campo varchar(180)  NULL,
  label_campo varchar(60)  NULL,
  label_campo_en varchar(60)  NULL,
  pos_x smallint(5)  NULL,
  pos_y smallint(5)  NULL,
  lon_x smallint(5)  NULL,
  lon_y smallint(5)  NULL,
  color int(10)  NULL,
  tabnumber smallint(5)  NULL,
  fieldtype smallint(5)  NULL,
  PRIMARY KEY orden (orden)
) ENGINE=InnoDB ;


--
-- Table structure for table eventos
--

CREATE TABLE eventos (
  serial smallint(5)  NULL,
  nombre varchar(30)  NOT NULL,
  nombre_en varchar(30)  NULL,
  descripcion varchar(200)  NULL,
  parent varchar (30),
  terminal int(10),
  hlevel int(10),
  PRIMARY KEY nombre (nombre)
) ENGINE=InnoDB ;

alter table eventos add	constraint eventos_hierarchyFK foreign key (parent) references eventos(nombre);

--
-- Table structure for table extension
--

CREATE TABLE extension (
  clave_ext int(10) NOT NULL,
  PRIMARY KEY clave_ext (clave_ext)
) ENGINE=InnoDB ;


--
-- Table structure for table fichas
--

CREATE TABLE fichas (
  serial varchar(15)  NOT NULL,
  level0 varchar(15)  NOT NULL,
  level1 varchar(15)  NULL,
  level2 varchar(15)  NULL,
  name0 varchar(30)  NULL,
  name1 varchar(30)  NULL,
  name2 varchar(30)  NULL,
  evento varchar(30)  NOT NULL,
  lugar varchar(60)  NULL,
  fechano smallint(5)  NULL,
  fechames smallint(5)  NULL,
  fechadia smallint(5)  NULL,
  muertos int(10)  NULL,
  heridos int(10)  NULL,
  desaparece int(10)  NULL,
  afectados int(10)  NULL,
  vivdest int(10)  NULL,
  vivafec int(10)  NULL,
  otros varchar(60)  NULL,
  fuentes varchar(255)  NULL,
  valorloc double  NULL,
  valorus double  NULL,
  fechapor varchar(12)  NULL,
  fechafec varchar(12)  NULL,
  hay_muertos smallint(5) NOT NULL,
  hay_heridos smallint(5) NOT NULL,
  hay_deasparece smallint(5) NOT NULL,
  hay_afectados smallint(5) NOT NULL,
  hay_vivdest smallint(5) NOT NULL,
  hay_vivafec smallint(5) NOT NULL,
  hay_otros smallint(5) NOT NULL,
  socorro smallint(5) NOT NULL,
  salud smallint(5) NOT NULL,
  educacion smallint(5) NOT NULL,
  agropecuario smallint(5) NOT NULL,
  industrias smallint(5) NOT NULL,
  acueducto smallint(5) NOT NULL,
  alcantarillado smallint(5) NOT NULL,
  energia smallint(5) NOT NULL,
  comunicaciones smallint(5) NOT NULL,
  causa varchar(25)  NULL,
  descausa varchar(60)  NULL,
  transporte smallint(5) NOT NULL,
  Magnitud2 varchar(25)  NULL,
  nhospitales int(10)  NULL,
  nescuelas int(10)  NULL,
  nhectareas double  NULL,
  cabezas int(10)  NULL,
  Kmvias double  NULL,
  duracion int(10)  NULL,
  damnificados int(10)  NULL,
  evacuados int(10)  NULL,
  hay_damnificados smallint(5) NOT NULL,
  hay_evacuados smallint(5) NOT NULL,
  hay_reubicados smallint(5) NOT NULL,
  reubicados int(10)  NULL,
  clave int(10) NOT NULL auto_increment,
  glide varchar(30)  NULL,
  defaultab smallint(5),
  approved smallint(5)  NULL,
  latitude  double null,
  longitude  double null,
  uu_id varchar(37),
  di_comments TEXT,
  PRIMARY KEY clave (clave),
  KEY fichas0_inx (level0),
  KEY fichas1_inx (level1),
  KEY fichas2_inx (level2),
  KEY fichasc_inx (causa),
  KEY fichase_inx (evento),
  KEY fichasu_inx (uu_id)
) ENGINE=InnoDB ;


--
-- Table structure for table lev0
--

CREATE TABLE lev0 (
  lev0_cod varchar(15)  NOT NULL,
  lev0_name varchar(30)  NULL,
  lev0_name_en varchar(30)  NULL,
  PRIMARY KEY lev0_cod (lev0_cod)
) ENGINE=InnoDB ;


--
-- Table structure for table lev1
--

CREATE TABLE lev1 (
  lev1_cod varchar(15)  NOT NULL,
  lev1_name varchar(30)  NULL,
  lev1_name_en varchar(30)  NULL,
  lev1_lev0 varchar(15)  NOT NULL,
  PRIMARY KEY lev1_cod (lev1_cod),
  KEY lev01_inx (lev1_lev0)
) ENGINE=InnoDB ;


--
-- Table structure for table lev2
--

CREATE TABLE lev2 (
  lev2_cod varchar(15)  NOT NULL,
  lev2_name varchar(30)  NULL,
  lev2_name_en varchar(30)  NULL,
  lev2_lev1 varchar(15)  NOT NULL,
  PRIMARY KEY lev2_cod (lev2_cod),
  KEY lev12_inx (lev2_lev1)
) ENGINE=InnoDB ;


--
-- Table structure for table niveles
--

CREATE TABLE niveles (
  nivel smallint(5) NOT NULL,
  descripcion varchar(25)  NULL,
  descripcion_en varchar(25)  NULL,
  longitud smallint(5)  NULL,
  PRIMARY KEY PrimaryKey (nivel)
) ENGINE=InnoDB ;


--
-- Table structure for table regiones
--

CREATE TABLE regiones (
  codregion varchar(15) NOT NULL,
  nombre varchar(30)  NULL,
  nombre_en varchar(30)  NULL,
  x double  NULL,
  y double  NULL,
  angulo double  NULL,
  xmin double  NULL,
  ymin double  NULL,
  xmax double  NULL,
  ymax double  NULL,
  xtext double  NULL,
  ytext double  NULL,
  nivel int(10)  NULL,
  ap_lista int(10)  NULL,
  lev0_cod varchar(15)  NULL,
  PRIMARY KEY codregion (codregion)
) ENGINE=InnoDB ;


--
-- Table structure for table words
--

CREATE TABLE words (
  wordid int(10)  NULL,
  word varchar(32) NOT NULL,
  occurrences int(10)  NULL,
  PRIMARY KEY word (word)
) ENGINE=InnoDB ;


--
-- Table structure for table words_seq
--

CREATE TABLE words_seq (
  nextval int(10) NOT NULL auto_increment,
  dum int(10)  NULL,
  PRIMARY KEY words_seqPK (nextval)
) ENGINE=InnoDB ;


--
-- Table structure for table wordsdocs
--

CREATE TABLE wordsdocs (
  docid int(10) NOT NULL,
  wordid int(10) NOT  NULL,
  occurrences int(10)  NULL,
  PRIMARY KEY docid (docid,wordid),
  KEY wordsdocs_byword (wordid)
) ENGINE=InnoDB ;

create table  datamodel   (
	revision int(10) not null, 
	build int(10), 
	slanguage varchar(10),
	PRIMARY KEY revision (revision,build)
	) ENGINE=InnoDB ;


create table  extensioncodes   (
	nsort int(10), 
	svalue varchar(40), 
	svalue_en varchar(40),
	field_name varchar (30) NOT NULL ,
	code_value varchar (30) NOT NULL ,
	PRIMARY KEY extensioncodesPK (field_name,code_value)
	)ENGINE=InnoDB ;


create table  extensiontabs   (
        ntab int(10),
	nsort int(10), 
	svalue varchar(40), 
	svalue_en varchar(40),
	PRIMARY KEY extensiontabsPK (ntab)
	)ENGINE=InnoDB ;



CREATE TABLE attribute_metadata (
	field_table varchar (50)  NOT NULL ,
	field_name varchar (50)  NOT NULL ,
	field_label varchar (50)  NULL ,
	field_label_en varchar (50)  NULL ,
	field_description varchar (255)  NULL ,
	field_description_en varchar (255)  NULL ,
	field_date varchar (50)  NULL ,
	field_source varchar (50)  NULL ,
        PRIMARY KEY PK_attribute_metadata (field_table,field_name)
	
) ENGINE=InnoDB ;

CREATE TABLE info_maps (
	filename varchar (255)  NOT NULL ,
	layer_name varchar (50)  NULL ,
	layer_name_en varchar (50)  NULL ,
	layer smallint(5) NULL ,
	visible smallint(5) NULL ,
	filetype varchar (50)  NULL ,
	color_red smallint(5) NULL ,
	color_green smallint(5) NULL ,
	color_blue smallint(5) NULL ,
	line_thickness smallint(5) NULL ,
	line_type smallint(5) NULL ,
	projection_system smallint(5) NULL ,
	projection_type smallint(5) NULL ,
	projection_driver varchar (255)  NULL ,
	projection_par0 double NULL ,
	projection_par1 double NULL ,
	projection_par2 double NULL ,
	projection_par3 double NULL ,
	projection_par4 double NULL ,
	projection_par5 double NULL ,
	projection_par6 double NULL ,
	projection_par7 double NULL ,
	projection_par8 double NULL ,
	projection_par9 double NULL ,
        PRIMARY KEY PK_info_maps (filename)
) ENGINE=InnoDB ;


CREATE TABLE level_attributes (
	table_level smallint(5) NOT NULL ,
	table_name varchar (50)  NULL ,
	table_code varchar (50)  NULL ,
        PRIMARY KEY PK_level_attributes (table_level)
) ENGINE=InnoDB ;

CREATE TABLE level_maps (
	map_level smallint(5) NOT NULL ,
	filename varchar (255)  NULL ,
	lev_code varchar (50)  NULL ,
	lev_name varchar (50)  NULL ,
	filetype varchar (50)  NULL ,
	color_red smallint(5) NULL ,
	color_green smallint(5) NULL ,
	color_blue smallint(5) NULL ,
	line_thickness smallint(5) NULL ,
	line_type smallint(5) NULL ,
	projection_system smallint(5) NULL ,
	projection_type smallint(5) NULL ,
	projection_driver varchar (255)  NULL ,
	projection_par0 double NULL ,
	projection_par1 double NULL ,
	projection_par2 double NULL ,
	projection_par3 double NULL ,
	projection_par4 double NULL ,
	projection_par5 double NULL ,
	projection_par6 double NULL ,
	projection_par7 double NULL ,
	projection_par8 double NULL ,
	projection_par9 double NULL ,
        PRIMARY KEY PK_level_maps (map_level)
)  ENGINE=InnoDB ;

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
  nextval int(10) NOT NULL auto_increment,
  dum int(10)  NULL,
  PRIMARY KEY fichas_seqPK (nextval)
) ENGINE=InnoDB ;

 

create table  LEC_cpi (
   lec_year  int(10)  not null,
   lec_cpi  double,
   PRIMARY KEY LEC_cpiPK (lec_year)
)ENGINE=InnoDB;

create table  LEC_exchange (
   lec_year  int(10)  not null,
   lec_rate  double,
   PRIMARY KEY LEC_exchangePK (lec_year)
)ENGINE=InnoDB;

CREATE TABLE event_grouping (
	nombre varchar (30)  NOT NULL ,
	lec_grouping_days int(10),
	category  varchar(30),
	PRIMARY KEY  event_groupingPK (nombre) 
)ENGINE=InnoDB; 
alter table event_grouping add constraint eventos_h_hierarchyFK foreign key (nombre) references eventos(nombre);

create index approved_inx on fichas (approved);



create table  media_type 
   (
   media_type int  not null,
   media_type_name varchar(50),
   media_type_name_en varchar(50),
   media_type_extensions varchar(50),
   PRIMARY KEY media_typePK (media_type)
   ) ENGINE=InnoDB ;

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
   PRIMARY KEY media_filePK(imedia)
   ) ENGINE=InnoDB ;

alter table media_file add constraint media_file_fichasFK foreign key (iclave) references fichas(clave);
alter table media_file add constraint media_file_typeFK foreign key (media_type) references media_type(media_type);



CREATE TABLE media_seq(
  nextval int(10) NOT NULL auto_increment,
  dum int(10)  NULL,
  PRIMARY KEY media_seqPK(nextval)
) ENGINE=InnoDB ;






-- National parameters required for methodologies (Population, GDP, No. of Households, Average per household, etc.)
create table metadata_national
(
metadata_key int NOT NULL,
metadata_country VARCHAR(10) not null,
metadata_variable VARCHAR(30) not null,
metadata_description  VARCHAR(250),
metadata_source  VARCHAR(250),
metadata_default_value float,
metadata_default_value_us float,
constraint metadata_national_PK primary KEY (metadata_key, metadata_country)
) ENGINE=InnoDB ;

-- National parameters VALUES PER YEAR required for methodologies (Population, GDP, No. of Households, Average per household, etc.)
create table metadata_national_values
(
metadata_key INT not null,
metadata_country VARCHAR(10) not null,
metadata_year INT not null,
metadata_value float,
metadata_value_us float,
constraint metadata_national_valuePK primary KEY (metadata_key, metadata_country, metadata_year),
constraint metadata_national_valueFK foreign KEY (metadata_key, metadata_country) references metadata_national(metadata_key, metadata_country)
) ENGINE=InnoDB ;

-- National parameters description translations(Population, GDP, No. of Households, Average per household, etc.)
create table metadata_national_lang
(
metadata_key INT not null,
metadata_country VARCHAR(10) not null,
metadata_lang VARCHAR(10) not null,
metadata_description  VARCHAR(250)
)  ENGINE=InnoDB ;
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
metadata_element_key  int NOT NULL,
metadata_country VARCHAR(10) not null,
metadata_element_code VARCHAR(15),
metadata_element_fao VARCHAR(15),
metadata_element_sector VARCHAR(250),
metadata_element_source VARCHAR(250),
metadata_element_description VARCHAR(250),
metadata_element_unit VARCHAR(30),
metadata_element_measurement  VARCHAR(10),
metadata_element_average_size float,
metadata_element_equipment float,
metadata_element_infrastr float,
metadata_element_damage_r float,
metadata_element_formula TEXT,
metadata_element_workers INT, 
metadata_element_price float,
metadata_element_price_us float,
constraint metadata_element_key_PK primary KEY (metadata_element_key, metadata_country) 
)  ENGINE=InnoDB ;

create table metadata_element_lang
(
metadata_element_key INT not null,
metadata_country VARCHAR(10) not null,
metadata_lang VARCHAR(10) not null,
metadata_element_sector VARCHAR(250),
metadata_element_source VARCHAR(250),
metadata_element_description VARCHAR(250),
metadata_element_unit VARCHAR(30),
metadata_element_measurement  VARCHAR(10)
) ENGINE=InnoDB  ;
alter table metadata_element_lang add constraint metadata_element_langPK primary KEY (metadata_element_key, metadata_country, metadata_lang);
alter table metadata_element_lang add constraint metadata_element_langFK foreign KEY (metadata_element_key, metadata_country) references metadata_element(metadata_element_key, metadata_country);

create table metadata_element_costs 
(
metadata_element_key INT not null,
metadata_country VARCHAR(10) not null,
metadata_element_year   INT not null,
metadata_element_unit_cost float,
metadata_element_unit_cost_us float,
constraint metadata_element_costs_PK primary KEY (metadata_element_key, metadata_country, metadata_element_year),
constraint metatdata_element_costFK foreign KEY (metadata_element_key, metadata_country) references metadata_element (metadata_element_key, metadata_country) 
)  ENGINE=InnoDB ;

create table metadata_indicator
(
indicator_key int NOT NULL,
indicator_code VARCHAR(10),
indicator_description VARCHAR(250),
constraint metadata_ind_PK primary KEY (indicator_key)
)  ENGINE=InnoDB ;

create table metadata_indicator_lang
(
indicator_key int not null,
metadata_lang varchar(10) not null,
indicator_description varchar(250),
constraint metadata_indicator_langPK primary KEY (indicator_key, metadata_lang),
constraint metadata_indicator_langFK foreign KEY (indicator_key) references metadata_indicator(indicator_key)
) ENGINE=InnoDB;

create table metadata_element_indicator 
(
metadata_element_key  INT not null,
metadata_country VARCHAR(10) not null,
indicator_key INT not null,
constraint metadata_element_ind_PK primary KEY (metadata_element_key, metadata_country, indicator_key),
constraint metadata_indFK1 foreign KEY (metadata_element_key, metadata_country) references metadata_element (metadata_element_key, metadata_country), 
constraint metadata_indFK2 foreign KEY (indicator_key) references metadata_indicator(indicator_key) 
)  ENGINE=InnoDB ;



delete from datamodel;
insert into datamodel (revision, build) values (15,0);

