#!/bin/sh

LANG=C
export LANG

alias ls=ls

#################################################################################
# ���� ����
#################################################################################
OS_STR="Linux"

HOST_NAME=`hostname`
DATE_STR=`date +%m%d`

RESULT_FILE=$HOST_NAME"_"$OS_STR"_"$DATE_STR".txt"
REF_FILE=$HOST_NAME"_"$OS_STR"_"$DATE_STR"_Ref.txt"

R_SVR="false"
NFS_SVR="false"

echo "***************************************************************************"				> $RESULT_FILE 2>&1
echo "*                                                                         *"				>>  $RESULT_FILE 2>&1
echo "*            Pre_Linux CCE(Common Configuration Enumeration) Check        *"				>>  $RESULT_FILE 2>&1
echo "*            Version : 1.0                                                *"				>>  $RESULT_FILE 2>&1
echo "*            Copyright : KISA                                             *"				>>  $RESULT_FILE 2>&1
echo "*                                                                         *"				>>  $RESULT_FILE 2>&1
echo "***************************************************************************"				>>  $RESULT_FILE 2>&1
echo " "													>>  $RESULT_FILE 2>&1
echo ""
echo ""
echo "################# Linux ���� ��ũ��Ʈ�� �����ϰڽ��ϴ� ###################"
echo ""
echo ""

#################################################################################
# �Լ� ����
#################################################################################

#ifconfig, netstat or ip, ss ��� ���� üũ
if [ `ifconfig -a | wc -l` -eq 0 ]
	then
		#ip, ss ��ɾ� ���
		IFIP_CHK=0
	else
		#ifconfig, netstat ��ɾ� ���
		IFIP_CHK=1
fi

# net-tools ��ġ ������ ���� ��ɾ� ����
port_chk (){

	if [ $IFIP_CHK -eq 1 ]
		then
			if [ -z "$1" ]
				then
					echo `netstat -a | egrep "$1"`
			fi			
		else
			if [ -z "$1" ]
				then
					echo `ss -a | egrep "$1"`
			fi
		
	fi
}

#################################################################################
# �⺻ ���� Check
#################################################################################
PW_FILE="/etc/passwd"     ###  �н����� ���� ��ġ ###
LOGIN_FILE="/etc/pam.d/login"     ### �α��� ���� ���� ��ġ ###
SMTP_CF_FILE="/etc/mail/sendmail.cf"     ### Sendmail ���� ���� ��ġ ###

#################################################################################
# ���� ��ũ��Ʈ ����
#################################################################################

echo "[U-01] root ������ ���� ���� ����"

if [ -f /etc/securetty ]
	then
		if [ `cat /etc/securetty | grep -i "^console" | grep -v "^#" | wc -l` -eq 1 ] 
			then
				if [ `cat /etc/securetty | grep -i "^pts" | grep -v "^#" | wc -l` -eq 0 ] 
					then
						#��ȣ
						TELNET=1
					else
						#���
						TELNET=0
				fi
		fi
	else
		#���
		TELNET=0
fi
	
if [ -f /etc/ssh/sshd_config ]
	then
		if [ `cat /etc/ssh/sshd_config | grep -i "^PermitRootLogin no" | grep -v "^#" | wc -l` -eq 1 ] 
			then
				#��ȣ
				SSH=1
			else
				#���
				SSH=0
		fi
	else
		#��ȣ
		SSH=1
fi

if [ $TELNET -eq 1 -a $SSH -eq 1 ]
	then
		echo "[U-01] ��ȣ" >> $RESULT_FILE 2>&1
	else
		echo "[U-01] ���" >> $RESULT_FILE 2>&1
fi
		
unset TELNET
unset SSH

echo "[U-02] �н����� ���⼺ ����"
#echo "[U-02] �н����� ���⼺ ����" >> $RESULT_FILE 2>&1
echo "[U-02] ����" >> $RESULT_FILE 2>&1

echo "[U-03] ���� ��� �Ӱ谪 ����"
#echo "[U-03] ���� ��� �Ӱ谪 ����" >> $RESULT_FILE 2>&1
echo "[U-03] ����" >> $RESULT_FILE 2>&1

echo "[U-04] �н����� �ִ� ���Ⱓ ����"
#echo "[U-04] �н����� �ִ� ���Ⱓ ����" >> $RESULT_FILE 2>&1

PMD=0
ACD=0

