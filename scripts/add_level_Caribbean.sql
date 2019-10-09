-- ANTIGUA
-- move down level 1
insert into lev2 select 'ATG'& lev1_cod as lev2_cod, lev1_name as lev2_name, lev1_name_en as lev2_name_en, 'ATG' & lev1_lev0 as lev2_lev1 from lev1;
update fichas set level2 = 'ATG'& level1, name2=name1 where level1 is not null;
update fichas set level1=null;
delete from lev1;

-- create country level in level0;
insert into lev0 (lev0_cod,lev0_name, lev0_name_en) values ('ATG','Antigua and Barbuda','Antigua and Barbuda');


-- move down level 0
insert into lev1 select 'ATG'& lev0_cod as lev1_cod, lev0_name as lev1_name, lev0_name_en as lev1_name_en, 'ATG' as lev1_lev0 from lev0 where lev0_cod<>'ATG';

update fichas set level1 = 'ATG'& level0, name1=name0;
update fichas set level0='ATG', name0='Antigua and Barbuda';
delete from lev0 where lev0_cod<>'ATG';

-------------------------------------------------------------------------
-- Dominica
-- move down level 1
insert into lev2 select 'DMA'& lev1_cod as lev2_cod, lev1_name as lev2_name, lev1_name_en as lev2_name_en, 'DMA' & lev1_lev0 as lev2_lev1 from lev1;
update fichas set level2 = 'DMA'& level1, name2=name1 where level1 is not null;
update fichas set level1=null;
delete from lev1;

-- create country level in level0;
insert into lev0 (lev0_cod,lev0_name, lev0_name_en) values ('DMA','Dominica','Dominica');


-- move down level 0
insert into lev1 select 'DMA'& lev0_cod as lev1_cod, lev0_name as lev1_name, lev0_name_en as lev1_name_en, 'DMA' as lev1_lev0 from lev0 where lev0_cod<>'DMA';

update fichas set level1 = 'DMA'& level0, name1=name0;
update fichas set level0='DMA', name0='Dominica';
delete from lev0 where lev0_cod<>'DMA';



-------------------------------------------------------------------------
-- Grenada

-- save level2 info
update fichas set lugar=name2 + ' - ' + iif(lugar is null,'',lugar) where level2 is not null and (lugar<>level2 or lugar is null);

-- move down level 1
insert into lev2 select 'GRD'& lev1_cod as lev2_cod, lev1_name as lev2_name, lev1_name_en as lev2_name_en, 'GRD' & lev1_lev0 as lev2_lev1 from lev1;
update fichas set level2 = 'GRD'& level1, name2=name1 where level1 is not null;
update fichas set level1=null;
delete from lev1;

-- create country level in level0;
insert into lev0 (lev0_cod,lev0_name, lev0_name_en) values ('GRD','Grenada','Grenada');


-- move down level 0
insert into lev1 select 'GRD'& lev0_cod as lev1_cod, lev0_name as lev1_name, lev0_name_en as lev1_name_en, 'GRD' as lev1_lev0 from lev0 where lev0_cod<>'GRD';

update fichas set level1 = 'GRD'& level0, name1=name0;
update fichas set level0='GRD', name0='Grenada';
delete from lev0 where lev0_cod<>'GRD';



-------------------------------------------------------------------------
-- Saint Kitts and Nevis

-- move down level 1
insert into lev2 select 'KNA'& lev1_cod as lev2_cod, lev1_name as lev2_name, lev1_name_en as lev2_name_en, 'KNA' & lev1_lev0 as lev2_lev1 from lev1;
update fichas set level2 = 'KNA'& level1, name2=name1 where level1 is not null;
update fichas set level1=null;
delete from lev1;

-- create country level in level0;
insert into lev0 (lev0_cod,lev0_name, lev0_name_en) values ('KNA','Saint Kitts and Nevis','Saint Kitts and Nevis');


-- move down level 0
insert into lev1 select 'KNA'& lev0_cod as lev1_cod, lev0_name as lev1_name, lev0_name_en as lev1_name_en, 'KNA' as lev1_lev0 from lev0 where lev0_cod<>'KNA';

update fichas set level1 = 'KNA'& level0, name1=name0;
update fichas set level0='KNA', name0='Saint Kitts and Nevis';
delete from lev0 where lev0_cod<>'KNA';



-------------------------------------------------------------------------
-- Saint Lucia
-- move down level 1
insert into lev2 select 'LCA'& lev1_cod as lev2_cod, lev1_name as lev2_name, lev1_name_en as lev2_name_en, 'LCA' & lev1_lev0 as lev2_lev1 from lev1;
update fichas set level2 = 'LCA'& level1, name2=name1 where level1 is not null;
update fichas set level1=null;
delete from lev1;

-- create country level in level0;
insert into lev0 (lev0_cod,lev0_name, lev0_name_en) values ('LCA','Saint Lucia','Saint Lucia');


-- move down level 0
insert into lev1 select 'LCA'& lev0_cod as lev1_cod, lev0_name as lev1_name, lev0_name_en as lev1_name_en, 'LCA' as lev1_lev0 from lev0 where lev0_cod<>'LCA';

update fichas set level1 = 'LCA'& level0, name1=name0;
update fichas set level0='LCA', name0='Saint Lucia';
delete from lev0 where lev0_cod<>'LCA';



-------------------------------------------------------------------------
-- Saint Vincent and the Grenadines
-- move down level 1
insert into lev2 select 'VCT'& lev1_cod as lev2_cod, lev1_name as lev2_name, lev1_name_en as lev2_name_en, 'VCT' & lev1_lev0 as lev2_lev1 from lev1;
update fichas set level2 = 'VCT'& level1, name2=name1 where level1 is not null;
update fichas set level1=null;
delete from lev1;

-- create country level in level0;
insert into lev0 (lev0_cod,lev0_name, lev0_name_en) values ('VCT','Saint Vincent & the Grenadines','Saint Vincent & the Grenadines');


-- move down level 0
insert into lev1 select 'VCT'& lev0_cod as lev1_cod, lev0_name as lev1_name, lev0_name_en as lev1_name_en, 'VCT' as lev1_lev0 from lev0 where lev0_cod<>'VCT';

update fichas set level1 = 'VCT'& level0, name1=name0;
update fichas set level0='VCT', name0='Saint Vincent & the Grenadines';
delete from lev0 where lev0_cod<>'VCT';



