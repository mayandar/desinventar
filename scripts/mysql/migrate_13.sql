
create table  LEC_cpi (
   lec_year  int(10)  not null,
   lec_cpi  double,
   PRIMARY KEY LEC_cpiPK (lec_year)
)ENGINE=InnoDB;

create table  LEC_exchange (
   lec_year  int(10)  not null,
   lec_rate  double,
   PRIMARY KEY LEC_exchangePK (lec_year)
)ENGINE=InnoDB;

CREATE TABLE event_grouping (
	nombre varchar (30)  NOT NULL ,
	lec_grouping_days int(10),
	category varchar(30),
	PRIMARY KEY  event_groupingPK (nombre) 
)ENGINE=InnoDB; 
alter table event_grouping add constraint eventos_h_hierarchyFK foreign key (nombre) references eventos(nombre);


alter table eventos add	    parent varchar (30);
alter table eventos add		terminal int(10);
alter table eventos add		hlevel int(10);
alter table eventos add constraint eventos_hierarchyFK foreign key (parent) references eventos(nombre);

