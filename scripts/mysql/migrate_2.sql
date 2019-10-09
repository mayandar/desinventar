-- MySQL database upgrade script
alter TABLE diccionario add	tabnumber int(4);
alter TABLE diccionario add	fieldtype int(4);
alter TABLE fichas add	defaultab int(4);


