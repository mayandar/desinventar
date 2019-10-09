CREATE TABLE attribute_metadata (
	field_table nvarchar (50)  NOT NULL ,
	field_name nvarchar (50)  NOT NULL ,
	field_label nvarchar (50)  NULL ,
	field_label_en nvarchar (50)  NULL ,
	field_description nvarchar (255)  NULL ,
	field_description_en nvarchar (255)  NULL ,
	field_date nvarchar (50)  NULL ,
	field_source nvarchar (50)  NULL 
);

CREATE TABLE info_maps (
	filename nvarchar (255)  NOT NULL ,
	layer_name nvarchar (50)  NULL ,
	layer_name_en nvarchar (50)  NULL ,
	layer smallint NULL ,
	visible smallint NULL ,
	filetype nvarchar (50)  NULL ,
	color_red smallint NULL ,
	color_green smallint NULL ,
	color_blue smallint NULL ,
	line_thickness smallint NULL ,
	line_type smallint NULL ,
	projection_system int NULL ,
	projection_type int NULL ,
	projection_driver nvarchar (255)  NULL ,
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
	table_name nvarchar (50)  NULL ,
	table_code nvarchar (50)  NULL 
);

CREATE TABLE level_maps (
	map_level int NOT NULL ,
	filename nvarchar (255)  NULL ,
	lev_code nvarchar (50)  NULL ,
	lev_name nvarchar (50)  NULL ,
	filetype nvarchar (50)  NULL ,
	color_red smallint NULL ,
	color_green smallint NULL ,
	color_blue smallint NULL ,
	line_thickness smallint NULL ,
	line_type smallint NULL ,
	projection_system int NULL ,
	projection_type int NULL ,
	projection_driver nvarchar (255)  NULL ,
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
	CONSTRAINT PK_attribute_metadata PRIMARY KEY  CLUSTERED 
	(
		field_table, field_name
	);
	

ALTER TABLE info_maps WITH NOCHECK ADD 
	CONSTRAINT PK_info_maps PRIMARY KEY  CLUSTERED 
	(
		filename
	);
	
ALTER TABLE level_attributes WITH NOCHECK ADD 
	CONSTRAINT PK_level_attributes PRIMARY KEY  CLUSTERED 
	(
		table_level
	);
	

ALTER TABLE level_maps WITH NOCHECK ADD 
	CONSTRAINT PK_level_maps PRIMARY KEY  CLUSTERED 
	(
		map_level
	);
	

