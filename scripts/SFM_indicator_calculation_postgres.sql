---------------------------------------------------------------------------------------------------------------------------------------
-- WHILE REAL DATA COMES IN. After this, run the metadata import from SFM
---------------------------------------------------------------------------------------------------------------------------------------
-- insert into metadata_national_values select metadata_key, metadata_country, 2018,  metadata_value, metadata_value_us from metadata_national_values where metadata_year=2017;

---------------------------------------------------------------------------------------------------------------------------------------
-- IF the metadata key does not exist in every countrye:
---------------------------------------------------------------------------------------------------------------------------------------
DELETE from metadata_national_values where metadata_key=11;
DELETE from metadata_national where metadata_key=11;
insert into metadata_national (metadata_key, metadata_country, metadata_variable, metadata_description, metadata_source, metadata_default_value) 
     SELECT 11,metadata_country, 'HabPerHousehold', 'Inhabitants per household','Calculated',4 from metadata_national where metadata_key=1;


---------------------------------------------------------------------------------------------------------------------------------------
-- CALCULATION OF INHABITANTS PER HOUSEHOLDS
---------------------------------------------------------------------------------------------------------------------------------------


-- These have two entries in number of households 
delete from metadata_national_values where metadata_key=6 and metadata_country='AUT' and metadata_year=2001;
delete from metadata_national_values where metadata_key=6 and metadata_country='CZE' and metadata_year=2001;




DELETE from metadata_national_values where metadata_key=11;
insert into metadata_national_values select  11, metadata_country, metadata_year, 0, 0 from metadata_national_values where metadata_key=1;

update metadata_national_values mv set 
    metadata_value=mvp.metadata_value/mv2.metadata_value from  
	
	metadata_national_values mv2 join metadata_national_values mvp on mv2.metadata_country= mvp.metadata_country AND 
																	  mv2.metadata_year=mvp.metadata_year AND
																	  mv2.metadata_key=6 and mvp.metadata_key=1
	where mv.metadata_key=11 and mv2.metadata_key=6 and 
	      mv2.metadata_country= mv.metadata_country AND 
		  mv2.metadata_year=mv.metadata_year AND
		  mv2.metadata_value>0;


update metadata_national_values mv 
      set metadata_value= mv2.metadata_value from 
	  metadata_national_values mv2 where mv.metadata_key=11 and mv2.metadata_key=11 and 
										 mv2.metadata_country= mv.metadata_country and 
										 mv2.metadata_year<>mv.metadata_year and 
										 mv2.metadata_value>0;

-- safeguard and default where there is no data!
update metadata_national_values set metadata_value=4 where metadata_key=11 and (metadata_value<1 or metadata_value>10);


---------------------------------------------------------------------------------------------------------------------------------------
--- Calculation  of compound indicators
---------------------------------------------------------------------------------------------------------------------------------------



update extension e set  
B_1A= coalesce(NULLIF(LIVING_DMGD_DWELLINGS,0),vivafec * coalesce(metadata_value,4)) +
      coalesce(NULLIF(LIVING_DSTR_DWELLINGS,0),vivdest * coalesce(metadata_value,4)) +
	  coalesce(NULLIF(LIVELIHOOD_AFCTD,0),nhectareas * coalesce(workers,1)) +
	  heridos 
from fichas f left join metadata_national_values on metadata_country=level0 and metadata_key=11 and metadata_year=fechano
              left join agri_workers on level0=code 
where clave=clave_ext;


update extension e set  
A_1= case when coalesce(metadata_value,0)=0 then 0 else (muertos + desaparece)*100000.0 / metadata_value end,
A_2= case when coalesce(metadata_value,0)=0 then 0 else muertos * 100000.0 / metadata_value end,
A_3= case when coalesce(metadata_value,0)=0 then 0 else desaparece * 100000.0 / metadata_value end,
B_1= case when coalesce(metadata_value,0)=0 then 0 else B_1A * 100000.0 / metadata_value end
from fichas f left join metadata_national_values on metadata_country=level0 and metadata_key=1 and metadata_year=fechano where clave=clave_ext ;




