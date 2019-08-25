select *
from
(
select d.tablespace_name,
--round(d.bytes_gb) size_gb,
round(d.bytes_gb - nvl(f.bytes_gb,0)) used_size_gb,
--round((d.bytes_gb - nvl(f.bytes_gb,0))/d.bytes_gb*100,2) pct_used,
round(nvl(d.max_gb,d.bytes_gb)) max_size_gb,
round(-round(d.bytes_gb - nvl(f.bytes_gb,0))+round(nvl(d.max_gb,d.bytes_gb))) free_size_gb,
round(decode(d.max_gb, 0, 0, ((d.bytes_gb - nvl(f.bytes_gb,0))/d.max_gb)*100),2) pct_max_used
from
(
select tablespace_name,
sum(bytes)/1024/1024/1024 bytes_gb,
sum( decode(maxbytes,0,bytes,maxbytes) )/1024/1024/1024 max_gb
from dba_data_files
group by tablespace_name
) d,
(
select tablespace_name,
sum(bytes)/1024/1024/1024 bytes_gb
from dba_free_space
group by tablespace_name
) f
where f.tablespace_name(+)=d.tablespace_name
);
