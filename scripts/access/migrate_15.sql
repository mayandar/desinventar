-- MS ACCESS
-- National parameters required for methodologies (Population, GDP, No. of Households, Average per household, etc.)

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


