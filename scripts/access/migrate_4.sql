
ALTER TABLE FICHAS ADD	approved integer null;


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

UPDATE FICHAS SET approved=0;

CREATE TABLE info_maps (
	filename text (255)  NOT NULL ,
	layer_name text (50)  NULL ,
	layer_name_en text (50)  NULL ,
	layer integer NULL ,
	visible integer NULL ,
	filetype text (50)  NULL ,
	color_red integer NULL ,
	color_green integer NULL ,
	color_blue integer NULL ,
	line_thickness integer NULL ,
	line_type integer NULL ,
	projection_system int NULL ,
	projection_type int NULL ,
	projection_driver text (255)  NULL ,
	projection_par0 double NULL ,
	projection_par1 double NULL ,
	projection_par2 double NULL ,
	projection_par3 double NULL ,
	projection_par4 double NULL ,
	projection_par5 double NULL ,
	projection_par6 double NULL ,
	projection_par7 double NULL ,
	projection_par8 double NULL ,
	projection_par9 double NULL 
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
	color_red integer NULL ,
	color_green integer NULL ,
	color_blue integer NULL ,
	line_thickness integer NULL ,
	line_type integer NULL ,
	projection_system int NULL ,
	projection_type int NULL ,
	projection_driver text (255)  NULL ,
	projection_par0 double NULL ,
	projection_par1 double NULL ,
	projection_par2 double NULL ,
	projection_par3 double NULL ,
	projection_par4 double NULL ,
	projection_par5 double NULL ,
	projection_par6 double NULL ,
	projection_par7 double NULL ,
	projection_par8 double NULL ,
	projection_par9 double NULL 
);

ALTER TABLE attribute_metadata ADD 
	CONSTRAINT PK_attribute_metadata PRIMARY KEY   
	(
		field_table, field_name
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
	

