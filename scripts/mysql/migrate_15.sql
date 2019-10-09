--- PotsgreSQL


drop table metadata_national_values;
drop table metadata_national_lang;
drop table metadata_national;
drop table metadata_element_costs; 
drop table metadata_element_lang;
drop table metadata_element_indicator;
drop table metadata_element;
drop table metadata_indicator_lang;
drop table metadata_indicator;




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

