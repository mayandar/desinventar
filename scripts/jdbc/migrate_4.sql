ALTER TABLE FICHAS ADD	approved integer null;
UPDATE FICHAS SET approved=0;


CREATE TABLE attribute_metadata (
	field_table varchar (50)  NOT NULL ,
	field_name varchar (50)  NOT NULL ,
	field_label varchar (50)  NULL ,
	field_label_en varchar (50)  NULL ,
	field_description varchar (255)  NULL ,
	field_description_en varchar (255)  NULL ,
	field_date varchar (50)  NULL ,
	field_source varchar (50)  NULL 
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
	projection_par9 float NULL 
);

CREATE TABLE level_attributes (
	table_level integer NOT NULL ,
	table_name varchar (50)  NULL ,
	table_code varchar (50)  NULL 
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
	
	
	
	