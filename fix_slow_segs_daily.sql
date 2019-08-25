SET pages 5000 lines 150
SET echo OFF TIME ON timing ON
SET serveroutput ON size unl
spool /tmp/fix_slow_segs.log append;
show USER;
SELECT TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI:SS') starttime
FROM dual;
DECLARE
  v_time VARCHAR2(50);
BEGIN
  -- check slow segments exist for a given tablespace
  FOR ex IN
  (SELECT tablespace_name tbs_name ,
    SUM(DECODE(bitand(segment_flags,131072),0,1)) slow_segs
  FROM sys.sys_dba_segs
  WHERE bitand(segment_flags,1)=1
  AND segment_type NOT        IN ('ROLLBACK', 'DEFERRED ROLLBACK', 'TYPE2 UNDO')
  AND (
  tablespace_name ='FMTALM_DATA'
  )
  GROUP BY tablespace_name
--  HAVING SUM(DECODE(bitand(segment_flags,131072),0,1)) > 500
--  order by 1
  )
  LOOP
    SELECT TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI:SS') INTO v_time FROM dual;
    dbms_output.put_line('Fixing tablespace: '||ex.tbs_name||' Slowsegs: '||ex.slow_segs||' starts at '||v_time);
    -- If slow segments found, then fix them
    dbms_space_admin.tablespace_fix_segment_extblks(ex.tbs_name);
    SELECT TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI:SS')
    INTO v_time
    FROM dual;
    dbms_output.put_line('Fixing tablespace: '||ex.tbs_name||' ends at '||v_time);
    dbms_output.put_line('--------------------------------------------');
  END LOOP;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Exception occured: '||SQLERRM);
END;
/
SELECT TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI:SS') endtime FROM dual;
spool off;
exit;
