-- Postgres database upgrade script
alter TABLE diccionario add	tabnumber integer;
alter TABLE diccionario add	fieldtype integer;
alter TABLE fichas add defaultab integer;


