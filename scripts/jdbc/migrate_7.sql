-- Postgres database script - upgrade to data model version 6
ALTER TABLE fichas ALTER COLUMN serial TYPE varchar (15); 
 