

ALTER TABLE FICHAS ADD	approved number(4);
UPDATE FICHAS SET approved=0;

CREATE TABLE attribute_metadata (
	field_table nvarchar2 (50)  NOT NULL ,
	field_name nvarchar2 (50)  NOT NULL ,
	field_label nvarchar2 (50)  NULL ,
	field_label_en nvarchar2 (50)  NULL ,
	field_description nvarchar2 (255)  NULL ,
	field_description_en nvarchar2 (255)  NULL ,
	field_date nvarchar2 (50)  NULL ,
	field_source nvarchar2 (50)  NULL 
);

CREATE TABLE info_maps (
	filename nvarchar2 (255)  NOT NULL ,
	layer_name nvarchar2 (50)  NULL ,
	layer_name_en nvarchar2 (50)  NULL ,
	layer number(4) NULL ,
	visible number(4) NULL ,
	filetype nvarchar2 (50)  NULL ,
	color_red number(4) NULL ,
	color_green number(4) NULL ,
	color_blue number(4) NULL ,
	line_thickness number(4) NULL ,
	line_type number(4) NULL ,
	projection_system number(10) NULL ,
	projection_type number(10) NULL ,
	projection_driver nvarchar2 (255)  NULL ,
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
	table_level number(10) NOT NULL ,
	table_name nvarchar2 (50)  NULL ,
	table_code nvarchar2 (50)  NULL 
);

CREATE TABLE level_maps (
	map_level number(10) NOT NULL ,
	filename nvarchar2 (255)  NULL ,
	lev_code nvarchar2 (50)  NULL ,
	lev_name nvarchar2 (50)  NULL ,
	filetype nvarchar2 (50)  NULL ,
	color_red number(4) NULL ,
	color_green number(4) NULL ,
	color_blue number(4) NULL ,
	line_thickness number(4) NULL ,
	line_type number(4) NULL ,
	projection_system number(10) NULL ,
	projection_type number(10) NULL ,
	projection_driver nvarchar2 (255)  NULL ,
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
	
	
	