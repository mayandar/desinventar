

delete from diccionario where nombre_campo='DEATHS_FEMALE';
alter table extension drop column  DEATHS_FEMALE;
delete from diccionario where nombre_campo='DEATHS_MALE';
alter table extension drop column  DEATHS_MALE;
delete from diccionario where nombre_campo='DEATHS_CHILDREN';
alter table extension drop column  DEATHS_CHILDREN;
delete from diccionario where nombre_campo='DEATHS_ADULTS';
alter table extension drop column  DEATHS_ADULTS;
delete from diccionario where nombre_campo='DEATHS_ELDER';
alter table extension drop column  DEATHS_ELDER;
delete from diccionario where nombre_campo='DEATHS_DISABLED';
alter table extension drop column  DEATHS_DISABLED;
delete from diccionario where nombre_campo='DEATHS_POOR';
alter table extension drop column  DEATHS_POOR;
delete from diccionario where nombre_campo='MISSING_FEMALE';
alter table extension drop column  MISSING_FEMALE;
delete from diccionario where nombre_campo='MISSING_MALE';
alter table extension drop column  MISSING_MALE;
delete from diccionario where nombre_campo='MISSING_CHILDREN';
alter table extension drop column  MISSING_CHILDREN;
delete from diccionario where nombre_campo='MISSING_ADULTS';
alter table extension drop column  MISSING_ADULTS;
delete from diccionario where nombre_campo='MISSING_ELDER';
alter table extension drop column  MISSING_ELDER;
delete from diccionario where nombre_campo='MISSING_DISABLED';
alter table extension drop column  MISSING_DISABLED;
delete from diccionario where nombre_campo='MISSING_POOR';
alter table extension drop column  MISSING_POOR;
delete from diccionario where nombre_campo='INJURED_FEMALE';
alter table extension drop column  INJURED_FEMALE;
delete from diccionario where nombre_campo='INJURED_MALE';
alter table extension drop column  INJURED_MALE;
delete from diccionario where nombre_campo='INJURED_CHILDREN';
alter table extension drop column  INJURED_CHILDREN;
delete from diccionario where nombre_campo='INJURED_ADULTS';
alter table extension drop column  INJURED_ADULTS;
delete from diccionario where nombre_campo='INJURED_ELDER';
alter table extension drop column  INJURED_ELDER;
delete from diccionario where nombre_campo='INJURED_DISABLED';
alter table extension drop column  INJURED_DISABLED;
delete from diccionario where nombre_campo='INJURED_POOR';
alter table extension drop column  INJURED_POOR;
delete from diccionario where nombre_campo='LIVING_DMGD_DWELLINGS';
alter table extension drop column  LIVING_DMGD_DWELLINGS;
delete from diccionario where nombre_campo='LIVING_DMGD_DWELLINGS_FEMALE';
alter table extension drop column  LIVING_DMGD_DWELLINGS_FEMALE;
delete from diccionario where nombre_campo='LIVING_DMGD_DWELLINGS_MALE';
alter table extension drop column  LIVING_DMGD_DWELLINGS_MALE;
delete from diccionario where nombre_campo='LIVING_DMGD_DWELLINGS_CHILDREN';
alter table extension drop column  LIVING_DMGD_DWELLINGS_CHILDREN;
delete from diccionario where nombre_campo='LIVING_DMGD_DWELLINGS_ADULTS';
alter table extension drop column  LIVING_DMGD_DWELLINGS_ADULTS;
delete from diccionario where nombre_campo='LIVING_DMGD_DWELLINGS_ELDER';
alter table extension drop column  LIVING_DMGD_DWELLINGS_ELDER;
delete from diccionario where nombre_campo='LIVING_DMGD_DWELLINGS_DISABLED';
alter table extension drop column  LIVING_DMGD_DWELLINGS_DISABLED;
delete from diccionario where nombre_campo='LIVING_DMGD_DWELLINGS_POOR';
alter table extension drop column  LIVING_DMGD_DWELLINGS_POOR;
delete from diccionario where nombre_campo='LIVING_DSTR_DWELLINGS';
alter table extension drop column  LIVING_DSTR_DWELLINGS;
delete from diccionario where nombre_campo='LIVING_DSTR_DWELLINGS_FEMALE';
alter table extension drop column  LIVING_DSTR_DWELLINGS_FEMALE;
delete from diccionario where nombre_campo='LIVING_DSTR_DWELLINGS_MALE';
alter table extension drop column  LIVING_DSTR_DWELLINGS_MALE;
delete from diccionario where nombre_campo='LIVING_DSTR_DWELLINGS_CHILDREN';
alter table extension drop column  LIVING_DSTR_DWELLINGS_CHILDREN;
delete from diccionario where nombre_campo='LIVING_DSTR_DWELLINGS_ADULTS';
alter table extension drop column  LIVING_DSTR_DWELLINGS_ADULTS;
delete from diccionario where nombre_campo='LIVING_DSTR_DWELLINGS_ELDER';
alter table extension drop column  LIVING_DSTR_DWELLINGS_ELDER;
delete from diccionario where nombre_campo='LIVING_DSTR_DWELLINGS_DISABLED';
alter table extension drop column  LIVING_DSTR_DWELLINGS_DISABLED;
delete from diccionario where nombre_campo='LIVING_DSTR_DWELLINGS_POOR';
alter table extension drop column  LIVING_DSTR_DWELLINGS_POOR;
delete from diccionario where nombre_campo='LIVELIHOOD_AFCTD';
alter table extension drop column  LIVELIHOOD_AFCTD;
delete from diccionario where nombre_campo='LIVELIHOODS_FEMALE';
alter table extension drop column  LIVELIHOODS_FEMALE;
delete from diccionario where nombre_campo='LIVELIHOODS_MALE';
alter table extension drop column  LIVELIHOODS_MALE;
delete from diccionario where nombre_campo='LIVELIHOODS_CHILDREN';
alter table extension drop column  LIVELIHOODS_CHILDREN;
delete from diccionario where nombre_campo='LIVELIHOODS_ADULTS';
alter table extension drop column  LIVELIHOODS_ADULTS;
delete from diccionario where nombre_campo='LIVELIHOODS_ELDER';
alter table extension drop column  LIVELIHOODS_ELDER;
delete from diccionario where nombre_campo='LIVELIHOODS_DISABLED';
alter table extension drop column  LIVELIHOODS_DISABLED;
delete from diccionario where nombre_campo='LIVELIHOODS_POOR';
alter table extension drop column  LIVELIHOODS_POOR;