PASS_MAX_DAYS=`grep PASS_MAX_DAYS /etc/login.defs | grep -v "^#" | awk -F" " '{ print $2 }'`
if [ $PASS_MAX_DAYS ]
	then 
		if [ $PASS_MAX_DAYS -gt 90 ] ### -gt���� -ge�� ����
			then
				#���
				PMD=0
				echo "bbb"
			else
				#��ȣ
				PMD=1
		fi
	else 
		#���
		echo "aaa"
		PMD=0
fi		

unset PASS_MAX_DAYS

echo "root" > UAC.txt
awk -F: '$3 >= 500 && $7 !~ /false|nologin|null|halt|sync|shutdown/' /etc/passwd | awk -F: '{print $1}' >> UAC.txt

# for max_chk in $(cat UAC.txt)
#     do
#         day_chk=`cat /etc/shadow | grep $max_chk | awk -F: '{print $1, $5}'`

#         if [ `echo $day_chk | awk '{print $2}'` -gt 90 ]
# 			then
#                 echo $day_chk >> total_chk.txt
#         fi
#     done

# if [ `cat total_chk.txt | wc -l ` -eq 0 ]
# 	then
# 		#��ȣ
# 		ACD=1
# 	else
# 		#���
# 		ACD=0
# fi	

# if [ $PMD -eq 1 -a $ACD -eq 1 ]
# 	then
# 		echo "[U-04] ��ȣ" >> $RESULT_FILE 2>&1
# 	else	
# 		echo "[U-04] ���" >> $RESULT_FILE 2>&1
# fi

rm -rf UAC.txt
rm -rf total_chk.txt
rm -rf tmp_passwd
rm -rf tmp_user

echo "[U-05] �н����� ���� ��ȣ"
#echo "[U-05] �н����� ���� ��ȣ" >> $RESULT_FILE 2>&1
		
shadow="/etc/shadow"

echo "" > shadow.txt
for check_dir in $shadow
do
	if [ `ls -alL $check_dir | awk '{print $1}' |grep  '........w.' |wc -l` -eq 0 ]
		then
			echo "good" >> shadow.txt
		else
			echo "bad" >> shadow.txt
	fi
done

if [ `cat shadow.txt | grep "bad" | wc -l` -eq 0 ]
	then
		echo "[U-05] ��ȣ" >> $RESULT_FILE 2>&1
	else
		echo "[U-05] ���" >> $RESULT_FILE 2>&1
fi

rm -rf shadow.txt
unset shadow

echo "[U-06] root Ȩ, �н� ���͸� ���� �� �н� ����"
#echo "[U-06] root Ȩ, �н� ���͸� ���� �� �н� ����" >> $RESULT_FILE 2>&1
echo $PATH > path_tmp

if [ `cat path_tmp | grep "\." | grep "\.\." | wc -l` -eq 0 ]
	then
		echo "[U-06] ��ȣ" >> $RESULT_FILE 2>&1
	else
		echo "[U-06] ���" >> $RESULT_FILE 2>&1
fi

rm -rf path_tmp

echo "[U-07] ���� �� ���͸� ������ ����"
#echo "[U-07] ���� �� ���͸� ������ ����" >> $RESULT_FILE 2>&1

find /etc /tmp /bin /sbin -nouser -o -nogroup > noACF.txt

if [ `cat noACF.txt | wc -l` -eq 0 ]
	then
		echo "[U-07] ��ȣ" >> $RESULT_FILE 2>&1
	else
		echo "[U-07] ���" >> $RESULT_FILE 2>&1
fi

rm -rf noACF.txt

echo "[U-08] /etc/passwd ���� ������ �� ���� ����"
#echo "[U-08] /etc/passwd ���� ������ �� ���� ����" >> $RESULT_FILE 2>&1
if [ `ls -alL /etc/passwd | grep "...-.--.--.*[root or bin].*" | wc -l` -eq 1 ]
	then
		echo "[U-08] ��ȣ" >> $RESULT_FILE 2>&1
	else
		echo "[U-08] ���" >> $RESULT_FILE 2>&1
fi


echo "[U-09] /etc/shadow ���� ������ �� ���� ����"
#echo "[U-09] /etc/shadow ���� ������ �� ���� ����" >> $RESULT_FILE 2>&1

if [ `ls -alL /etc/shadow | grep "..--------.*[root or bin].*" | wc -l` -eq 1 ]
	then
		echo "[U-09] ��ȣ" >> $RESULT_FILE 2>&1
	else
		echo "[U-09] ���" >> $RESULT_FILE 2>&1
fi


echo "[U-10] /etc/hosts ���� ������ �� ���� ����"
#echo "[U-10] /etc/hosts ���� ������ �� ���� ����" >> $RESULT_FILE 2>&1

