--ora ctx 2016-11-29 NP

select c.reporting_date, w.name worksapce, p.description position, c.creation_date, pk_rd_ws, PK_RD, context_id, COPY_CONTEXT_ID
from contexts c, workspaces w, position p
where c.workspace_id=w.workspace_id
and c.position=p.position
and ((:V1 is null and :V2 is null and to_char(reporting_date,'YYYY/MM/DD')= to_char(current_date -1,'YYYY/MM/DD')) 
or (upper(:V1)=substr(p.description,1,2) and :V2 is null and to_char(reporting_date,'YYYY/MM/DD')= to_char(current_date-1,'YYYY/MM/DD') )
or (:V1=to_char(reporting_date,'YYYY-MM-DD') and (substr(p.description,1,2)=upper(:V2) or (:V2 is null ) or substr(p.description,-2,2)=upper(:V2) or substr(w.name,-2,2)=upper(:V2))
)
);