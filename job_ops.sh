#!/bin/bash
source ${HOME}/env.sh

function send_mail()
{
(
 echo "Subject: $SUBJECT"
 echo "From: $from"
 echo "To: $mail_to"
 echo "Cc: $CC"
 echo "MIME-Version: 1.0"
 echo 'Content-Type: multipart/mixed; boundary="-q1w2e3r4t5"'
 echo
 echo '---q1w2e3r4t5'
 echo "Content-Type: text/html"
 echo "Content-Disposition: inline"
 echo "$msg"
) | /usr/sbin/sendmail -t $mail_to

}


function folder_ops(){
	application=`echo $1 | tr 'a-z' 'A-Z'`
	odate=$2
	group=`echo $3 | tr 'a-z' 'A-Z'`
	action=$4
	datetime=`date '+%Y%m%d%H%M%S'`
	info="/tmp/folder_info_${datetime}.output"
	info_up="/tmp/folder_info_up_${datetime}.output"
	log="/tmp/folder_${action}_${datetime}.log"
	output="/tmp/folder_output_${action}_${datetime}.log"
	/apps/ctmagent/ctm/exe/ctmpsm -LISTSUBAPPLICATION FERMAT_$application $group $odate > $info
	cat $info| grep 'FLD' > $info_up
	#Do hold/release
	if [[ ! -s $info_up ]]; then
		echo "Can't find $group for $odate for application FERMAT_$application, please verify."
	else
		cat $info_up | while read line
		do
			oid=`echo $line| awk -F '|' '{print substr($1,4)}'`
			folder_name=`echo $line |cut -d \| -f 2`
			/home/fmdsadm/script/ctmapi.sh ray $action $oid >$log
			if [[ `cat $log|grep -i fail|wc -l` -ge 1 ]]; then
				echo "Folder $folder_name $oid for $odate $action Failed </br>" >>$output
			else
				echo "Folder $folder_name $oid for $odate $action Succeed </br>" >>$output
			fi
		done
		if [[  `cat $output|grep -i fail|wc -l` -ge 1 ]]; then
			export SUBJECT="$application batch folder $group $action failed - $odate"
			msg="
			</br>
			Hello team,</br>
			</br>
			Faild to $action, please refer to below </br>
			</br>
			`cat $output`
			</br>
			Thanks</br>
			</br>
			BSM PSS</br>
			"
			send_mail
		else
			export SUBJECT="$application batch folder $group $action completed - $odate"
			msg="
			</br>
			Hello team,</br>
			</br>
			Batch $action completed, please refer to below </br>
			</br>
			`cat $output`
			</br>
			Thanks</br>
			</br>
			BSM PSS</br>
			"
			send_mail
		fi
	
	fi
	

}


function job_ops(){
	#group=$1
	application=`echo $1 | tr 'a-z' 'A-Z'`
	odate=$2
	group=`echo $3 | tr 'a-z' 'A-Z'`
	job=`echo $4 | tr 'a-z' 'A-Z'`
	action=$5
	date=`date '+%Y%m%d'`
	datetime=`date '+%Y%m%d%H%M%S'`
	info="/tmp/job_info_${datetime}.output"
	info_up="/tmp/job_info_up_${datetime}.output"
	#log='/tmp/stdf_hold.log'
	log="/tmp/job_${action}_${datetime}.log"
	output="/tmp/job_output_${action}_${datetime}.log"
	#echo $date
	/apps/ctmagent/ctm/exe/ctmpsm -LISTSUBAPPLICATION FERMAT_$application $group $odate > $info
	#oid=`cat $info| grep FLD| awk -F '|' '{print substr($1,4)}'`
	#echo $oid
	#/home/fmdsadm/script/ctmapi.sh ray $action $oid >$log
	cat $info| grep $job > $info_up
	cat $info_up | while read line
	do
		#echo $line
		oid=`echo $line| awk -F '|' '{print substr($1,4)}'`
		job_name=`echo $line |cut -d \| -f 2`
		/home/fmdsadm/script/ctmapi.sh ray $action $oid >$log
		if [[ `cat $log|grep -i fail|wc -l` -ge 1 ]]; then
			echo "Job $job_name $oid for $odate $action Failed </br>" >>$output
			else
			echo "Job $job_name $oid for $odate $action Succeed </br>" >>$output
		fi
	#echo $oid
	done
	
	if [[  `cat $output|grep -i fail|wc -l` -ge 1 ]]; then
		export SUBJECT="$application batch $job $action failed - $odate"
		msg="
		</br>
		Hello team,</br>
		</br>
		Faild to $action, please refer to below </br>
		</br>
		`cat $output`
		</br>
		Thanks</br>
		</br>
		BSM PSS</br>
		"
		send_mail
	else
		export SUBJECT="$application batch $job $action completed - $odate"
		msg="
		</br>
		Hello team,</br>
		</br>
		Batch $action completed, please refer to below </br>
		</br>
		`cat $output`
		</br>
		Thanks</br>
		</br>
		BSM PSS</br>
		"
		send_mail
	fi
}

#main

export from="BSMPSS@sc.com"
export mail_to="ivesxiaoyi.cai@sc.com"

if [[ "$#" -lt "4" ]]; then
	echo 'Usage: ./job_ops.sh job <ALM|FDSF|IRRBB|RAY|TABLEAU> <DATE(YYYYMMDD)> <Folder Name> <Job(keyword)> <hold|release>'
	echo '       ./job_ops.sh folder <ALM|FDSF|IRRBB|RAY|TABLEAU> <DATE(YYYYMMDD)> <Folder Name>  <hold|release> '
else
	opstype=`echo $1 | tr 'a-z' 'A-Z'`
	if [ "${opstype}" = "JOB" ]; then
		if [[ "$#" -eq "6" ]]; then
			job_ops $2 $3 $4 $5 $6
		else
			echo 'Usage: ./job_ops.sh job <ALM|FDSF|IRRBB|RAY|TABLEAU> <DATE(YYYYMMDD)> <Folder Name> <Job(keyword)> <hold|release>'
			echo '       ./job_ops.sh folder <ALM|FDSF|IRRBB|RAY|TABLEAU> <DATE(YYYYMMDD)> <Folder Name>  <hold|release> '
		fi
		
	elif [ "${opstype}" = "FOLDER" ]; then
		if [[ "$#" -eq "5" ]]; then
			folder_ops $2 $3 $4 $5
		else
			echo 'Usage: ./job_ops.sh job <ALM|FDSF|IRRBB|RAY|TABLEAU> <DATE(YYYYMMDD)> <Folder Name> <Job(keyword)> <hold|release>'
			echo '       ./job_ops.sh folder <ALM|FDSF|IRRBB|RAY|TABLEAU> <DATE(YYYYMMDD)> <Folder Name>  <hold|release> '
		fi
	else
		echo 'Usage: ./job_ops.sh job <ALM|FDSF|IRRBB|RAY|TABLEAU> <DATE(YYYYMMDD)> <Folder Name> <Job(keyword)> <hold|release>'
		echo '       ./job_ops.sh folder <ALM|FDSF|IRRBB|RAY|TABLEAU> <DATE(YYYYMMDD)> <Folder Name>  <hold|release> '
	fi
fi