if [ -f /etc/hosts ] 
	then
		if [ `ls -alL /etc/hosts | grep "...-.--.--.*[root or bin].*" | wc -l` -eq 1 ]
			then
				echo "[U-10] ��ȣ" >> $RESULT_FILE 2>&1
			else
				echo "[U-10] ���" >> $RESULT_FILE 2>&1
		fi
	else
		echo "[U-10] ����" >> $RESULT_FILE 2>&1	
fi


echo "[U-11] /etc/(x)inetd.conf ���� ������ �� ���� ����"
#echo "[U-11] /etc/(x)inetd.conf ���� ������ �� ���� ����" >> $RESULT_FILE 2>&1

if [ -f /etc/inetd.conf ]
	then 
		if [ `ls -alL /etc/inetd.conf | grep "...-.--.--.*[root or bin].*" | wc -l` -eq 1 ]
			then
				echo "[U-11] ��ȣ" >> $RESULT_FILE 2>&1
			else
				echo "[U-11] ���" >> $RESULT_FILE 2>&1
		fi
	else
		if [ -f /etc/xinetd.conf ]
			then
				if [ `ls -alL /etc/xinetd.conf | grep "...-.--.--.*[root or bin].*" | wc -l` -eq 1 ]
					then
						echo "[U-11] ��ȣ" >> $RESULT_FILE 2>&1
					else
						echo "[U-11] ���" >> $RESULT_FILE 2>&1
				fi
			else
				echo "[U-11] N/A" >> $RESULT_FILE 2>&1
		fi
			
fi


echo "[U-12] /etc/syslog.conf ���� ������ �� ���� ����"
#echo "[U-12] /etc/syslog.conf ���� ������ �� ���� ����" >> $RESULT_FILE 2>&1

if [ -f /etc/syslog.conf ]
	then 
		if [ `ls -alL /etc/syslog.conf | grep "...-.--.--.*[root or bin].*" | wc -l` -eq 1 ]
			then
				echo "[U-12] ��ȣ" >> $RESULT_FILE 2>&1
			else
				echo "[U-12] ���" >> $RESULT_FILE 2>&1
		fi
	else
		if [ -f /etc/rsyslog.conf ]
			then
				if [ `ls -alL /etc/rsyslog.conf | grep "...-.--.--.*[root or bin].*" | wc -l` -eq 1 ]
					then
						echo "[U-12] ��ȣ" >> $RESULT_FILE 2>&1
					else
						echo "[U-12] ���" >> $RESULT_FILE 2>&1
				fi
			else
				echo "[U-12] ����" >> $RESULT_FILE 2>&1
		fi
fi

echo "[U-13] /etc/services ���� ������ �� ���� ����"
#echo "[U-13] /etc/services ���� ������ �� ���� ����" >> $RESULT_FILE 2>&1
if [ -f /etc/services ] 
	then
		if [ `ls -alL /etc/services | grep "...-.--.--.*[root or bin].*" | wc -l` -eq 1 ]
			then
				echo "[U-13] ��ȣ" >> $RESULT_FILE 2>&1
			else
				echo "[U-13] ���" >> $RESULT_FILE 2>&1
		fi
	else
		echo "[U-13] ����" >> $RESULT_FILE 2>&1
fi


echo "[U-14] SUID, SGID, Sticky bit ���� ���� ����"
#echo "[U-14] SUID, SGID, Sticky bit ���� ���� ����" >> $RESULT_FILE 2>&1
#echo "# find /  -user root -type f \( -perm -04000 -o -perm -02000 \) -xdev -exec ls -al  {}  \;" >> $REF_FILE 2>&1
#find / -user root -type f \( -perm -04000 -o -perm -02000 \) -xdev -exec ls -al  {}  \; >> $REF_FILE 2>&1

FILES="/sbin/dump /usr/bin/lpq-lpd /usr/bin/newgrp /sbin/restore /usr/bin/lpr /usr/sbin/lpc /sbin/unix_chkpwd /usr/bin/lpr-lpd /usr/sbin/lpc-lpd /usr/bin/at /usr/bin/lprm /usr/sbin/traceroute /usr/bin/lpq /usr/bin/lprm-lpd"

for check_file in $FILES
	do
		if [ -f $check_file ]
			then
				if [ `ls -alL $check_file | awk '{print $1}' | grep -i 's'| wc -l` -gt 0 ]
					then
						ls -alL $check_file |awk '{print $1}' | grep -i 's' >> set.txt
					else
						echo "" >> set.txt
				fi
		fi
	done

