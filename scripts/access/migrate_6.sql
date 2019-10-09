-- ACCESS database script - upgrade to data model version 6
alter table extensioncodes add code_value text(10) not null;
alter table extensioncodes drop constraint extensioncodesPK;
alter table extensioncodes add constraint extensioncodesPK primary key (field_name, code_value);
 
 



