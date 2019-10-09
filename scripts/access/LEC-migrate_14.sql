
create table LEC_Categories
	(
	Category varchar(255) NOT NULL, 
	Description varchar(255), 
	PRIMARY KEY (Category)
	);

CREATE TABLE LEC_TimeLapse (
	F_Cat varchar(255) NOT NULL,
	S_Cat varchar(255) NOT NULL,
	TLapse int,
	CONSTRAINT fk_FC FOREIGN KEY (F_Cat) REFERENCES LEC_Categories(Category),
	CONSTRAINT fk_SC FOREIGN KEY (S_Cat) REFERENCES LEC_Categories(Category)
); 

ALTER TABLE LEC_TimeLapse ADD CONSTRAINT pk_tl_ID PRIMARY KEY (F_Cat, S_Cat);

CREATE TABLE LEC_IdSuceso
	(
	claveFichas int,
	anio int,
	fecha date,
	status int,
	Cause varchar(255),
	OldCat varchar(255),
	NewCat varchar(255),
	IdSuceso varchar(255),
	PEconomica double,
	CONSTRAINT fk_OCat FOREIGN KEY (OldCat) REFERENCES LEC_Categories(Category),
	CONSTRAINT fk_NCat FOREIGN KEY (NewCat) REFERENCES LEC_Categories(Category)
	);

CREATE TABLE LEC_CostosUnitarios
	(
	clave int, 
	colName varchar(255) NOT NULL, 
	descripcion varchar(255) NOT NULL, 
	CUnitario int
	);

INSERT INTO LEC_CostosUnitarios VALUES (1, 'vivafec', 'AffectedHouses',0);
INSERT INTO LEC_CostosUnitarios VALUES (2, 'vivdest', 'DestroyedHouses',0);
INSERT INTO LEC_CostosUnitarios VALUES (3, 'nhospitales', 'Hospitals',0);
INSERT INTO LEC_CostosUnitarios VALUES (4, 'nescuelas', 'Escuelas',0);
INSERT INTO LEC_CostosUnitarios VALUES (5, 'nhectareas', 'Damagesincrops',0);
INSERT INTO LEC_CostosUnitarios VALUES (6, 'cabezas', 'Ganado',0);
INSERT INTO LEC_CostosUnitarios VALUES (7, 'Kmvias', 'Vias',0);

INSERT INTO LEC_Categories VALUES ('Tectonic', 'Earthquakes, Tsunamis, etc');
INSERT INTO LEC_Categories VALUES ('Drought', 'Earthquakes, Tsunamis, Volcano, etc');
INSERT INTO LEC_Categories VALUES ('Landslides', 'General category');
INSERT INTO LEC_Categories VALUES ('Hydromet', 'Weather related events');
INSERT INTO LEC_Categories VALUES ('Volcano', 'Earthquakes, Tsunamis, Volcano, etc');