if [ `cat set.txt | awk '{print $1}' | grep -i 's' | wc -l` -gt 1 ]
	then
           echo "[U-14] ���" >> $RESULT_FILE 2>&1
    else
           echo "[U-14] ��ȣ" >> $RESULT_FILE 2>&1
fi

rm -rf set.txt


# echo "[U-15] �����, �ý��� �������� �� ȯ������ ������ �� ���� ����"
# #echo "[U-15] �����, �ý��� �������� �� ȯ������ ������ �� ���� ����" >> $RESULT_FILE 2>&1

# echo "" > home.txt
# HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | grep -wv "\/" | uniq`

# for dir in $HOMEDIRS
# 	do
# 		if [ -d $dir ]
# 			then
# 				if [ `ls -dalL $dir | awk '{print $1}' | grep "d.......-.." | wc -l` -eq 1 ]
# 					then
# 						echo "[U-15-��. Result] ��ȣ" >> home.txt
# 					else
# 						echo "[U-15-��. Result] ���" >> home.txt
# 				fi
# 			else
# 				echo "[U-15-��. Result] ��ȣ" >> home.txt
# 		fi
# 	done

echo "" > home2.txt
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile .Xdefaults"

for file in $FILES
	do
		if [ -f /$file ]
			then
				if [ `ls -alL /$file |  awk '{print $1}' | grep "........-.." | wc -l` -eq 1 ]
					then
						echo "[U-15-��. Result] ��ȣ" >> home2.txt
					else
						echo "[U-15-��. Result] ���" >> home2.txt
				fi
			else
				echo "[U-15-��. Result] ��ȣ"   >> home2.txt
		fi
	done

for dir in $HOMEDIRS
	do
		for file in $FILES
			do
				if [ -f $dir/$file ]
					then
						if [ `ls -al $dir/$file | awk '{print $1}' | grep "...-.--.--." | wc -l` -eq 1 ]
							then
								echo "[U-15-��. Result] ��ȣ" >> home2.txt
							else
								echo "[U-15-��. Result] ���" >> home2.txt
						fi
					else
						echo "[U-15-��. Result] ��ȣ" >> home2.txt
				fi
			done
	done

# if [ `cat home.txt | grep "���" | wc -l` -eq 0 ]
# 	then
# 		if [ `cat home2.txt | grep "���" | wc -l` -eq 0 ]
# 			then
# 				echo "[U-15] ��ȣ" >> $RESULT_FILE 2>&1
# 			else
# 				echo "[U-15] ���" >> $RESULT_FILE 2>&1
# 		fi
# 	else
# 		echo "[U-15] ���" >> $RESULT_FILE 2>&1
# fi

# rm -rf home.txt
rm -rf home2.txt


echo "[U-16] world writable ���� ����"
#echo "[U-16] world writable ���� ����" >> $RESULT_FILE 2>&1
echo "[U-16] ����" >> $RESULT_FILE 2>&1


echo "[U-17] \$HOME/.rhosts, hosts.equiv ��� ����"
#echo "[U-17] $HOME/.rhosts, hosts.equiv ��� ����" >> $RESULT_FILE 2>&1

SERVICE="rlogin|rsh|rexec"
SERVICE1="login|shell|exec"


if [ `ps -ef | egrep $SERVICE | egrep -v "grep" | wc -l` -eq 0 ]
	then
		#���μ��� ���������� ������ �߰� �ʿ�
		CHK_VALUE=0
	else
		#���μ��� ���� Ȯ��
		CHK_VALUE=1
fi



case $CHK_VALUE in
0)
	if [ `port_chk $SERVICE1 | wc -l` -eq 0 ]
		then
			#rlogin,rsh,rexec ��Ʈ ���� ���� ����
			FINAL_VALUE=0
			R_SVR="false"
		else
			#rlogin,rsh,rexec ��Ʈ ���� ����
			FINAL_VALUE=1
			R_SVR="true"
	fi

;;

1)
	FINAL_VALUE=1
	R_SVR="true"
;;

esac
		
