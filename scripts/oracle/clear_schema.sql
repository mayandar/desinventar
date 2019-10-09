begin
   for i in 1..10 loop
	for rec in (select object_name, object_type 
			from user_objects
			where object_type in ('TABLE','FUNCTION','PROCEDURE','PACKAGE','SEQUENCE')) loop
		begin 
		execute immediate 'drop '||rec.object_type||' '||rec.object_name;
		exception when others then null;
		end;
	end loop;
   end loop;
end;
/

exit;

