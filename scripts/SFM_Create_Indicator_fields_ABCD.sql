 
-----------------------------------------------------------------------------------------------------------------------------
-- SFM Indicators and  targets   (A-D)
-----------------------------------------------------------------------------------------------------------------------------
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (5,'A_1','Relative Mortality','Relative Mortality','Relative Mortality',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (6,'B_1','Relative Affected','Relative Affected','Relative Affected',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (7,'C_1','Relative Economic loss','Relative Economic loss','Relative Economic loss',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (8,'A_2','Relative Deaths','Relative Deaths','Relative Deaths',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (9,'A_3','Relative Missing','Relative Missing','Relative Missing',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (10,'B_1a','B-1a Total affected','B-1a Total affected','B-1a Total affected',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (11,'C_1a','C-1a Total Economic loss','C-1a Total Economic loss','C-1a Total Economic loss',0,0,0,0,0,null,2);
alter table extension add A_1 float;
alter table extension add A_2 float;
alter table extension add A_3 float;
alter table extension add B_1 float;
alter table extension add B_1a float;
alter table extension add C_1 float;
alter table extension add C_1a float;


-----------------------------------------------------------------------------------------------------------------------------
--GAR 2019 Intermediate Economic loss assessment  INDEPENDENT FIELDS
-----------------------------------------------------------------------------------------------------------------------------
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (12,'ECONOMIC_LOSS','Economic loss','Economic loss','Economic loss',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (13,'ECONOMIC_LOSS_C2','Economic loss Agriculture','Economic loss Agriculture C2','Economic loss Agriculture C2',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (14,'ECONOMIC_LOSS_C3','Economic loss C3','Economic loss C3','Economic loss C3',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (15,'ECONOMIC_LOSS_C4','Economic loss C4','Economic loss C4','Economic loss C4',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (16,'ECONOMIC_LOSS_C4DM','Economic loss houses damaged','Economic loss  houses damaged','Economic loss  houses damaged',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (17,'ECONOMIC_LOSS_C4DY','Economic loss houses destroyed','Economic loss  houses destroyed','Economic loss  houses destroyed',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (19,'ECONOMIC_LOSS_C5','Economic loss infrastructures C5','Economic loss infrastructures C5','Economic loss C5',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (20,'ECONOMIC_LOSS_HEALTH','Economic loss Health','Economic loss Health','Economic loss Health',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (21,'ECONOMIC_LOSS_EDU','Economic loss Education','Economic loss Education','Economic loss Education',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (22,'ECONOMIC_LOSS_C6','Economic loss Cultural H','Economic loss Cultural H','Economic loss CH',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (23,'T_LOSS_CROPS','T Economic loss Crops calculated','T Economic loss crops calculated','Economic loss crops calculated',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (24,'T_LOSS_LIVESTOCK','T Economic loss Livestock calculated','T Economic loss Livestock calculated','Economic loss Livestock calculated',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (25,'T_LOSS_AGRI_ASSETS','T Economic loss AGRI_ASSETS calculated','T Economic loss AGRI_ASSETS calculated','Economic loss AGRI_ASSETS calculated',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (26,'T_LOSS_STOCK','T Economic loss STOCK calculated','T Economic loss STOCK calculated','Economic loss STOCK calculated',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (27,'T_LOSS_VESSELS','T Economic loss VESSELS calculated','T Economic loss VESSELS calculated','Economic loss VESSELS calculated',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (28,'T_LOSS_AQUACULTURE','T Economic loss AQUACULTURE calculated','T Economic loss AQUACULTURE calculated','Economic loss AQUACULTURE calculated',0,0,0,0,0,null,2);

alter table extension add ECONOMIC_LOSS float;
alter table extension add ECONOMIC_LOSS_C2 float;
alter table extension add ECONOMIC_LOSS_C3 float;
alter table extension add ECONOMIC_LOSS_C4 float;
alter table extension add ECONOMIC_LOSS_C4DM float;
alter table extension add ECONOMIC_LOSS_C4DY float;
alter table extension add ECONOMIC_LOSS_C5 float;
alter table extension add ECONOMIC_LOSS_HEALTH float;
alter table extension add ECONOMIC_LOSS_EDU float;
alter table extension add ECONOMIC_LOSS_C6 float;
alter table extension add T_LOSS_CROPS float;
alter table extension add T_LOSS_LIVESTOCK float;
alter table extension add T_LOSS_AGRI_ASSETS float;
alter table extension add T_LOSS_STOCK float;
alter table extension add T_LOSS_VESSELS float;
alter table extension add T_LOSS_AQUACULTURE float;

insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (29,'T_LIVING_DMG','T People living houses damaged calculated','T People living houses damaged calculated','T People living houses damaged calculated',0,0,0,0,0,null,2);
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (30,'T_LIVING_DST','T People living houses destroyed calculated','T People living houses destroyed calculated','T People living houses destroyed calculated',0,0,0,0,0,null,2);
alter table extension add T_LIVING_DMG float;
alter table extension add T_LIVING_DST float;

