-- ACCESS database upgrade script
update fichas set 		
socorro = abs(socorro),
salud = abs(salud),
educacion = abs(educacion),
agropecuario = abs(agropecuario),
industrias = abs(industrias),
acueducto = abs(acueducto),
alcantarillado = abs(alcantarillado),
energia = abs(energia),
comunicaciones = abs(comunicaciones),
hay_otros=abs(hay_otros),
transporte = abs(transporte);



insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (320,'PUBLIC_ADMIN_SERVICE','Disruptions to Public Administration Service','Disruptions to Public Administration Service','Disruptions to Public Administration Service',0,0,7,0,0,null,1);
alter table extension add PUBLIC_ADMIN_SERVICE int;
insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values (321,'SOLID_WASTE_SERVICE','Disruptions to Solid Waste Service','Disruptions to Solid Waste Service','Disruptions to Solid Waste Service',0,0,7,0,0,null,1);
alter table extension add SOLID_WASTE_SERVICE int;
