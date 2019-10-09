select * from lev1 where lev1_lev0 not in (select lev0_cod from lev0);
select * from lev2 where lev2_lev1 not in (select lev1_cod from lev1);
select * from fichas where causa not in (select causa from causas) and causa is not null and causa<>'';
select * from fichas where level1 not in (select lev1_cod from lev1) and level1 is not null and level1<>'';
select * from fichas where level2 not in (select lev2_cod from lev2) and level2 is not null and level2<>'';
select * from fichas where evento not in (select nombre from eventos) and evento is not null and evento<>'';



select * from lev1 where lev1_lev0 not in (select lev0_cod from lev0);
select * from lev2 where lev2_lev1 not in (select lev1_cod from lev1);
select * from (fichas left join causas on fichas.causa=causas.causa) where causas.causa is null and fichas.causa<>'' and fichas.causa is not null;
select * from (fichas left join lev0 on fichas.level0=lev0.lev0_cod) where lev0_cod is null and fichas.level0 is not null and fichas.level0<>'';
select * from (fichas left join lev1 on fichas.level1=lev1.lev1_cod) where lev1_cod is null and fichas.level1 is not null and fichas.level1<>'';
select * from (fichas left join lev2 on fichas.level2=lev2.lev2_cod) where lev2_cod is null and fichas.level2 is not null and fichas.level2<>'';
select * from (fichas left join eventos on fichas.evento=eventos.nombre) where nombre is null and fichas.evento is not null and fichas.evento<>'';