if [ $FINAL_VALUE -eq 1 ]
		then
		HOMEDIRS=`cat $PW_FILE | awk -F":" 'length($6) > 0 {print $6}' | sort -u`
		
	    FILES=".rhosts"
	    TMP=0
	    TMP_1=0
		CHK_AUT=0

	    for dir in $HOMEDIRS
		    do
			for file in $FILES
			do
			    if [ -f $dir/$file ]
					then
						FILE_LIST="$FILE_LIST$dir/$file "
						HOST_CHECK="$dir/$file\n"`cat $dir/$file`
						HOST_CHECK_LIST="$HOST_CHECK_LIST$HOST_CHECK\n\n"
				    
						ANY_HOST=`echo "$HOST_CHECK" | egrep "\+"`
						
						ls -al $FILE_LIST >> CHK_AUTH.txt
						
						if [ `ls -al $FILE_LIST | grep "...-------." | wc -l` -eq 0 ]
							then
								((CHK_AUT++))		
						fi
												
				    if [ "$ANY_HOST" != "" ]
					then
					    ANY_HOST_CHECK="$ANY_HOST_CHECK\n$dir/$file\n$ANY_HOST\n"
				    fi

				    TMP=`expr $TMP + 1`
			    fi
			done
		    done
fi			
			

if [ "$R_SVR" = "true" ]
	then
		if [ $TMP -eq 0 ] && [ $TMP_1 -eq 0 ] && [ $CHK_AUT -eq 0 ]
			then
				echo "[U-17] ��ȣ" >> $RESULT_FILE 2>&1
			else
				if [ "$ANY_HOST_CHECK" != "" ]
					then
						echo "[U-17] ���" >> $RESULT_FILE 2>&1
					else									
						if [ $CHK_AUT -gt 0 ]
							then
								echo "[U-17] ���" >> $RESULT_FILE 2>&1								
							else
								echo "[U-17] ��ȣ" >> $RESULT_FILE 2>&1
						fi
				fi
		fi
	else
		echo "[U-17] N/A" >> $RESULT_FILE 2>&1
fi

unset SERVICE
unset CHK_VALUE
unset HOMEDIRS
unset FILES
unset TMP
unset TMP_1

rm -rf CHK_AUTH.txt


echo "[U-18] ���� IP �� ��Ʈ ����"
#echo "[U-18] ���� IP �� ��Ʈ ����" >> $RESULT_FILE 2>&1

echo "[U-18] ����" >> $RESULT_FILE 2>&1


echo "[U-19] cron ���� ������ �� ���� ����"
#echo "[U-19] cron ���� ������ �� ���� ����" >> $RESULT_FILE 2>&1

if [ -f /etc/cron.allow ] 
	then
		if [ `ls -alL /etc/cron.allow | grep "...-.-----.*[root or bin].*" | wc -l` -eq 1 ]
			then
				#��ȣ
				CRON_A=1
			else
				#���
				CRON_A=0
		fi
	else
		#�ش���� ����
		CRON_A=2
fi

if [ -f /etc/cron.deny ] 
	then
		if [ `ls -alL /etc/cron.deny | grep "...-.-----.*[root or bin].*" | wc -l` -eq 1 ]
			then
				#��ȣ
				CRON_D=1
			else
				#���
				CRON_D=0
		fi
	else
		#�ش���� ����
		CRON_D=2
fi
		
if [ $CRON_A -eq 2 -a $CRON_D -eq 2 ]
	then
		echo "[U-19] N/A" >> $RESULT_FILE 2>&1
	elif [ $CRON_A -eq 1 -a $CRON_D -eq 1 ]
		then
			echo "[U-19] ��ȣ" >> $RESULT_FILE 2>&1
	elif [ $CRON_A -eq 2 -a $CRON_D -eq 1 ]
		then
			echo "[U-19] ��ȣ" >> $RESULT_FILE 2>&1
	elif [ $CRON_A -eq 1 -a $CRON_D -eq 2 ]
		then
			echo "[U-19] ��ȣ" >> $RESULT_FILE 2>&1
	else
		echo "[U-19] ���" >> $RESULT_FILE 2>&1
fi

unset CRON_A
unset CRON_D


echo "[U-20] finger ���� ��Ȱ��ȭ"
#echo "[U-20] finger ���� ��Ȱ��ȭ" >> $RESULT_FILE 2>&1

SERVICE="finger"

if [ `ps -ef | egrep $SERVICE | egrep -v "grep" | wc -l` -eq 0 ]
	then
		#���μ��� ���������� ������ �߰� �ʿ�
		CHK_VALUE=0
	else
		#���μ��� ���� Ȯ��
		CHK_VALUE=1
fi



case $CHK_VALUE in
0)
	if [ `port_chk $SERVICE | wc -l` -eq 0 ]
		then
			FINAL_VALUE=0
		else
			FINAL_VALUE=1
	fi

;;

1)
	FINAL_VALUE=1
;;

esac

