-- ora drop_ctx 2016-11-17 LIQ ZA
declare

ctx_id number;
pos number;

begin

if :V3 is not null then
	select position into pos from position where description like ''||:V3||'%';
else pos:=0;
end if;
--dbms_output.put_line(pos);

if :V2='LIQ' then
	select context_id into ctx_id from contexts where reporting_date=:V1 and workspace_id=2 and position=pos;
elsif :V2='HZON' then
	select context_id into ctx_id from contexts where reporting_date=:V1 and workspace_id=99 and position=pos;
else select context_id into ctx_id from contexts where reporting_date=:V1 and workspace_id not in (2,99) and position=pos;
end if;
dbms_output.put_line('dropping context_id '||ctx_id);

PACK_DDL.enable_disable_trigger('CONTEXTS','N');
pack_context.drop_context( ctx_id, 'Y', 'Y');
PACK_DDL.enable_disable_trigger('CONTEXTS','Y');

end;
/

