SET pages 5000 lines 150
SET echo OFF TIME ON timing ON
SET serveroutput ON size unl
--spool fix_slow_segs.log append;
spool fix_stats.log;
--show USER;
SELECT TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI:SS') starttime
FROM dual;
EXEC dbms_stats.gather_schema_stats ( ownname => 'FMTALM_HK_PROD' , OPTIONS => 'GATHER AUTO' , degree => 8 );
SELECT TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI:SS') endtime FROM dual;
spool off;
exit;
