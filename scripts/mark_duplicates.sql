-- drop table alldups;

create table alldups (clave integer not null, approved integer);
alter table alldups add constraint alldupsPK primary key (clave);

 
insert into alldups  select clave, approved from fichas f, 
( select * from (select count(*) as nrecs, serial, evento, level0, level1, level2, fechano, fechames, fechadia from fichas
         where level2 is not null and level1 is not null AND (APPROVED=0 OR APPROVED IS NULL) 
         group by serial, evento, level0, level1, level2, fechano, fechames, fechadia) 
  w where nrecs>1 
 ) q where f.serial=q.serial and f.evento=q.evento and f.level0=q.level0 and f.level1=q.level1 and f.level2=q.level2 and f.fechano=q.fechano and f.fechames=q.fechames and f.fechadia=q.fechadia;

insert into alldups  select clave, approved from fichas f, 
( select * from (select count(*) as nrecs, serial, evento, level0, level1, fechano, fechames, fechadia from fichas 
        where level1 is not null AND level2 is null AND (APPROVED=0 OR APPROVED IS NULL)
        group by serial, evento, level0, level1, fechano, fechames, fechadia) w where nrecs>1 
 ) q where f.serial=q.serial and f.evento=q.evento and f.level0=q.level0 and f.level1=q.level1 and f.fechano=q.fechano and f.fechames=q.fechames and f.fechadia=q.fechadia;


insert into alldups  select clave, approved from fichas f, 
( select * from (select count(*) as nrecs, serial, evento, level0, fechano, fechames, fechadia from fichas 
         where level1 is null AND level2 is null and (APPROVED=0 OR APPROVED IS NULL)
         group by serial, evento, level0,  fechano, fechames, fechadia) w where nrecs>1 
) q where f.serial=q.serial and f.evento=q.evento and f.level0=q.level0 and f.fechano=q.fechano and f.fechames=q.fechames and f.fechadia=q.fechadia;


update fichas set approved=2 where clave in (select clave from alldups);


--- SECOND PART:   USE WITH CAUTION   (not really recommended)
-- This part of the script will enable the first of each group of duplicates. again NOT recommended.  Use only in unrent case to get all the data
-- Using it will prevent all datacards to be reviewed.

update fichas set approved=0 where clave in 
(select firstclave from 
 (select MAX(f.clave) as firstclave, count(*) as nrecs, serial, evento, level0, level1, level2, fechano, fechames, fechadia 
        from fichas f, alldups a
         where f.clave=a.clave 
               and level2 is not null and level1 is not null
         group by serial, evento, level0, level1, level2, fechano, fechames, fechadia) q
  where nrecs>1
);


update fichas set approved=0 where clave in 
(select firstclave from 
 (select MAX(f.clave) as firstclave, count(*) as nrecs, serial, evento, level0, level1, fechano, fechames, fechadia 
        from fichas f, alldups a
         where f.clave=a.clave 
               and level2 is null and level1 is not null
         group by serial, evento, level0, level1, level2, fechano, fechames, fechadia) q
  where nrecs>1
);


update fichas set approved=0 where clave in 
(select firstclave from 
 (select MAX(f.clave) as firstclave, count(*) as nrecs, serial, evento, level0, fechano, fechames, fechadia 
        from fichas f, alldups a
         where f.clave=a.clave 
               and level2 is null and level1 is null
         group by serial, evento, level0, level1, level2, fechano, fechames, fechadia) q
  where nrecs>1
);


-- drop table alldups;
