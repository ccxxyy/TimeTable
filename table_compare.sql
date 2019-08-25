-- ora table_verification 201708 jo

declare

src_rd date;
desc_rd date;
src_par varchar(100);
des_par varchar(100);
src_val number;
des_val number;
sql1 varchar(100);
sql2 varchar(100);

begin 

with 
tmp as (
select c.reporting_date, c.pk_rd_ws from contexts c,  position p
WHERE c.position=p.position
and reporting_date> to_date(:V1,'YYYYMM')
and upper(:V2)=substr(p.description,-2,2)
and p.description like 'IRRBB%')
select pk_rd_ws, reporting_date into des_par, desc_rd from tmp where reporting_date=(select max(reporting_date) from tmp);

with 
tmp1 as (
select c.reporting_date, c.pk_rd_ws from contexts c,  position p
WHERE c.position=p.position
and reporting_date> add_months(to_date(:V1,'YYYYMM'),-1)
and reporting_date< to_date(:V1,'YYYYMM')
and upper(:V2)=substr(p.description,-2,2)
and p.description like 'IRRBB%')
select pk_rd_ws , reporting_date into src_par, src_rd from tmp1 where reporting_date=(select max(reporting_date) from tmp1);

dbms_output.put_line('table name--'||to_char(src_rd,'yyyy-mm-dd')||'--'||to_char(desc_rd,'yyyy-mm-dd'));
dbms_output.put_line(src_par);
dbms_output.put_line(des_par);
for rec in (
SELECT table_name FROM cd_fdw_structure 
where object_type='TABLE' and table_type='PARAM' and table_name not like '%#CR%'
and is_partitioned='Y')

loop 
	sql1 := 'select count(*) from ' ||rec.table_name|| ' where partition_key='''||src_par||'''';
	sql2 := 'select count(*) from ' ||rec.table_name|| ' where partition_key='''||des_par||'''';
	execute immediate sql1 into src_val;
	execute immediate sql2 into des_val;
	if src_val!= des_val then 
		dbms_output.put_line(rec.table_name||'--'||src_val||'--'||des_val);
	end if;
end loop;

end;
