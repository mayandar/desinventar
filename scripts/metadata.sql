--drop table metadata_national_values;
--drop table metadata_national;
--drop table metadata_element_costs; 
--drop table metadata_element_indicator;
--drop table metadata_element;
--drop table metadata_indicator;


-- National parameters required for methodologies (Population, GDP, No. of Households, Average per household, etc.)

create table metadata_national
(
metadata_key int NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
metadata_variable VARCHAR(30) not null,
metadata_description  VARCHAR(100),
metadata_source  VARCHAR(100),
metadata_default_value DOUBLE,
constraint metadata_national_PK primary KEY (metadata_key)
) ;

create table metadata_national_values
(
metadata_key INT not null,
metadata_year INT not null,
metadata_value DOUBLE,
constraint metadata_national_valuePK primary KEY (metadata_key, metadata_year),
constraint metadata_national_valueFK foreign KEY (metadata_key) references metadata_national(metadata_key)
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
metadata_element_key  int NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
metadata_element_code VARCHAR(15),
metadata_element_sector VARCHAR(100),
metadata_element_source VARCHAR(100),
metadata_element_description VARCHAR(100),
metadata_element_unit VARCHAR(30),
metadata_element_measurement_units  VARCHAR(10),
metadata_element_average_size DOUBLE,
metadata_element_equipment DOUBLE,
metadata_element_associated_infra DOUBLE,
metadata_element_formula CLOB,
metadata_element_average_workers INT, 
metadata_element_default_price DOUBLE,
constraint metadata_element_key_PK primary KEY (metadata_element_key) 
) ;


create table metadata_element_costs 
(
metadata_element_key INT not null,
metadata_element_year   INT not null,
metadata_element_unit_cost DOUBLE,
constraint metadata_element_costs_PK primary KEY (metadata_element_key, metadata_element_year),
constraint metatdata_element_costFK foreign KEY (metadata_element_key) references metadata_element (metadata_element_key) 
) ;

create table metadata_indicator
(
indicator_key  int NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
indicator_code VARCHAR(10),
indicator_description VARCHAR(10),
constraint metadata_ind_PK primary KEY (indicator_key)
) ;

create table metadata_element_indicator 
(
metadata_element_key  INT not null,
indicator_key INT not null,
constraint metadata_element_ind_PK primary KEY (metadata_element_key, indicator_key),
constraint metadata_indFK1 foreign KEY (metadata_element_key) references metadata_element (metadata_element_key), 
constraint metadata_indFK2 foreign KEY (indicator_key) references metadata_indicator(indicator_key) 
) ;

