create table  LEC_cpi (
   lec_year  smallint not null,
   lec_cpi  float);
alter table LEC_cpi  add constraint LEC_cpiPK PRIMARY KEY (lec_year);

create table  LEC_exchange (
   lec_year  smallint not null,
   lec_rate  float);
alter table LEC_exchange  add constraint LEC_exchangePK PRIMARY KEY (lec_year);

CREATE TABLE event_grouping (
	nombre nvarchar (30)  NOT NULL ,
	lec_grouping_days smallint,
	category  nvarchar(30)
); 

alter table event_grouping add constraint event_groupingPK PRIMARY KEY (nombre);
alter table event_grouping add constraint eventos_h_hierarchyFK foreign key (nombre) references eventos(nombre);

alter table eventos add	    parent nvarchar (30);
alter table eventos add		terminal int;
alter table eventos add		hlevel int;
alter table eventos add		constraint eventos_hierarchyFK foreign key (parent) references eventos(nombre);
 

 

