-- ORACLE database upgrade script
alter TABLE diccionario add	tabnumber number(4);
alter TABLE diccionario add	fieldtype number(4);
alter TABLE fichas add defaultab number(4);