if [ $FINAL_VALUE -eq 1 ]
	then
		if [ -d /etc/xinetd.d ]
			then
				echo "[U-20] ���" >> $RESULT_FILE 2>&1
		fi
	else
		echo "[U-20] ��ȣ" >> $RESULT_FILE 2>&1
fi

unset SERVICE
unset FINAL_VALUE
unset CHK_VALUE


echo "[U-21] Anonymous FTP ��Ȱ��ȭ"
#echo "[U-21] Anonymous FTP ��Ȱ��ȭ" >> $RESULT_FILE 2>&1

SERVICE="ftp"

if [ `ps -ef | egrep $SERVICE | egrep -v "grep" | wc -l` -eq 0 ]
	then
		#���μ��� ���������� ������ �߰� �ʿ�
		CHK_VALUE=0
	else
		#���μ��� ���� Ȯ��
		CHK_VALUE=1
fi


case $CHK_VALUE in
0)
	if [ `port_chk $SERVICE | grep -v "tftp" | wc -l` -eq 0 ]
		then
			FINAL_VALUE=0
		else
			FINAL_VALUE=1
	fi

;;

1)
	FINAL_VALUE=1
;;
esac

if [ $FINAL_VALUE -eq 0 ]
	then
		echo "[U-21] N/A" >> $RESULT_FILE 2>&1
	else
		echo "[U-21] ����" >> $RESULT_FILE 2>&1
fi

unset SERVICE
unset FINAL_VALUE
unset CHK_VALUE


echo "[U-22] r�迭 ���� ��Ȱ��ȭ"
#echo "[U-22] r�迭 ���� ��Ȱ��ȭ" >> $RESULT_FILE 2>&1

dir="/etc/xinetd.d"
SERVICE="rsh|rlogin|rexec"
SERVICE1="shell|login|exec"

if [ `ps -ef | egrep $SERVICE | egrep -v "grep" | wc -l` -eq 0 ]
	then
		#���μ��� ���������� ������ �߰� �ʿ�
		CHK_VALUE=0
	else
		#���μ��� ���� Ȯ��
		CHK_VALUE=1
fi



case $CHK_VALUE in
0)
	if [ `port_chk $SERVICE1 | wc -l` -eq 0 ]
		then
			FINAL_VALUE=0
		else
			FINAL_VALUE=1
	fi

;;

1)
	FINAL_VALUE=1
;;
esac



if [ $FINAL_VALUE -eq 1 ]
	then
		echo "[U-22] ���" >> $RESULT_FILE 2>&1
	else
		echo "[U-22] ��ȣ" >> $RESULT_FILE 2>&1
fi


unset SERVICE
unset FINAL_VALUE
unset CHK_VALUE
unset dir


echo "[U-23] DoS ���ݿ� ����� ���� ��Ȱ��ȭ"
#echo "[U-23] DoS ���ݿ� ����� ���� ��Ȱ��ȭ" >> $RESULT_FILE 2>&1

dir="/etc/xinetd.d"
SERVICE="echo|discard|daytime|chargen"


if [ `ps -ef | egrep $SERVICE | egrep -v "grep" | wc -l` -eq 0 ]
	then
		#���μ��� ���������� ������ �߰� �ʿ�
		CHK_VALUE=0
	else
		#���μ��� ���� Ȯ��
		CHK_VALUE=1
fi

case $CHK_VALUE in
0)
	if [ `port_chk $SERVICE | wc -l` -eq 0 ]
		then
			FINAL_VALUE=0
		else
			FINAL_VALUE=1
	fi

;;

1)
	FINAL_VALUE=1
;;
esac
		
if [ $FINAL_VALUE -eq 1 ]
	then
		echo "[U-23] ���" >> $RESULT_FILE 2>&1
	else
		echo "[U-23] ��ȣ" >> $RESULT_FILE 2>&1
fi

unset SERVICE
unset FINAL_VALUE
unset CHK_VALUE
unset dir


echo "[U-24] NFS ���� ��Ȱ��ȭ"
#echo "[U-24] NFS ���� ��Ȱ��ȭ" >> $RESULT_FILE 2>&1

SERVICE="mountd|nfs"

if [ `ps -ef | egrep $SERVICE | grep -v "radiusconfsvr" | egrep -v "grep" | wc -l` -eq 0 ]
	then
		#���μ��� ���� ����
		CHK_VALUE=0
	else
		#���μ��� ���� ��
		CHK_VALUE=1
fi

if [ $CHK_VALUE -eq 1 ]
	then
		echo "[U-24] ���" >> $RESULT_FILE 2>&1
		NFS_SVR="true"
	else
		echo "[U-24] ��ȣ" >> $RESULT_FILE 2>&1
