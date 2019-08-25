-- max, min and average of last 30 days
SELECT 
  scb_country COUNTRY,
  JOB_NAME JOBNAME,
  Round(avg(ELAPSED_TIME_SECS) / 60, 0) AS avg_Mins
FROM scbrpt.scb_job_stats
where 
--scb_country=UPPER(:COUNTRY)
scb_country=trim(UPPER(:V1))
--scb_country=UPPER(trim(replace(:COUNTRY,chr(10),'')))
--and job_name = 'scb_exec_alm_process'
and reporting_date>=sysdate-91
and reporting_date<=sysdate-1
and job_success='Y'
AND ( (scb_country                                                   IN ('AE','OM','BH','JO','QA')
  AND trim(TO_CHAR(reporting_date,'day','NLS_DATE_LANGUAGE = American')) NOT IN ('friday'))
  OR (scb_country                                                      IN ('BD')
  AND trim(TO_CHAR(reporting_date,'day','NLS_DATE_LANGUAGE = American')) NOT IN ('friday','saturday'))
  OR (scb_country                                                      IN ('NP')
  AND trim(TO_CHAR(reporting_date,'day','NLS_DATE_LANGUAGE = American')) NOT IN ('saturday'))
  OR (scb_country                                                      IN ('JP','KR','MY','SG','CN','HK','TW','PH','BN','ID','TH','VN','NP','IN','LK','PK','KE','BW','ZA','ZW','NG','EU','GH','US')
  AND trim(TO_CHAR(reporting_date,'day','NLS_DATE_LANGUAGE = American')) NOT IN ('saturday','sunday')) )
group by job_name,scb_country
order by 3 desc