select * from user_source where upper(text) like '%'||upper(:V1)||'%';