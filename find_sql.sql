SELECT sql_id,
  child_number,
  plan_hash_value plan_hash,
   BUFFER_GETS, 
   --IS_BIND_SENSITIVE AS "BIND_SENSI", 
   --IS_BIND_AWARE AS "BIND_AWARE",
   --IS_SHAREABLE AS "BIND_SHARE",
  executions execs,
  ROUND((elapsed_time/1000000),2) etime_secs,
  ROUND((elapsed_time/1000000)/DECODE(NVL(executions,0),0,1,executions),2) avg_etime_secs,
  --BUFFER_GETS/executions,
  u.username,
  sql_fulltext
  --sql_text
FROM v$sql s,
  dba_users u
WHERE 
--sql_id like nvl('&sql_id',sql_id)
upper(sql_text) like '%'||upper(:V1)||'%'
AND sql_text NOT LIKE '%from v$sql where sql_id like nvl(%'
AND u.user_id = s.parsing_user_id
order by 5 desc;