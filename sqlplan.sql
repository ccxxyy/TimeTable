--ora sqlplan xxx 0

SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR(:V1,:V2));