fi

unset SERVICE
unset CHK_VALUE


echo "[U-25] NFS ���� ����"
#echo "[U-25] NFS ���� ����" >> $RESULT_FILE 2>&1

if [ `ps -ef | egrep "nfsd" | egrep -v "grep|statdaemon|automountd" | grep -v "grep" | wc -l` -eq 0 ]
	then
		echo "[U-25] ��ȣ" >> $RESULT_FILE 2>&1
	else
		if [ -f /etc/exports ]
			then
				if [ `cat /etc/exports | grep -v "#" | grep "/" | wc -l` -eq 0 ]
					then
						echo "[U-25] N/A" >> $RESULT_FILE 2>&1
					else
						echo "[U-25] ����" >> $RESULT_FILE 2>&1
				fi
			else
				echo "[U-25] ��ȣ"  >> $RESULT_FILE 2>&1
		fi
fi


echo "[U-26] automountd ����"
#echo "[U-26] automountd ����" >> $RESULT_FILE 2>&1

if [ `ps -ef | grep automountd | egrep -v "grep|rpc|statdaemon|emi" | wc -l` -eq 0 ]
	then
		echo "[U-26] ��ȣ" >> $RESULT_FILE 2>&1
	else
	  	echo "[U-26] ���" >> $RESULT_FILE 2>&1		
fi


echo "[U-27] RPC ���� Ȯ��"
#echo "[U-27] RPC ���� Ȯ��" >> $RESULT_FILE 2>&1

SERVICE="rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd|rexd"

if [ `ps -ef | egrep $SERVICE | egrep -v "grep" | wc -l` -eq 0 ]
	then
		#���μ��� ���� ����
		CHK_VALUE=0
	else
		#���μ��� ���� ��
		CHK_VALUE=1
fi

if [ $CHK_VALUE -eq 1 ]
	then
		echo "[U-27] ���" >> $RESULT_FILE 2>&1
	else
		echo "[U-27] ��ȣ" >> $RESULT_FILE 2>&1
fi

unset SERVICE


echo "[U-28] NIS, NIS+ ����"
#echo "[U-28] NIS, NIS+ ����" >> $RESULT_FILE 2>&1

SERVICE="ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated|rpc.nisd"

if [ `ps -ef | egrep $SERVICE | egrep -v "grep" | wc -l` -eq 0 ]
	then
		#���μ��� ���� ����
		CHK_VALUE=0
	else
		#���μ��� ���� ��
		CHK_VALUE=1
fi

if [ $CHK_VALUE -eq 1 ]
	then
		echo "[U-28] ���" >> $RESULT_FILE 2>&1
	else
		echo "[U-28] ��ȣ" >> $RESULT_FILE 2>&1
fi


unset SERVICE
unset CHK_VALUE


echo "[U-29] tftp, talk ���� ��Ȱ��ȭ"
#echo "[U-29] tftp, talk ���� ��Ȱ��ȭ" >> $RESULT_FILE 2>&1

SERVICE="tftp|talk|ntalk"
dir="/etc/xinetd.d"

if [ `ps -ef | egrep $SERVICE | egrep -v "grep" | wc -l` -eq 0 ]
	then
		#���μ��� ���������� ������ �߰� �ʿ�
		CHK_VALUE=0
	else
		#���μ��� ���� Ȯ��
		CHK_VALUE=1
fi



case $CHK_VALUE in
0)
	if [ `port_chk $SERVICE | wc -l` -eq 0 ]
		then
			FINAL_VALUE=0
		else
			FINAL_VALUE=1
	fi

;;

1)
	FINAL_VALUE=1
;;
esac

if [ $FINAL_VALUE -eq 1 ]
	then
		echo "[U-29] ���" >> $RESULT_FILE 2>&1
	else
		echo "[U-29] ��ȣ" >> $RESULT_FILE 2>&1
fi

unset SERVICE
unset FINAL_VALUE
unset dir
unset CHK_VALUE

echo "[U-30] Sendmail ���� ����"
#echo "[U-30] Sendmail ���� ����" >> $RESULT_FILE 2>&1

if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
	 then
	 	touch sendmail_tmp
fi

if [ -f sendmail_tmp ]
	then
		echo ""
	else
	if [ -f /etc/mail/sendmail.cf ]
		then
			grep -v '^ *#' /etc/mail/sendmail.cf | grep DZ >> send.txt
		else
			echo "/etc/mail/sendmail.cf ���� ����" >> send.txt
	fi
fi