-- CALCULATION OF INTERMEDIATE INDICATORS

-- AGRICULTURE:  take the C-2 if entered manually in SFM otherwise calculate it using the sub-indicators, also giving priority to SFM data
UPDATE extension SET  	
ECONOMIC_LOSS_C2=
        coalesce(NULLIF(LOSS_AGRI,0),
			 COALESCE(NULLIF(LOSS_CROPS,0), T_LOSS_CROPS, 0) 
			+COALESCE(NULLIF(LOSS_LIVESTOCK_TOTAL,0), T_LOSS_LIVESTOCK, 0) 
			+COALESCE(NULLIF(LOSS_FOREST_TOTAL,0), 0) 
			+COALESCE(NULLIF(LOSS_AQUACULTURE_TOTAL,0), T_LOSS_AQUACULTURE, 0) 
			+COALESCE(NULLIF(LOSS_VESSELS_TOTAL,0), T_LOSS_VESSELS, 0) 
			+COALESCE(NULLIF(STOCK_LOSS_AFCTD,0), T_LOSS_STOCK, 0) 
			+COALESCE(NULLIF(AGRI_ASSETS_LOSS_AFCTD,0), T_LOSS_AGRI_ASSETS, 0)
         ),
ECONOMIC_LOSS_C3=
        coalesce(NULLIF(PRODUCTIVE_ASSETS_LOSS_AFCTD,0), ECONOMIC_LOSS_C3),
-- HOUSING:  just give precedence to SFM reported losses, otherwise take modelled losses
ECONOMIC_LOSS_C4=
        coalesce(NULLIF(LOSS_DWELLINGS,0), ECONOMIC_LOSS_C4),
-- Infrastructure  (ROADS)
T_LOSS_357=        
	coalesce(NULLIF(LOSS_357,0), T_LOSS_357)
;
	
	
-- A new statement to reuse the values just calculated. Just to be sure..
-- b) total, health, education and other infrastructures
UPDATE extension SET  	
ECONOMIC_LOSS_C5=
        coalesce(NULLIF(C5_INFRASTRUCTURES_LOSS,0),
			 COALESCE(NULLIF(LOSS_HEALTH_FACILITIES,0), ECONOMIC_LOSS_HEALTH, 0) 
			+COALESCE(NULLIF(LOSS_EDUCATION,0), ECONOMIC_LOSS_EDU, 0) 
			+COALESCE(NULLIF(LOSS_INFRASTRUCTURES,0), T_LOSS_357, 0) 
			)			
;

-- A new statement to reuse the values just calculated. Just to be sure..
--- TOTAL DIRECT ECONOMIC LOSS 
UPDATE extension SET 
	C_1a= 
		 COALESCE(ECONOMIC_LOSS_C2,0)  
		+COALESCE(ECONOMIC_LOSS_C3, 0) 
		+COALESCE(ECONOMIC_LOSS_C4, 0) 
		+COALESCE(ECONOMIC_LOSS_C5, 0)
		+coalesce(NULLIF(C6_LOSS_CULTURAL,0),
				 COALESCE(LOSS_CULTURAL_FIXED,0) 
				+COALESCE(LOSS_CULTURAL_MOBILE_DMGD,0) 
				+COALESCE(LOSS_CULTURAL_MOBILE_DSTR,0)
				)
;


update extension e set  
C_1= case when coalesce(metadata_value,0)=0 then 0 else  C_1a / metadata_value end
from fichas f left join metadata_national_values on metadata_country=level0 and metadata_key=5 and metadata_year=fechano where clave=clave_ext ;

update extension e set  
	T_LIVING_DMG=coalesce(NULLIF(LIVING_DMGD_DWELLINGS,0),vivafec * coalesce(metadata_value,4)),
    T_LIVING_DST=coalesce(NULLIF(LIVING_DSTR_DWELLINGS,0),vivdest * coalesce(metadata_value,4)) 
from fichas f left join metadata_national_values on metadata_country=level0 and metadata_key=11 and metadata_year=fechano where clave=clave_ext ;