-- total HA is nhectareas
delete from diccionario where nombre_campo='HA_DMGD';
alter table extension drop column  HA_DMGD;
delete from diccionario where nombre_campo='HA_DSTR';
alter table extension drop column  HA_DSTR;
delete from diccionario where nombre_campo='LOSS_CROPS';
alter table extension drop column  LOSS_CROPS;

delete from diccionario where nombre_campo='LIVESTOCK_TOTAL';
alter table extension drop column  LIVESTOCK_TOTAL;
delete from diccionario where nombre_campo='LIVESTOCK_DMGD';
alter table extension drop column  LIVESTOCK_DMGD;
-- Livestock lost is ncabezas
delete from diccionario where nombre_campo='LOSS_LIVESTOCK_TOTAL';
alter table extension drop column  LOSS_LIVESTOCK_TOTAL;

delete from diccionario where nombre_campo='HA_FOREST_TOTAL';
alter table extension drop column  HA_FOREST_TOTAL;
delete from diccionario where nombre_campo='HA_FOREST_DMGD';
alter table extension drop column  HA_FOREST_DMGD;
delete from diccionario where nombre_campo='HA_FOREST_DSTR';
alter table extension drop column  HA_FOREST_DSTR;
delete from diccionario where nombre_campo='LOSS_FOREST_TOTAL';
alter table extension drop column  LOSS_FOREST_TOTAL;

delete from diccionario where nombre_campo='HA_AQUACULTURE_TOTAL';
alter table extension drop column  HA_AQUACULTURE_TOTAL;
delete from diccionario where nombre_campo='HA_AQUACULTURE_DMGD';
alter table extension drop column  HA_AQUACULTURE_DMGD;
delete from diccionario where nombre_campo='HA_AQUACULTURE_DSTR';
alter table extension drop column  HA_AQUACULTURE_DSTR;
delete from diccionario where nombre_campo='LOSS_AQUACULTURE_TOTAL';
alter table extension drop column  LOSS_AQUACULTURE_TOTAL;

delete from diccionario where nombre_campo='VESSELS_TOTAL';
alter table extension drop column  VESSELS_TOTAL;
delete from diccionario where nombre_campo='VESSELS_DMGD';
alter table extension drop column  VESSELS_DMGD;
delete from diccionario where nombre_campo='VESSELS_DSTR';
alter table extension drop column  VESSELS_DSTR;
delete from diccionario where nombre_campo='LOSS_VESSELS_TOTAL';
alter table extension drop column  LOSS_VESSELS_TOTAL;

delete from diccionario where nombre_campo='STOCK_FACILITIES_AFCTD';
alter table extension drop column  STOCK_FACILITIES_AFCTD;
delete from diccionario where nombre_campo='STOCK_FACILITIES_DMGD';
alter table extension drop column  STOCK_FACILITIES_DMGD;
delete from diccionario where nombre_campo='STOCK_FACILITIES_DSTR';
alter table extension drop column  STOCK_FACILITIES_DSTR;
delete from diccionario where nombre_campo='STOCK_LOSS_AFCTD';
alter table extension drop column  STOCK_LOSS_AFCTD;