if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
	 then
	 	echo "[U-30] ��ȣ" >> $RESULT_FILE 2>&1
	 else
	 	echo "[Result] ���� : `cat send.txt`" >> $RESULT_FILE 2>&1
fi


rm -rf send.txt


echo "[U-31] ���� ���� ������ ����"
#echo "[U-31] ���� ���� ������ ����" >> $RESULT_FILE 2>&1

if [ -f sendmail_tmp ]
	then
		echo "[U-31] N/A" >> $RESULT_FILE 2>&1
	else
	if [ -f /etc/mail/access ]
		then
			echo "[U-31] ����" >> $RESULT_FILE 2>&1
		else
			echo "[U-31] ���" >> $RESULT_FILE 2>&1
	fi
fi


echo "[U-32] �Ϲ� ������� Sendmail ���� ����"
#echo "[U-32] �Ϲ� ������� Sendmail ���� ����" >> $RESULT_FILE 2>&1

if [ -f sendmail_tmp ]
	then
		echo "[U-32] N/A" >> $RESULT_FILE 2>&1
		else
			if [ -f /etc/mail/sendmail.cf ]
				then
					if [ `cat /etc/mail/sendmail.cf | grep -v "^ *#" | egrep -i "restrictqrun" | grep -v "grep" | wc -l ` -eq 1 ]
						then
							echo "[U-32] ��ȣ" >> $RESULT_FILE 2>&1
						else
							echo "[U-32] ���" >> $RESULT_FILE 2>&1	
					fi
				else
					echo "[U-32] ���" >> $RESULT_FILE 2>&1
			fi
fi

rm -rf sendmail_tmp


echo "[U-33] DNS ���� ���� ��ġ"
#echo "[U-33] DNS ���� ���� ��ġ" >> $RESULT_FILE 2>&1

if [ `ps -ef | grep named | grep -v "grep" | wc -l` -eq 0 ]
	then
	   	echo "[U-33] N/A" >> $RESULT_FILE 2>&1
	else
	   	echo "[U-33] ���� : `/usr/sbin/named -v`" >> $RESULT_FILE 2>&1
fi


echo "[U-34] DNS ZoneTransfer ����"
#echo "[U-34] DNS ZoneTransfer ����" >> $RESULT_FILE 2>&1

if [ `ps -ef | grep named | grep -v "grep" | wc -l` -eq 0 ]
	then
	   	echo "[U-34] N/A" >> $RESULT_FILE 2>&1
	else
	if [ -f /etc/named.conf ]
	    then
			if [ `cat /etc/named.conf | grep "\allow-transfer.*[0-256].[0-256].[0-256].[0-256].*" | grep -v "^ *#" | wc -l` -eq 0 ]
				then
					echo "[U-34] ���" >> $RESULT_FILE 2>&1
				else
					echo "[U-34] ��ȣ" >> $RESULT_FILE 2>&1
			fi
		else
		if [ -f /etc/named.boot ]
			then
				if [ `cat /etc/named.boot | grep "\xfrnets.*[0-256].[0-256].[0-256].[0-256].*" | grep -v "^ *#" | wc -l` -eq 0 ]
					then
						echo "[U-34] ���" >> $RESULT_FILE 2>&1
					else
						echo "[U-34] ��ȣ" >> $RESULT_FILE 2>&1
				fi
			else
		       	echo "[U-34] ���" >> $RESULT_FILE 2>&1
		fi

	fi
fi


echo "[U-35] �ֽ� ������ġ �� ���� �ǰ���� ����"
#echo "[U-35] �ֽ� ������ġ �� ���� �ǰ���� ����" >> $RESULT_FILE 2>&1

if [ -f /etc/debian_version ]
	then
		if [ `cat /etc/*release | grep -i "ubuntu" | wc -l` -eq 0 ]
			then
				echo "[U-35] ���� : Debian `cat /etc/debian_version`" >> $RESULT_FILE 2>&1
			else
				echo "[U-35] ���� : `cat /etc/*release | grep -i 'DISTRIB_DESCRIPTION' | awk -F= '{print $2}' | sed 's/\"//g'`" >> $RESULT_FILE 2>&1
		fi		
	else
		echo "[U-35] ���� : `cat /etc/system-release`" >> $RESULT_FILE 2>&1
fi


echo "[U-36] �α��� ������ ���� �� ����"
#echo "[U-36] �α��� ������ ���� �� ����" >> $RESULT_FILE 2>&1
echo "[U-36] ����" >> $RESULT_FILE 2>&1

echo "End" >> $RESULT_FILE 2>&1
echo "[End]"