delete from diccionario where nombre_campo='AGRI_ASSETS_AFCTD';
alter table extension drop column  AGRI_ASSETS_AFCTD;
delete from diccionario where nombre_campo='AGRI_ASSETS_DMGD';
alter table extension drop column  AGRI_ASSETS_DMGD;
delete from diccionario where nombre_campo='AGRI_ASSETS_DSTR';
alter table extension drop column  AGRI_ASSETS_DSTR;
delete from diccionario where nombre_campo='AGRI_ASSETS_LOSS_AFCTD';
alter table extension drop column  AGRI_ASSETS_LOSS_AFCTD;


delete from diccionario where nombre_campo='PRODUCTIVE_ASSETS_AFCTD';
alter table extension drop column  PRODUCTIVE_ASSETS_AFCTD;
delete from diccionario where nombre_campo='PRODUCTIVE_ASSETS_DMGD';
alter table extension drop column  PRODUCTIVE_ASSETS_DMGD;
delete from diccionario where nombre_campo='PRODUCTIVE_ASSETS_DSTR';
alter table extension drop column  PRODUCTIVE_ASSETS_DSTR;
delete from diccionario where nombre_campo='PRODUCTIVE_ASSETS_LOSS_AFCTD';
alter table extension drop column  PRODUCTIVE_ASSETS_LOSS_AFCTD;

delete from diccionario where nombre_campo='HOUSES_TOTAL';
alter table extension drop column  HOUSES_TOTAL;
delete from diccionario where nombre_campo='LOSS_DWELLINGS';
alter table extension drop column  LOSS_DWELLINGS;
delete from diccionario where nombre_campo='LOSS_DWELLINGS_DMGD';
alter table extension drop column  LOSS_DWELLINGS_DMGD;
delete from diccionario where nombre_campo='LOSS__DWELLINGSDSTR';
alter table extension drop column  LOSS__DWELLINGSDSTR;

-- Total health facilities is nhospitales
delete from diccionario where nombre_campo='HEALTH_FACILITIES_DMGD';
alter table extension drop column  HEALTH_FACILITIES_DMGD;
delete from diccionario where nombre_campo='HEALTH_FACILITIES_DSTR';
alter table extension drop column  HEALTH_FACILITIES_DSTR;
delete from diccionario where nombre_campo='LOSS_HEALTH_FACILITIES';
alter table extension drop column  LOSS_HEALTH_FACILITIES;


delete from diccionario where nombre_campo='EDUCATION_DMGD';
alter table extension drop column  EDUCATION_DMGD;
delete from diccionario where nombre_campo='EDUCATION_DSTR';
alter table extension drop column  EDUCATION_DSTR;
delete from diccionario where nombre_campo='LOSS_EDUCATION';
alter table extension drop column  LOSS_EDUCATION;

delete from diccionario where nombre_campo='NUMBER_INFRASTRUCTURES';
alter table extension drop column  NUMBER_INFRASTRUCTURES;
delete from diccionario where nombre_campo='NUMBER_DMGD_INFRASTRUCTURES';
alter table extension drop column  NUMBER_DMGD_INFRASTRUCTURES;
delete from diccionario where nombre_campo='NUMBER_DSTR_INFRASTRUCTURES';
alter table extension drop column  NUMBER_DSTR_INFRASTRUCTURES;
delete from diccionario where nombre_campo='LOSS_INFRASTRUCTURES';
alter table extension drop column  LOSS_INFRASTRUCTURES;

delete from diccionario where nombre_campo='LOSS_CULTURAL_FIXED';
alter table extension drop column  LOSS_CULTURAL_FIXED;
delete from diccionario where nombre_campo='LOSS_CULTURAL_MOBILE_DMGD';
alter table extension drop column  LOSS_CULTURAL_MOBILE_DMGD;
delete from diccionario where nombre_campo='LOSS_CULTURAL_MOBILE_DSTR';
alter table extension drop column  LOSS_CULTURAL_MOBILE_DSTR;
delete from diccionario where nombre_campo='CULTURAL_FIXED_DMGD';
alter table extension drop column  CULTURAL_FIXED_DMGD;
delete from diccionario where nombre_campo='CULTURAL_FIXED_DSTR';
alter table extension drop column  CULTURAL_FIXED_DSTR;
delete from diccionario where nombre_campo='CULTURAL_MOBILE_DMGD';
alter table extension drop column  CULTURAL_MOBILE_DMGD;
delete from diccionario where nombre_campo='CULTURAL_MOBILE_DSTR';
alter table extension drop column  CULTURAL_MOBILE_DSTR;



