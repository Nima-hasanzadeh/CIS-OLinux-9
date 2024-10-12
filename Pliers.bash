#!/bin/bash

#Program: Pliers v1.0
#Author: Nima.H 
#OS Support : Oracle Linux 9 (It may be compatible with most Red Hat distributions)
#I'm going to provide a starting point for  Linux admins to build a secure server which meets the CIS standards.
#For more information please check : github.com/Nima-Hasanzadeh


clear

#check user
if [ "$EUID" -ne 0 ]
  then 
echo -e "\n\n\e[47m\e[34mDear "$USER",Please run this script as a root user\e[0m\n"
  kill $$
fi




echo -e "\e[91m"
cat <<EOF




 ███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗    ████████╗███████╗ █████╗ ███╗N.H███╗
 ██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
 ███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝        ██║   █████╗  ███████║██╔████╔██║
 ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝         ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║
 ███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║          ██║   ███████╗██║  ██║██║ ╚═╝ ██║
 ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝          ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
 Pliers 1.0
 Hardening Oracle Linux 9.0
 github.com/Nima-Hasanzadeh

EOF
echo -e "\e[49m"
. /etc/os-release
echo -e "You are running \e[47m\e[34m${PRETTY_NAME}\e[0m\n"
read -p "Press Enter to continue . . ."


echo -e "Date&Time : $(date +"%d-%m-%y %H:%M")"
echo -e "Your OS version  : ${PRETTY_NAME}\n"

 if echo ${PRETTY_NAME} | cut -f1 -d'.' | grep -q "Oracle Linux Server 9"; then
  echo
    else
   echo -e "Your OS release is not supported! You are running \e[47m\e[31m${PRETTY_NAME}\e[0m ,Are you sure you want to proceed?"
  read -p "Do you want to continue? (y/n): " response
    if [ "$response" = "y" ]; then
     echo "Continuing..."
      elif [ "$response" = "n" ]; then
      echo "Exiting the script."
	   kill $$
      else
     echo "Invalid input. Please enter 'y' to continue or 'n' to exit."
	kill $$
   fi
 fi


# Read confirmation from user
Current_Date="$(date '+%Y-%m-%d')"
LOGFILE=hrdlog_$(date '+%Y%m%d.%H')

#confirm firewall setting
if systemctl is-enabled firewalld | grep -q "enabled";then firewalld1="true";else firewalld1="false";fi
 if systemctl is-active firewalld | grep -q "\bactive\b";then firewalld2="true";else firewalld1="false";fi
  if [ "$firewalld1" = true ] && [ "$firewalld2" = true ];then
   echo 
   else
  echo -e "\e[43m\e[30mThe firewall will be enabled. Are you in agreement with that? [ y or n ] \e[0m "
 read firewall_confirm
fi

# confirm authentication profile edit
echo -e "\e[43m\e[30m Authentication profile and pam configuration will be reset, Are you in agreement with that? [ y or n ] \e[0m "
read auth_confirm

# Confirm system date
echo -e "\e[43m\e[30m Ensure that the date and time are correct, is (${Current_Date}) has a correct value? [ y or n ] \e[0m "
read date_confirm

echo "User answer for date confirmation with tha value of (${Current_Date}) is ${date_confirm} " >> ./$LOGFILE

    if [ "$date_confirm" = "y" ]; then
     echo "Date confirmed. Continue hardening process . . ."  
      elif [ "$date_confirm" = "n" ]; then
       echo "You did'nt confirm the date value, the process will be terminated."  
        kill $$
      else
     echo "Invalid input entered for date confirmation. Please enter 'y' or 'n'."  
    kill $$
   fi   




# Configuration files
LOGFILE=hrdlog_$(date '+%Y%m%d.%H')
LOGDIR="./$(hostname -s)_logs"
TIME="$(date +%F_%T)"
MAIN_LOG=MainLog_$(date '+%Y%m%d.%H')
BACKUP_DIR="$LOGDIR/backup"
MANUAL_FIX="$LOGDIR/read_manual_fix.txt"
AIDE_CONF='/etc/aide.conf'
AUDITD_CNF='/etc/audit/auditd.conf'
SYSCTL_CONF='/etc/sysctl.d/60-netipv4_sysctl.conf'
SYSCTL_CONFv6='/etc/sysctl.d/60-netipv6_sysctl.conf'
GRUB_CFG='/boot/grub2/grub.cfg'
GRUB_CFG2='/boot/grub2/user.cfg'
GRUB_ENV='boot/grub2/grubenv'
SELINUX_CFG='/etc/selinux/config'
DUMP_DIR='/etc/systemd/coredump.conf'
NETWORK_V6='/etc/sysconfig/network'
AUDIT_TOOLS='/sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules'
AUDIT_DIR='/etc/audit/'
JOURNAL_CONF='/etc/systemd/journald.conf'
RSYS_CONF='/etc/rsyslog.conf'
CRONTAB='/etc/crontab'
CRON_HOURLY='/etc/cron.hourly'
CRON_DAILY='/etc/cron.daily'
CRON_WEEKLY='/etc/cron.weekly'
CRON_MONTHLY='/etc/cron.monthly'
CRON_DIR='/etc/cron.d'
AT_ALLOW='/etc/at.allow'
AT_DENY='/etc/at.deny'
CRON_ALLOW='/etc/cron.allow'
CRON_DENY='/etc/cron.deny'
SSHD_CFG='/etc/ssh/sshd_config'
SSHD_ALL='/etc/ssh/sshd_config.d/*.conf'
SUDO_CONF='/etc/sudoers'
SUDOERS='/etc/sudoers* /etc/sudoers.d/*'
PAM_SU='/etc/pam.d/su'
PWQUAL_CNF='/etc/security/pwquality.conf'
SYSTEM_AUTH='/etc/authselect/system-auth'
PASS_AUTH='/etc/authselect/password-auth'
LIB_USR='/etc/libuser.conf'
LOGIN_DEFS='/etc/login.defs'
PASSWD='/etc/passwd'
PASSWD2='/etc/passwd-'
SHADOW='/etc/shadow'
SHADOW2='/etc/shadow-'
GSHADOW='/etc/gshadow'
GSHADOW2='/etc/gshadow-'
GROUP='/etc/group'
GROUP2='/etc/group-'
FAIL_CONF='/etc/security/faillock.conf'
PROFILE_D='/etc/profile.d/*'
PROFILE_BASH='/etc/profile.d/bash_completion.sh'
TOTAL=0
PASS=0
FAILED=0
PROFILE_FILE='/etc/profile'
BASHRC='/etc/bashrc'

. /etc/os-release
echo "Version   : 1.0"
echo -e "Date&Time : $(date +"%d-%m-%y %H:%M")"
echo -e "Your OS version  : ${PRETTY_NAME}\n"

 if echo ${PRETTY_NAME} | cut -f1 -d'.' | grep -q "Oracle Linux Server 9"; then
  echo
    else
   echo -e "Your OS release is not supported! You are running \e[47m\e[31m${PRETTY_NAME}\e[0m ,Are you sure you want to proceed?"
  read -p "Are you sure you want to continue? "
 fi


function echo_audit {
#  echo  -e "-----------------------------------------------------------" >> ./$LOGFILE
  echo_mag "Audit OK         $func_name  $args" >> ./$LOGFILE
}

function results {

create_bar() {
    local value=$1
    for ((i=1; i<=$value; i++)); do
        printf "#"
    done
    printf "\n"
}

# Display the bar chart
echo_bold "\nThe results are shown as below :"
echo_red "--------------------------------------------------------------------------------------------"
echo_bold    "Total Checks : $TOTAL $(create_bar $(($TOTAL / 10)))"
echo_green   "Applied Items : $PASS $(create_bar $(($PASS / 10)))"
echo_red     "NOT  Applied  : $FAILED  $(create_bar $((($FAILED+9) / 10)))"
echo_yellow  "NOT  Applied Percentage : $(expr $FAILED \* 100 / $TOTAL)%"

}



function echo_yellow {
  echo -e "\e[93m${@} \e[0m"
}

function echo_bold {
  echo -e "\e[1m${@} \e[0m"
}

function echo_mag {
  echo -e "\e[95m${@} \e[0m"
}

function echo_red {
  echo -e "\e[91m${@} \e[0m"
}

function echo_green {
  echo -e "\e[92m${@} \e[0m"
}

mkdir -p $LOGDIR/backup 
touch $MANUAL_FIX;echo_green "This file contains items that must be checked and fixed manually.
Please check and fix the requested items based on the data below." > $MANUAL_FIX
echo_red "-----------------------------------------------------------" >> $MANUAL_FIX

function backup {
   local file_address="${1}"
   local file_name=$(basename "$file_address")
   cp ${file_address} $BACKUP_DIR/${file_name}_$TIME.bak
 }

function disable_fs {

 modprobe -r squashfs
 modprobe -r udf
 modprobe -r tipc
 rmmod usb-storage

  printf "
  install squashfs /bin/false blacklist squashfs
  install udf /bin/false blacklist udf
  install usb-storage /bin/false
  install tipc /bin/false blacklist tipc


  " > /etc/modprobe.d/unload.conf || return

}

function gpg_check {

  sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' /etc/dnf/dnf.conf
  find /etc/yum.repos.d/ -name "*.repo" -exec echo "Checking:" {} \; -exec sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' {} \;
  grep -F  "repo_gpgcheck=" /etc/dnf/dnf.conf || echo 'repo_gpgcheck=1' >> /etc/dnf/dnf.conf
  sed -i 's/^repo_gpgcheck\s*=\s*.*/repo_gpgcheck=1/' /etc/dnf/dnf.conf
}


function aide {

  dnf install aide -y >> $LOGDIR/service_install_$TIME.log

   ##Initialize 
#aide --init 
#mv /etc/aide.db.new  /etc/aide.db
#aide --check
#mkdir -f /etc/aide-archive
echo

}


function aide_conf {
  #set directories to exclude from aide check
  echo "#Exclusion" > /etc/aide.conf
  sed -i '/\#Exclusion/a !/var/log'  /etc/aide.conf
  sed -i '/\#Exclusion/a !/home/'    /etc/aide.conf
  sed -i '/\#Exclusion/a !/tmp'     /etc/aide.conf

# add cryptographic mechanisms to protect the integrity of the audit tools
printf " 
# Audit Tools
/sbin/auditctl p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/auditd p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/ausearch p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/aureport p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/autrace p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/augenrules p+i+n+u+g+s+b+acl+xattrs+sha512
" >> /etc/aide.conf
}


function aide_cron {

local output1="$(crontab -u root -l | cut -d\# -f1 | grep  "aide \+--check")"

 if test -z "$output1" ; then
   sh -c "(crontab -l 2>/dev/null; echo '0 1 * * 5  cp /etc/aide.db  /etc/aide-archive/aide.db_$(date +"%F")') | crontab -"
    sh -c "(crontab -l 2>/dev/null; echo '0 2 * * 5 /usr/sbin/aide --check') | crontab -"
     else
    echo_audit
  return 1
 fi
}

function grub_perm {
# grub.cfg won't exist on an EFI system
 if [ -f /boot/grub2/grub.cfg ]; then
    [ -f /boot/grub2/grub.cfg ] && chown root:root /boot/grub2/grub.cfg
    [ -f /boot/grub2/grub.cfg ] && chmod og-rwx /boot/grub2/grub.cfg
    [ -f /boot/grub2/grubenv ]  && chown root:root /boot/grub2/grubenv
    [ -f /boot/grub2/grubenv ]  && chmod og-rwx /boot/grub2/grubenv
 #[ -f /boot/grub2/user.cfg ] && chown root:root /boot/grub2/user.cfg
 #[ -f /boot/grub2/user.cfg ] && chmod og-rwx /boot/grub2/user.cfg
   else return 1
 fi
}


function set_aslr {
 grep -qi '^\s*#*kernel.randomize_va_space\s=\s2\b' /etc/sysctl.d/60-kernel_sysctl.conf || echo -e "kernel.randomize_va_space = 2 " >> /etc/sysctl.d/60-kernel_sysctl.conf || return
 sysctl -w kernel.randomize_va_space=2

}


function apply_sysctl {
  local flag="$1"
  local value="$2"

  sysctl -w "${flag}"  || return
}     



function core_dump_conf {
 sed -i '/^Storage/ c Storage=none' ${DUMP_DIR}  ; sed -i '/^#Storage/ c Storage=none' ${DUMP_DIR} || return
 sed -i '/^ProcessSizeMax/ c ProcessSizeMax=0' ${DUMP_DIR}  ; sed -i '/^#ProcessSizeMax/ c ProcessSizeMax=0' ${DUMP_DIR}  || return
  ##/run/sysctl.d/*.conf /etc/sysctl.d/*.conf /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf
}

function selinux {
 grubby --update-kernel ALL --remove-args "selinux=0 enforcing=0"
 ##change any value to permissive mode
 sed -i '/^SELINUX=/ c SELINUX=permissive' ${SELINUX_CFG} ; sed -i '/^#SELINUX=/ c SELINUX=permissive' ${SELINUX_CFG} 
}

function remove_package {
#remove packages
local app1="${1}"
dnf remove ${app1} -y >> $LOGDIR/service_uninstalled_$TIME.log 
}

function install_package {
 #install packages
local app2="${1}"
dnf install ${app2} -y >> $LOGDIR/service_installed_$TIME.log 
}

function disable_service {
  services=(nginx httpd httpd.socket avahi-daemon named postfix xinetd
  snmpd telnet-server telnet.socket tftp tftp.socket squid nfs-server
  dnsmasq smb cyrus-imapd dovecot ypserv cups.socket rpcbind.socket rsync-daemon 
  dhcp-server cups rpcbind rsync-daemon rsyncd.socket )
  for i in ${services[@]}; do
    [ $(systemctl disable $i 2> /dev/null) ] || echo "$i is Disabled"
    [ $(systemctl stop $i 2> /dev/null) ] || echo "$i is Stopped"
	[ $(systemctl mask $i 2> /dev/null) ] || echo "$i is Masked"
echo "$i is Disabled" >> ./$LOGFILE
  done
}

function ssh_banner {

echo -e '
*******************************************************************
* Authorized uses only. All activities on this system are logged. *
*   Disconnect IMMEDIATELY if you are not an authorized user!     *
*******************************************************************
' > /etc/issue.net
}

function login_banner {
local file="${1}"
echo -e  '\e[1;31m

#################################################################
#                   _    _           _   _                      #
#                  / \  | | ___ ____| |_| |                     #
#                 / _ \ | |/ _ \  __| __| |                     #
#                / ___ \| |  __/ |  | |_|_|                     #
#               /_/   \_\_|\___|_|   \__(_)                     #
#                                                               #
#   This service is restricted to authorized users only. All    #
#            activities on this system are logged.              #
#  Unauthorized access will be fully investigated and reported  #
#        to the appropriate law enforcement agencies.           #
#                                                               #
#################################################################


\e[0m' > "${file}"
}


function banners_perm {

chown root:root /etc/motd 
chmod u-x,go-wx /etc/motd

chown root:root /etc/issue 
chmod u-x,go-wx /etc/issue

chown root:root /etc/issue.net
chmod u-x,go-wx /etc/issue.net
}

function crypto_policy {

  update-crypto-policies --set DEFAULT
  update-crypto-policies
}

function disable_ipv6 {

 for i in "NETWORKING_IPV6=no" "IPV6INIT=no"; do
  egrep -q "^$i" /etc/sysconfig/network || echo "$i" >> /etc/sysconfig/network
 done

 [ -f /etc/sysctl.d/60-disable_ipv6.conf ] && egrep -q 'net.ipv6.conf.all.disable_ipv6\s*=\s*1\b' /etc/sysctl.d/60-disable_ipv6.conf || printf " 
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1 
" >> /etc/sysctl.d/60-disable_ipv6.conf

 grubby --args ipv6.disable=1 --update-kernel DEFAULT
 #set the active kernel parameters:
 sysctl -w net.ipv6.conf.all.disable_ipv6=1 
 sysctl -w net.ipv6.conf.default.disable_ipv6=1 
 sysctl -w net.ipv6.route.flush=1
}

function wlan {
 nmcli radio all off
 }

function network_conf {
 #config Network Parameters for ipv4
 local arg="${1}"
 local value="${2}"
 
 if grep -q "^\s*$arg" $SYSCTL_CONF  ; then
  sed -i "/^${arg}*=*/ c ${arg}${value}" $SYSCTL_CONF
   else
  echo $arg$value  >> ${SYSCTL_CONF}
 fi
}

function network_confv6 {
 #config Network Parameters for ipv6
 local arg="${1}"
 local value="${2}"
 
 if grep -q "^\s*$arg" $SYSCTL_CONFv6  ; then
  sed -i "/^${arg}\s*=*/ c ${arg}${value}" $SYSCTL_CONFv6
   else
  echo $arg$value  >> ${SYSCTL_CONFv6}
 fi
}

function network_conf_sysctl {
 # config security network setting through systemctl
 local flag="${1}"
 sysctl -w ${flag}
 sysctl -w net.ipv4.route.flush=1
}

function network_conf_sysctlv6 {
# config security network setting through systemctl
local flag="${1}"
sysctl -w ${flag} 
sysctl -w net.ipv6.route.flush=1
echo "if you got Error, it means that IPV6 is disabled"
}

function firewalld_conf {
   if [ "$firewall_confirm" = "y" ]; then
      echo "firewall change agreed. setting firewall..."  >> ./$LOGFILE
       service firewalld start
        systemctl enable firewalld
         firewall-cmd --set-default-zone=public
          firewall-cmd --remove-service=cockpit
           firewall-cmd --remove-service=dhcpv6-client
            firewall-cmd --runtime-to-permanent
           firewall-cmd --lockdown-on
          service firewalld restart       
         elif [ "$firewall_confirm" = "n" ]; then
       echo "firewall change not agreed. Exiting without apply settings." >> ./$LOGFILE
      else
     echo "Invalid input got for firewall change agreement. Please enter 'y' or 'n'."  >> ./$LOGFILE
   fi
}

function audit_conf {
 systemctl --now enable auditd
 grubby --update-kernel ALL --args 'audit=1'
 grubby --update-kernel ALL --args 'audit_backlog_limit=8192'
}
   
function audit_actions {
 #Check if auditd.conf is configured to appropriate values. 
 local arg="$1"
 local action="$2"
 sed -i "/^${arg}*=*/ c ${arg}${action}" $AUDITD_CNF
 service auditd restart

}


  #Extract the log file path from the auditd.conf
  log_file_path=$(awk -F "=" '/^\s*log_file/ {print $2}' /etc/audit/auditd.conf | xargs)
  # Get the directory path of the log file
  directory_log=$(dirname "$log_file_path")
    
function audit_log_perm {
 #owner is defined on  auditd.conig at  "log_group" value.

 #check log files are mode 0640 or less permissive. Find files in the directory and its subdirectories based on permission criteria
 find "$directory_log" -type f \( ! -perm 600 -a ! -perm 0400 -a ! -perm 0200 -a ! -perm 0000 -a ! -perm 0640 -a ! -perm 0440 -a ! -perm 0040 \) \
 -exec chmod u-x,g-wx,o-rwx {} +
 
 #check owner
 find "$directory_log" -type f ! -user root -exec chown root {} +
 find "$directory_log" -type f ! -group root -exec chgrp root {} +
 
 #check the audit log directory is 0750 or more restrictive 
 chmod g-w,o-rwx "$directory_log"
}

function audit_conf_perm {
 find ${AUDIT_DIR} -type f \( -name '*.conf' -o -name '*.rules' \) -exec chmod u-x,g-wx,o-rwx {} +
 find ${AUDIT_DIR} -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root -exec chown root {} +
 find ${AUDIT_DIR} -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root -exec chgrp root {} +
}

function audit_tools_perm {
 chmod go-w ${AUDIT_TOOLS}
 chown root ${AUDIT_TOOLS}
 chown root:root ${AUDIT_TOOLS}
}

function rsyslog_conf {
 systemctl --now enable rsyslog
 if grep -q '^\s*$FileCreateMode' ${RSYS_CONF} ; then
  sed -i '/$FileCreateMode/ c $FileCreateMode 0640' ${RSYS_CONF}
   else
  echo '$FileCreateMode 0640'  >> ${RSYS_CONF}
 fi
 service rsyslog restart
}

function journald_conf { 
 echo "Setting journald configuration"
 for i in \
 "Compress=yes" \
 "Storage=persistent" \
 ; do
 arg=${i%%=*}
  if grep -q "^$arg" ${JOURNAL_CONF} ; then
   sed -i "/^${arg}*=*/ c ${i} " ${JOURNAL_CONF}
    else
   echo "${i}"  >> ${JOURNAL_CONF}
  fi
 done
 
 #disable receiving log from remote client
 systemctl --now mask systemd-journal-remote.socket 
 service  systemd-journald restart
}

function varlog_perm {
find /var/log/ -type f -perm /g+wx,o+rwx -exec chmod --changes g-wx,o-rwx "{}" +
}

function cron_perm {
 echo "Configuring cron permissions..."
 systemctl enable crond
 for file in  ${CRON_DIR} ${CRON_HOURLY} ${CRON_DAILY} ${CRON_WEEKLY} ${CRON_MONTHLY} ; do
  chown root:root $file
  chmod 700 $file
 done
 chmod 600 ${CRONTAB}
 chown root:root ${CRONTAB}
}

function cron_at_access {
 #restrict cron and at to rot user
 rm -f ${CRON_DENY} & touch ${CRON_ALLOW} & chown root:root ${CRON_ALLOW} & chmod 600 ${CRON_ALLOW} || return
 rm -f ${AT_DENY}   & touch ${AT_ALLOW}   & chown root:root ${AT_ALLOW}   & chmod 600 ${AT_ALLOW}   || return	
}

function ssh_config_perm {
 chown root:root ${SSHD_CFG} & chmod u-x,go-rwx ${SSHD_CFG}
}

function ssh_key_perm {
 #change permissions on SSH private and public host key files
 
 find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod u-x,go-rwx {} \;
 find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;
 find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod u-x,g-wx,o-rwx {} \;
 find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;

} 

function ssh_config {
 echo "Configuring SSH Config..."
 local arg="${1}"
 local value="${2}"
  if grep -q "^\s*$arg" ${SSHD_CFG} ; then
    sed -i "/^${arg}/ c ${arg} ${value}" ${SSHD_CFG}
      else
    echo " ${arg} ${value}"  >> ${SSHD_CFG}
  fi
 systemctl reload sshd
}

function otherfiles_conf_parm {
#comment out any  parameter entries in files ending in *.conf in the /etc/ssh/sshd_config.d/ directory  that include any setting other than propper value.

 local arg="${1}"
  local value="${2}"
  local file="${3}"
 grep -Pi "^\h*${arg}\b" ${file} | grep -Evi ${value} | while read -r l_out; do sed -ri "/^\s*${arg}\s*+/s/^/# /" "$(awk -F: '{print $1}' <<< $l_out)";done
}

function crypto_policy {
sed -ri "s/^\s*(CRYPTO_POLICY\s*=.*)$/# \1/" /etc/sysconfig/sshd /etc/ssh/sshd_config.d/*.conf
}

function sudo_conf {
 grep -qxF 'Defaults use_pty' ${SUDO_CONF} || echo 'Defaults use_pty' >> ${SUDO_CONF} || return
 grep -qxF 'Defaults logfile="/var/log/sudo.log"' ${SUDO_CONF} || echo 'Defaults logfile="/var/log/sudo.log"' >> ${SUDO_CONF} || return
}

function replace_parm_simple {
 local arg="${1}"
 local file="${2}"
 grep -q "^\s*$arg" ${file} || echo "${arg}" >> ${file} || return
}

function replace_parm {
 local argm="${1}"
 local value="${2}"
 local file="${3}"
 if grep -q "^\s*$argm" ${file} ; then
    sed -i "/^\s*${argm}/ c ${argm} ${value}" ${file}
      else
    echo "${argm} ${value}"  >> ${file} 
  fi
}


function replace_parm_nospace {
 local argm="${1}"
 local value="${2}"
 local file="${3}"
 if grep -q "^\s*$argm" ${file}  ; then
    sed -i "/^\s*${argm}/ c ${argm}${value}" ${file}
      else
    echo "${argm}${value}"  >> ${file}
  fi
}


function pam_su {
 groupadd sugroup
 grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(\h+.*)?$' $PAM_SU ||
 echo 'auth            required        pam_wheel.so use_uid group=sugroup' >>  $PAM_SU
}


function escalation_sudo {
   local escal="$(grep -r "^[^#].*NOPASSWD" ${SUDOERS})"
    echo_red "---------------------------------------------------------------------------------------"  >>  $MANUAL_FIX
    echo_bold "5.3.4 Ensure users must provide password for privilege escalation"  >>  $MANUAL_FIX
    echo "Remove any line with occurrences of !authenticate tags in the file"  >>  $MANUAL_FIX

   [[  -z "${escal}" ]] || echo $escal >>  $MANUAL_FIX

}

function reauth_escalation_sudo {
  local reauth_escal="$( grep -r "^[^#].*\!authenticate"  ${SUDOERS})"
   echo_red "---------------------------------------------------------------------------------------"  >>  $MANUAL_FIX
   echo_bold "5.3.5 Ensure re-authentication for privilege escalation is not disabled globally" >> $MANUAL_FIX
   echo "Remove any line with occurrences of !authenticate tags in these files" >>  $MANUAL_FIX

    [[  -z "${reauth_escal}" ]] ||    echo $reauth_escal >>  $MANUAL_FIX

}

function  auth_timeout_sudo {
 local address="$(grep -v '^#' ${SUDOERS} | grep -E '\s*timestamp_timeout=')"
 local timeout="$(grep -v '^#' ${SUDOERS} | grep -oE '\s*timestamp_timeout=\s*([0-9]+)' | cut -d'=' -f2)"
 local timeout2="$(sudo -V | grep "Authentication timestamp timeout:" | cut -d" " -f4 | cut -d "." -f1)"
 if [[ $timeout -gt 15 ]] || [[ $timeout2 -gt 15 ]]; then
  echo_red "---------------------------------------------------------------------------------------"  >>  $MANUAL_FIX
   echo_bold "5.3.6 Ensure sudo authentication timeout is configured correctly" >> $MANUAL_FIX
    echo " edit the file listed in the audit section with visudo -f <PATH TO FILE> and modify the entry timestamp_timeout= to 15 or less" >> $MANUAL_FIX
     echo $address >> $MANUAL_FIX
    echo $timeout  >> $MANUAL_FIX
    echo $timeout2 >> $MANUAL_FIX

   else
  return 0
 fi
}


  
function enable_faillock {
   if [ "$auth_confirm" = "y" ]; then
     echo "Authentication profile change agreed."  >> ./$LOGFILE
      authselect select sssd --force
       authselect enable-feature with-faillock
   	    authselect enable-feature with-pwhistory
         authselect enable-feature without-nullok
        authselect apply-changes      
       elif [ "$auth_confirm" = "n" ]; then
      echo "Authentication profile change not agreed. Exiting without apply settings." >> ./$LOGFILE
     else
    echo "Invalid input got for Authentication profile change agreement. Please enter 'y' or 'n'."  >> ./$LOGFILE
  fi
   
#recover corrupted config files
#authselect select sssd --force
#authselect current
}

function pass_reuse {
 local file="/etc/authselect/$(head -1 /etc/authselect/authselect.conf | grep 'custom/')/system-auth"
  if ! grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwhistory\.so\h+([^#\n\ r]+\h+)?remember=([5-9]|[1-9][0-9]+)\b.*$' "$file"; then
   if grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwhistory\.so\h+([^#\n\ r]+\h+)?remember=\d+\b.*$' "$file"; then
    sed -ri 's/^\s*(password\s+(requisite|required|sufficient)\s+ pam_pwhistory\.so\s+([^# \n\r]+\s+)?)(remember=\S+\s*)(\s+.*)?$/\1 remember=5 \5/' $file
   elif grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwhistory\.so\h+([^#\n\ r]+\h+)?.*$' "$file"; then
    sed -ri '/^\s*password\s+(requisite|required|sufficient)\s+ pam_pwhistory\.so/ s/$/ remember=5/' $file
   else
    sed -ri '/^\s*password\s+(requisite|required|sufficient)\s+pam_unix\.so/i password required pam_pwhistory.so remember=5 use_authtok' $file
   fi
 fi

 if ! grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+([^#\n\r]+\h +)?remember=([5-9]|[1-9][0-9]+)\b.*$' "$file"; then
  if grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+([^#\n\r]+\h +)?remember=\d+\b.*$' "$file"; then
    sed -ri 's/^\s*(password\s+(requisite|required|sufficient)\s+pam_unix\.so\s+([^#\n\r] +\s+)?)(remember=\S+\s*)(\s+.*)?$/\1 remember=5 \5/' $file
   else
    sed -ri '/^\s*password\s+(requisite|required|sufficient)\s+pam_unix\.so/ s/$/ remember=5/' $file
   fi
  fi
}

function sha512_hash {
 for fn in system-auth password-auth; do
 local file="/etc/authselect/$(head -1 /etc/authselect/authselect.conf | grep 'custom/')/$fn"
  if ! grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+sha512\b.*$' "$file"; then
   if grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so(\h+[^#\n\r]+)? \h+(md5|blowfish|bigcrypt|sha256|yescrypt)\b.*$' "$file"; then
    sed -ri 's/(md5|blowfish|bigcrypt|sha256|yescrypt)/sha512/' "$file"
   else
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_unix.so\s+)(.*)$/\1sha512 \3/' "$file"
   fi
  fi
 done
}

function update_chage {
# chage all users
local ssh_users="$(awk -F: '{ if ($3 >= 1000 && $7 ~ "/bin/(ba|z)?sh") print $1 }' ${PASSWD} )"
for user in ${ssh_users}
   do
       chage --maxdays 365 $user
       chage --mindays  1  $user
       chage --warndays 7  $user
       chage --inactive 30 $user
 done
}  
   
function update_chage_specific {
#update chage for specific users,such as root or other critical users
 local user="${1}"
  chage --maxdays 365 $user
  chage --mindays  1  $user
  chage --warndays 7  $user
 }
 
function disabled_users {

 awk -F: '/^[^#:]+:[^!\*:]*:[^:]*:[^:]*:[^:]*:[^:]*:(\s*|-1|3[1-9]|[4-9][0-9]|[1-9][0-9][0-9]+):[^:]*:[^:]*\s*$/ {print $1":"$7}' /etc/shadow || return 1

#echo >> ./$LOGFILE
}

function inactive_pass {
 useradd -D -f 30
}

function last_pass {
awk -F: '/^[^:]+:[^!*]/{print $1}' ${SHADOW} | while read -r usr; do
  if [ "$usr" != "oracle" ] && [ "$usr" != "root" ]; then
   change=$(date -d "$(chage --list $usr | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s); \
    if [[ "$change" -gt "$(date +%s)" ]]; then \
     echo "User: \"$usr\" will be locked, because its last password change date is in the future: \"$(chage --list $usr | grep '^Last password change' | cut -d: -f2)\"" 
     passwd -l $usr
   fi
  fi
done

#passwd -S username
#passwd -u username
}	

function secure_acc {
local users="$(awk -F: '/nologin/ {print $1}' /etc/passwd | xargs -I '{}' passwd -S '{}' | awk '($2!="LK") {print $1}')"
 passwd -l $users
 
 echo "Accounts that configured the shell as nologin but their password are not locked:  ${users}" >> ./$LOGFILE
 echo "Accounts that configured the shell as nologin but their password are not locked:  ${users}"


}

function root_gid {
 usermod -g 0 root
}

function set_file_perms {
  # set Perms on a supplied file based on pattern
  local file="${1}"
  local pattern="${2}"
  chmod "${pattern}" ${file} 
}
function history_time {
 grep -q "HISTTIMEFORMAT=" ${PROFILE_FILE} || echo "export HISTTIMEFORMAT=\"%d.%m.%y %T  \"" >> ${PROFILE_FILE}
}

function set_file_owner {
  # set owner on  supplied files based on pattern
  local file="${1}"
  local pattern="${2}"
  chown "${pattern}" ${file} 
}

function world_writable_files {
   echo "6.1.9  World Writable Files - Remove write access for the "other" category (chmod o-w <filename>) : " >>  $MANUAL_FIX
   df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002 >>  $MANUAL_FIX
   echo "---------------------------------------------------------------------------------------" >>  $MANUAL_FIX
 }
 
function unowned_files {
 echo "6.1.10 Reset the ownership of these files to some active user on the system as appropriate(chown): " >>  $MANUAL_FIX
 df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser >>  $MANUAL_FIX
 echo "---------------------------------------------------------------------------------------"     >>  $MANUAL_FIX
}

function ungrouped_files {
   echo "6.1.11 Reset the ownership of these files to some active group on the system as appropriate(chown): " >>  $MANUAL_FIX
   df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup >>  $MANUAL_FIX
   echo "---------------------------------------------------------------------------------------"     >>  $MANUAL_FIX
}
  
  
function SUID_executables {
 echo "6.1.13 Ensure that no rogue SUID programs have been introduced into the system.
 Review the files returned and confirm the integrity of these binaries: " >>  $MANUAL_FIX
 df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -4000 >>  $MANUAL_FIX
 echo "---------------------------------------------------------------------------------------"     >>  $MANUAL_FIX
}

function SGID_executables {
 echo "6.1.14  Ensure that no rogue SGID programs have been introduced into the system.
 Review the files returned and confirm the integrity of these binaries: " >>  $MANUAL_FIX
 df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -2000 >>  $MANUAL_FIX
 echo "---------------------------------------------------------------------------------------"     >>  $MANUAL_FIX
}
 
function audit_sys_rpm {
  echo "6.1.15 It is important to confirm that packaged system files and directories are maintained with
the permissions they were intended to have from the OS vendor. " >  $LOGDIR/rpm_packages_permissions_$TIME.log
  rpm -Va --nomtime --nosize --nomd5 --nolinkto >>   $LOGDIR/rpm_packages_permissions_$TIME.log
}

function sticky_bit {
echo -e "6.1.12 Setting the sticky bit on world writable directories prevents users from deleting or
renaming files in that directory that are not owned by them\n" > $LOGDIR/sticky_on_world_$TIME.log
 df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | xargs -I '{}' chmod a+t '{}' >> $LOGDIR/sticky_on_world_$TIME.log
}

function shadow_password {
  sed -e 's/^\([a-zA-Z0-9_]*\):[^:]*:/\1:x:/' -i ${PASSWD}
}
    
function empty_pass {
 awk -F: '($2 == "" ) {print $1}' ${SHADOW} | while read -r usr; do
 passwd -l $usr
done
}

function groups_passwd {
for i in $(cut -s -d: -f4 ${PASSWD} | sort -u ); do
  grep -q -P "^.*?:[^:]*:$i:" ${GROUP}
   if [ $? -ne 0 ]; then
     echo "6.2.3 Group $i is referenced by /etc/passwd but does not exist in /etc/group" >>  $MANUAL_FIX
     echo "---------------------------------------------------------------------------------------"  >>  $MANUAL_FIX
     return 1
   fi
  done
}

function duplicate_UID {
  cut -f3 -d":" ${PASSWD} | sort -n | uniq -c | while read x ; do
  [ -z "$x" ] && break
  set - $x
  if [ $1 -gt 1 ]; then
   users=$(awk -F: '($3 == n) { print $1 }' n=$2 ${PASSWD} | xargs)
   echo "6.2.4 Based on the results , Analyze the output of and perform the appropriate action to correct
any discrepancies found."  >>   $MANUAL_FIX
   echo "Duplicate UID ($2): $users" >>   $MANUAL_FIX
   echo "---------------------------------------------------------------------------------------"  >>  $MANUAL_FIX
  fi
 done
}

function duplicate_GID {
# delete empty groups by grpck
cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
 echo "6.2.5 Based on the results , establish unique GIDs and review all files
owned by the shared GID to determine which group they are supposed to belong to."  >>   $MANUAL_FIX
   echo "Duplicate GID ($x) in /etc/group" >>   $MANUAL_FIX
   echo "---------------------------------------------------------------------------------------"  >>  $MANUAL_FIX
 done
}

function duplicate_username {
 cut -d: -f1 ${PASSWD} | sort | uniq -d | while read -r x; do
  echo "6.2.6 Based on the results , establish unique user names for the users. File
  ownerships will automatically reflect the change as long as the users have unique UIDs."  >>   $MANUAL_FIX
   echo "Duplicate login name $x in /etc/passwd" >>   $MANUAL_FIX
   echo "---------------------------------------------------------------------------------------)"  >>  $MANUAL_FIX
 done
}

function duplicate_groupname {
  cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do
  echo "6.2.7 Based on the results , establish unique names for the user groups. File group 
  ownerships will automatically reflect the change as long as the groups have unique GIDs."  >>   $MANUAL_FIX
  echo "Duplicate group name $x in /etc/group" >>   $MANUAL_FIX
  echo "---------------------------------------------------------------------------------------)"  >>  $MANUAL_FIX
done
} 
 

function root_path {
  echo "6.2.8 Based on results,Correct or justify any items." >>  $MANUAL_FIX
local RPCV="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
 echo "$RPCV" | grep  "::" && echo "root's path contains a empty directory (::)" >>  $MANUAL_FIX
 echo "$RPCV" | grep  ":$" && echo "root's path contains a trailing (:)" >>  $MANUAL_FIX
 for x in $(echo "$RPCV" | tr ":" " "); do
   if [ -d "$x" ]; then
    ls -ldH "$x" | awk '$9 == "." {print "PATH contains current working directory (.)"}  $3 != "root" {print $9, "is not owned by root"} substr($1,6,1) != "-" {print $9, "is group writable"} substr($1,9,1) != "-" {print $9, "is world writable"}' >>  $MANUAL_FIX
    else
   echo "$x is not a directory" >>  $MANUAL_FIX
  fi
 done
echo "---------------------------------------------------------------------------------------)"  >>  $MANUAL_FIX
}

function root_uid {
 awk -F: '($3 == 0 ) { print $1 }' ${PASSWD} | while read -r u0usr; do
  if [ "$u0usr" != "root" ]; then
     echo "User: \"$u0usr\" will be locked, because it has UID 0 which belongs to root account" >> ./$LOGFILE
     echo "User: \"$u0usr\" will be locked, because it has UID 0 which belongs to root account"
     usermod -L $u0usr
  fi
 done
}

function home_dirs_exist {
local valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' - ))$"
 awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' ${PASSWD} | while read -r user home; do
  if [ ! -d "$home" ]; then
   echo -e "\n- User \"$user\" home directory \"$home\" doesn't exist\n- creating home directory \"$home\"\n" >> ./$LOGFILE
    echo -e "\n- User \"$user\" home directory \"$home\" doesn't exist\n- creating home directory \"$home\"\n"
     mkdir "$home"
    chmod g-w,o-wrx "$home"
   chown "$user" "$home"
  fi
 done
} 
 
function home_dirs_owner {
  local output=""
  local valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' - ))$"
  awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' "${PASSWD}" | while read -r user home; do
  owner="$(stat -L -c "%U" "$home")"
  if [ "$owner" != "$user" ]; then
    echo -e "\n- User \"$user\" home directory \"$home\" is owned by user \"$owner\"\n - changing ownership to \"$user\"\n"
    echo -e "\n- User \"$user\" home directory \"$home\" is owned by user \"$owner\"\n - changing ownership to \"$user\"\n" >> ./$LOGFILE
    chown "$user" "$home"
    echo  "$user" "$home"
  fi
  done
}


function home_dirs_perm {
 local perm_mask='0027'
 local maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
 valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' - ))$"
 awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' ${PASSWD} | (while read -r user home; do
 mode=$( stat -L -c '%#a' "$home" )
 if [ $(( $mode & $perm_mask )) -gt 0 ]; then
  echo -e "- modifying User $user home directory: \"$home\"\nremoving excessive permissions from current mode of \"$mode\""
  echo -e "- modifying User $user home directory: \"$home\"\nremoving excessive permissions from current mode of \"$mode\"" >> ./$LOGFILE
  chmod g-w,o-rwx "$home"
  fi
 done
 )
}

function remove_netrc {
 local perm_mask='0177'
 local valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' - ))$"
 awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' ${PASSWD}| while read -r user home; do
  if [ -f "$home/.netrc" ]; then
   echo -e "\n- User \"$user\" file: \"$home/.netrc\" exists\n -removing file: \"$home/.netrc\"\n" >> $LOGFILE
   echo -e "\n- User \"$user\" file: \"$home/.netrc\" exists\n -removing file: \"$home/.netrc\"\n"
   rm -f "$home/.netrc"
  fi
 done
}

function remove_forward {
  local output=""
  local fname=".forward"
  local valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' - ))$"
   awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' ${PASSWD} | (while read -r user home; do
    if [ -f "$home/$fname" ]; then
     echo -e "$output\n- User \"$user\" file: \"$home/$fname\" exists\n - removing file: \"$home/$fname\"\n" >> $LOGFILE
     echo -e "$output\n- User \"$user\" file: \"$home/$fname\" exists\n - removing file: \"$home/$fname\"\n"
	rm -r "$home/$fname"
   fi
  done
 )
}

function remove_rhosts {
 local perm_mask='0177'
 local valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' - ))$"
 awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' ${PASSWD} | while read -r user home; do 
  if [ -f "$home/.rhosts" ]; then
   echo -e "\n- User \"$user\" file: \"$home/.rhosts\" exists\n -removing file: \"$home/.rhosts\"\n" >> $LOGFILE
   echo -e "\n- User \"$user\" file: \"$home/.rhosts\" exists\n -removing file: \"$home/.rhosts\"\n"
   rm -f "$home/.rhosts"
  fi
 done
}
 
function dot_files {
 local perm_mask='0022'
 local valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' - ))$"
 awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' ${PASSWD} | while read -r user home; do
  find "$home" -type f -name '.*' | while read -r dfile; do
   local mode=$( stat -L -c '%#a' "$dfile" )
    if [ $(( $mode & $perm_mask )) -gt 0 ]; then
     echo -e "\n- Modifying User \"$user\" file: \"$dfile\"\nremoving group and other write permissions" >> $LOGFILE
     echo -e "\n- Modifying User \"$user\" file: \"$dfile\"\nremoving group and other write permissions"
     chmod go-w "$dfile"
    fi
   done
  done
}


========================================================================================================

touch ./$LOGFILE
  clear
  echo -e "\n\n IP Address : $IP_ADR"       > ./$LOGFILE
  echo -e "\n Host Name    : $(hostname)"  >> ./$LOGFILE
  echo -e "\n OS Version   : $OS_VERSION"  >> ./$LOGFILE
  echo -e "\n Date : $(date '+%Y.%m.%d')             Time: $(date '+%H:%M') "  >> ./$LOGFILE
  echo -e "\n State           Index           Defined Argument" >> ./$LOGFILE
  echo -e "==============================================================" >> ./$LOGFILE


  
  function f_return {
    let TOTAL++
    func_name=$1
    shift
    args=$@
    printf "${func_name} ${args}: "
    ${func_name} ${args} >/dev/null 2>&1
    if [[ "$?" -eq 0 ]]; then
      let PASS++
      echo_green   [Applied]
      echo_green "Applied          $func_name                          $args" >> ./$LOGFILE
      echo  -e "-----------------------------------------------------------" >> ./$LOGFILE

      else
      let FAILED++
      echo_red   [NOT Applied]
 
      echo_red   "Not Applied      $func_name                          $args" >> ./$LOGFILE
      echo  -e "-----------------------------------------------------------" >> ./$LOGFILE

    fi
   }
   
function cockpit {
 rm -f /etc/issue.d/cockpit.issue /etc/motd.d/cockpit
 service cockpit stop
 systemctl disable --now cockpit.socket
}



 # checking Initial Setup
  echo_red "\n********** 1.Initial Setup **********"

  echo_bold "##### 1.1.1 Disable unused file systems and TIPC protocols #####"
   f_return disable_fs 

  # "##### 1.2.1 GPG keys are configured"
  # Manual :  Update your package manager GPG keys in accordance with site policy.
  
  echo_bold "##### 1.2.2 , 4 Ensure gpgcheck(package signature check) is globally activated #####"
   f_return gpg_check  
 
  echo_bold "##### 1.3.1 Ensure AIDE is installed and Configured #####"
   backup ${aide_conf}
   f_return aide

  echo_bold "##### 1.3.2 Ensure filesystem integrity is regularly checked #####"
   f_return  aide_cron

  echo_bold "##### 1.3.1 , 3 Ensure AIDE is Configured #####"
   f_return aide_conf

  echo_bold "##### 1.4.2 Ensure permissions on bootloader config are configured #####"
   f_return grub_perm 

  echo_bold "##### 1.5.1 - 2 Core dump security config #####"
   f_return  core_dump_conf

 echo_bold "##### 1.5.3 Ensure address space layout randomization (ASLR) is enabled"
    f_return set_aslr
   
  echo_bold "##### 1.6.1.1 - 3  Ensure SELinux is enabled and configured #####"
   f_return selinux

 echo_bold "##### 1.6.1.7 - 8 Remove SETroubleshoot and MCS Translation #####"
   f_return remove_package setroubleshoot
   f_return remove_package mcstrans

 echo_bold "##### 1.7.1 - 3 Command Line Warning Banners #####"
  f_return  login_banner   /etc/motd
  f_return  login_banner  /etc/issue
  f_return  ssh_banner   

 echo_bold "##### 1.7.4 - 6 Ensure permissions on warning banners files #####"
  f_return banners_perm

 echo_bold "##### 1.8.1 Ensure GNOME Display Manager is removeds #####"
  f_return  remove_package gdm

 echo_bold "##### 1.9 Ensure updates, patches, and additional security softwares are installed (Manual)"
  f_return #dnf update

 echo_bold "##### 1.10 Ensure system-wide crypto policy is not legacy #####"
  f_return crypto_policy
  
 #checking Servicess Configuration
  echo_red "\n**********2.Services **********\n"

 echo_bold "##### 2.1 Time Synchronization "
  f_return  install_package chrony

 echo_bold "##### 2.2.1 - 18 Removing lagacy services . . .  "
  f_return  disable_service
  f_return  remove_package xorg-x11-server-common
  f_return  remove_package avahi
  f_return  remove_package cups
  f_return  remove_package dhcp-server
  f_return  remove_package bind
  f_return  remove_package vsftpd
  f_return  remove_package tftp-server
  #f_return  remove_package httpd nginx
  f_return  remove_package dovecot cyrus-imapd
  f_return  remove_package samba
  f_return  remove_package squid
  f_return  remove_package net-snmp
  f_return  remove_package telnet-server
  f_return  remove_package dnsmasq
  f_return  remove_package postfix
  f_return  remove_package nfs-utils
  f_return  remove_package rpcbind
  f_return  remove_package rsync-daemon
   
 echo_bold "##### 2.2.3 - 18 Removing insecure services . . .  "
  f_return  remove_package telnet
  f_return  remove_package openldap-clients
  f_return  remove_package tftp
  f_return  remove_package ftp

  # Checking Network Configuration
  echo_red "\n********** Network Configuration **********\n"
   
  echo_bold "##### 3.1.1 Verify if IPv6 is Disabled on the system #####"
   backup ${NETWORK_V6}
   f_return disable_ipv6 

  echo_bold "##### 3.1.2 Ensure wireless interfaces are disabled #####"
   f_return wlan

  echo_bold "##### 3.1.3 Ensure TIPC is disabled #####"


#As flushing the routing table can temporarily disrupt network connectivity until the routing table is rebuilt


  echo_bold "##### 3.2.1 Ensure IP forwarding disabled #####"
   #make backup
   backup "${SYSCTL_CON}"
   backup "${SYSCTL_CONFv6}"
  #There should be a space before the first argument
   f_return  network_conf net.ipv4.ip_forward  =0

   #There should be NOT be a space before flag value
   f_return  network_conf_sysctl net.ipv4.ip_forward=0
     
  echo_bold "##### 3.2.2 Ensure packet redirect sending disabled for #####"
   f_return network_conf net.ipv4.conf.all.send_redirects  =0
   f_return network_conf net.ipv4.conf.default.send_redirects  =0
   f_return network_conf_sysctl net.ipv4.conf.all.send_redirects=0
   f_return network_conf_sysctl net.ipv4.conf.default.send_redirects=0

 echo_bold "##### 3.3.1 Ensure source routed packets are not accepted  #####"
 
 echo_bold "Checking IPV4:"
  f_return network_conf net.ipv4.conf.all.accept_source_route  =0
  f_return network_conf net.ipv4.conf.default.accept_source_route  =0
  f_return network_conf_sysctl net.ipv4.conf.all.accept_source_route=0
  f_return network_conf_sysctl net.ipv4.conf.default.accept_source_route=0
  
 echo_bold "Checking IPV6:"
  f_return network_confv6 net.ipv6.conf.all.accept_source_route  =0
  f_return network_confv6 net.ipv6.conf.default.accept_source_route  =0
  f_return network_conf_sysctlv6 net.ipv6.conf.all.accept_source_route=0
  f_return network_conf_sysctlv6 net.ipv6.conf.default.accept_source_route=0

 echo_bold "##### 3.3.2 Ensure ICMP redirects not accepted #####"
 
 echo_bold "Checking IPV4:"
   f_return network_conf net.ipv4.conf.all.accept_redirects  =0
   f_return network_conf net.ipv4.conf.default.accept_redirects  =0
   f_return network_conf_sysctl net.ipv4.conf.all.accept_redirects=0
   f_return network_conf_sysctl net.ipv4.conf.default.accept_redirects=0

  echo_bold "Checking IPV6:"
   f_return network_confv6 net.ipv6.conf.all.accept_redirects  =0
   f_return network_confv6 net.ipv6.conf.default.accept_redirects  =0
   f_return network_conf_sysctlv6 net.ipv6.conf.all.accept_redirects=0
   f_return network_conf_sysctlv6 net.ipv6.conf.default.accept_redirects=0

  echo_bold "##### 3.3.3 Ensure secure ICMP redirects not accepted #####"
   f_return network_conf net.ipv4.conf.all.secure_redirects  =0
   f_return network_conf net.ipv4.conf.default.secure_redirects  =0
   f_return network_conf_sysctl net.ipv4.conf.all.secure_redirects=0
   f_return network_conf_sysctl net.ipv4.conf.default.secure_redirects=0

  echo_bold "##### 3.3.4 Ensure suspicious packets are logged #####"
   f_return network_conf net.ipv4.conf.all.log_martians  =1
   f_return network_conf net.ipv4.conf.default.log_martians  =1
   f_return network_conf_sysctl net.ipv4.conf.all.log_martians=1 
   f_return network_conf_sysctl net.ipv4.conf.default.log_martians=1

  echo_bold "##### 3.3.5 Ensure broadcast ICMP requests ignored #####"
   f_return network_conf net.ipv4.icmp_echo_ignore_broadcasts  =1
   f_return network_conf_sysctl net.ipv4.icmp_echo_ignore_broadcasts 1

  echo_bold "##### 3.2.6 Ensure bogus ICMP responses ignored #####"
   f_return network_conf net.ipv4.icmp_ignore_bogus_error_responses  =1
   f_return network_conf_sysctl net.ipv4.icmp_ignore_bogus_error_responses=1

  echo_bold "##### 3.3.7 Ensure reverse path filtering enabled #####"
   f_return network_conf net.ipv4.conf.all.rp_filter  =1
   f_return network_conf net.ipv4.conf.default.rp_filter  =1
   f_return network_conf_sysctl net.ipv4.conf.all.rp_filter 1
   f_return network_conf_sysctl net.ipv4.conf.default.rp_filter 1

  echo_bold "##### 3.3.8 Ensure TCP SYN Cookies enabled #####"
   f_return network_conf net.ipv4.tcp_syncookies  =1
   f_return network_conf_sysctl net.ipv4.tcp_syncookies 1

  echo_bold "##### 3.3.9 Ensure IPv6 router advertisements are not accepted #####"
   f_return network_confv6 net.ipv6.conf.all.accept_ra  =0
   f_return network_confv6 net.ipv6.conf.default.accept_ra  =0
   f_return network_conf_sysctlv6 net.ipv6.conf.all.accept_ra=0
   f_return network_conf_sysctlv6 net.ipv6.conf.default.accept_ra=0

  echo_bold "##### 3.4.1.2   Ensure iptables and nftables service not enabled #####" 
   f_return  remove_package iptables-services
   f_return  systemctl --now mask nftables

 echo_bold "##### 3.4.1 - 7  Firewalld Config #####"
   f_return firewalld_conf

#Checking Network Configuration
 echo_red "\n********** 4.Logging and Auditing **********\n"

 echo_bold "##### 4.1.1 auditd service config #####" 
  f_return install_package audit
  f_return audit_conf
  
 echo_bold "##### 4.1.2 Config audit log setting #####"
  backup ${AUDITD_CNF}
  replace_parm_nospace "max_log_file_action=" ROTATE ${AUDITD_CNF}
  replace_parm_nospace "max_log_file=" 50 ${AUDITD_CNF}
  replace_parm_nospace "space_left_action=" ROTATE ${AUDITD_CNF}
  replace_parm_nospace "admin_space_left_action=" ROTATE ${AUDITD_CNF}
  replace_parm_nospace "disk_full_action=" ROTATE ${AUDITD_CNF}
  replace_parm_nospace "disk_error_action=" SYSLOG ${AUDITD_CNF}

 echo_bold "##### 4.1.4.1 - 4 Ensure audit log files have proper or more restrictive permission and owner #####"
  f_return audit_log_perm

 echo_bold "##### 4.1.4.5 - 7 Ensure audit configuration files have 640 or more restrictive permission and owner #####"
  f_return audit_conf_perm

 echo_bold "##### 4.1.4.8 - 10 Ensure audit tools have proper or more restrictive permission and owner #####"
  f_return audit_tools_perm

echo_bold "##### 4.2.1 Config rsyslog . . ."
  backup ${RSYS_CONF}
  f_return rsyslog_conf

 echo_bold "##### 4.2.2.2 - 4 journald service configuration #####"
  backup ${JOURNAL_CONF}
  f_return journald_conf

 echo_bold "##### 4.2.3 Ensure all logfiles have appropriate permissions and ownership #####"
  f_return varlog_perm

  #Checking Network Configuration
  echo_red "\n********** 5.Access, Authentication and Authorization **********\n"

 echo_bold "##### 5.1.1	- 7 Ensure permissions on Cron files are configured #####"
  f_return cron_perm

 echo_bold "##### 5.1.8 - 9 Ensure cron and at is restricted to authorized users #####"
  f_return cron_at_access 

 echo_bold "##### 5.2.1	Ensure permissions on /etc/ssh/sshd_config are configured #####"
  f_return ssh_config_perm
  
 echo_bold "##### 5.2.2 Ensure permissions on SSH private and public host key files are configured #####"
  f_return ssh_key_perm 

 echo_bold "##### 5.2.5 - 20 Configure SSHD Config #####"
  backup ${SSHD_CFG}
  f_return ssh_config LogLevel VERBOSE
  f_return ssh_config UsePAM yes
  echo "disable RootLogin will not apply"
  #f_return ssh_config PermitRootLogin no
  f_return replace_parm HostbasedAuthentication no ${SSHD_CFG}
  f_return replace_parm PermitEmptyPasswords no ${SSHD_CFG}
  f_return replace_parm PermitUserEnvironment no ${SSHD_CFG}
  f_return replace_parm IgnoreRhosts yes ${SSHD_CFG}
  f_return replace_parm X11Forwarding no ${SSHD_CFG}
  f_return replace_parm AllowTcpForwarding no ${SSHD_CFG}
  f_return replace_parm Banner /etc/issue.net ${SSHD_CFG}
  f_return replace_parm MaxAuthTries 4 ${SSHD_CFG}
  f_return replace_parm MaxStartups 10:30:60 ${SSHD_CFG}
  f_return replace_parm MaxSessions 10 ${SSHD_CFG}
  f_return replace_parm LoginGraceTime 60 ${SSHD_CFG}
  f_return replace_parm ClientAliveInterval  900 ${SSHD_CFG}
  f_return replace_parm ClientAliveCountMax 1 ${SSHD_CFG}
  
 echo_bold "##### 5.2.5 - 20 check and configure SSHD Config in other files"
   otherfiles_conf_parm  HostbasedAuthentication no "${SSHD_ALL}"
   otherfiles_conf_parm  PermitEmptyPasswords no "${SSHD_ALL}"
   otherfiles_conf_parm  PermitUserEnvironment no "${SSHD_ALL}"
   otherfiles_conf_parm  IgnoreRhosts yes "${SSHD_ALL}"
   otherfiles_conf_parm  X11Forwarding no "${SSHD_ALL}"
   otherfiles_conf_parm  AllowTcpForwarding no "${SSHD_ALL}"
   otherfiles_conf_parm  Banner /etc/issue.net "${SSHD_ALL}"
   otherfiles_conf_parm  MaxAuthTries 4 "${SSHD_ALL}"
   otherfiles_conf_parm  MaxStartups 10:30:60 "${SSHD_ALL}"
   otherfiles_conf_parm  MaxSessions 10 "${SSHD_ALL}"
   otherfiles_conf_parm  LoginGraceTime 60 "${SSHD_ALL}"
   otherfiles_conf_parm  ClientAliveInterval 900 "${SSHD_ALL}"
   otherfiles_conf_parm  ClientAliveCountMax 1 "${SSHD_ALL}"
   service sshd restart >/dev/null 2>&1

 echo_bold "##### 5.2.14 Ensure system-wide crypto policy is not over-ridden #####"
  f_return crypto_policy 

 echo_bold "##### 5.3.2 - 3  Sudo config #####"
  f_return backup ${SUDO_CONF}
 #f_return makes some intruption
  replace_parm_simple "Defaults use_pty" ${SUDO_CONF}
  replace_parm "Defaults logfile=" "/var/log/sudo.log" ${SUDO_CONF}

 echo_bold "##### 5.3.4 Ensure users must provide password for escalation"
  f_return escalation_sudo

 echo_bold "##### 5.3.5 Ensure re-authentication for privilege escalation is not disabled globally"
  f_return reauth_escalation_sudo

 echo_bold "##### 5.3.6 Ensure sudo authentication timeout is configured correctly"
   auth_timeout_sudo

 echo_bold "##### 5.3.7 Ensure access to the su command is restricte #####"
  backup  ${PAM_SU}
  f_return pam_su

 echo_bold "#####5.4.2 Ensure authselect includes with-faillock #####"
  f_return  enable_faillock 

 echo_bold "#####5.5.1 Ensure password creation requirements are configured #####"
  backup ${PWQUAL_CNF}
  backup ${SYSTEM_AUTH}
  backup ${PASS_AUTH}
  backup ${PWQUAL_CNF}
 replace_parm "minlen ="  "14" ${PWQUAL_CNF}
 replace_parm "minclass ="  "4" ${PWQUAL_CNF}
 replace_parm "retry ="  "3" ${PWQUAL_CNF}
 
 echo_bold "##### 5.5.2 Ensure lockout for failed password attempts is configured #####" 
  replace_parm "deny ="  5 ${FAIL_CONF}
  replace_parm "unlock_time ="  900 ${FAIL_CONF}
  replace_parm "enforce_for_root" ""  ${PWQUAL_CNF}
  replace_parm "even_deny_root" ""   ${FAIL_CONF}
  replace_parm "silent" "" ${FAIL_CONF}
  replace_parm "audit" ""  ${FAIL_CONF}
  replace_parm "even_deny_root" "" ${FAIL_CONF}
  service sshd restart >/dev/null 2>&1

 echo_bold "##### 5.5.3 Ensure password reuse is limited #####"
 f_return pass_reuse
  
 echo_bold "##### 5.5.4 Ensure password hashing algorithm is SHA-512 #####"
  f_return sha512_hash
  f_return replace_parm ENCRYPT_METHOD SHA512 ${LOGIN_DEFS} 
  replace_parm "crypt_style =" "sha512" ${LIB_USR} 

 echo_bold "##### 5.6.1.1 Ensure password expiration is 365 days or less #####"
  f_return replace_parm PASS_MAX_DAYS 365 ${LOGIN_DEFS} 
 
 echo_bold "##### 5.6.1.2 Ensure minimum days between password changes is 7 or more #####"
  f_return replace_parm PASS_MIN_DAYS 1   ${LOGIN_DEFS} 
 
 echo_bold "##### 5.6.1.3 Ensure password expiration warning days is 7 or more #####"
  f_return replace_parm PASS_WARN_AGE 7 ${LOGIN_DEFS}  
  f_return update_chage
  f_return update_chage_specific root


 echo_bold "##### 5.6.1.4 Ensure inactive password lock is 30 days or less #####"
  f_return inactive_pass

 echo_bold "##### 5.6.1.5 Ensure all users last password change date is in the past #####" 
  f_return last_pass

 echo_bold "##### 5.6.2 Ensure system accounts are secured #####"
  f_return secure_acc

 echo_bold "##### 5.6.3 Shell Timeout#####"
  otherfiles_conf_parm  "readonly TMOUT=" "1800" "${PROFILE_D}"
  replace_parm_nospace "readonly TMOUT=" "1800 ; export TMOUT" ${PROFILE_BASH}

 echo_bold "##### 5.6.4 Ensure default group for the root account is GID 0 #####"
  f_return root_gid
  
 echo_bold "##### 5.6.5 Ensure default user umask is 027 or more restrictive #####"
  otherfiles_conf_parm umask 027 "${PROFILE_D}"
  replace_parm UMASK 027 ${LOGIN_DEFS}
  replace_parm umask 027 ${BASHRC}
  replace_parm USERGROUPS_ENAB no ${LOGIN_DEFS}
 

 echo_red "\n********** 6 System Maintenance **********\n"

 
 echo_bold "##### 6.0 set history time format #####"
  f_return history_time

 echo_bold "##### 6.1.1 - 8 Ensure permissions on passwd(-), group(-) and shadow(-) files are configures #####"
   f_return set_file_perms "${PASSWD}"  "u-x,go-wx"
   f_return set_file_perms "${PASSWD2}" "u-x,go-wx" 
   f_return set_file_perms "${GROUP}"   "u-x,go-wx" 
   f_return set_file_perms "${GROUP2}"  "u-x,go-wx" 
   f_return set_file_perms "${SHADOW}"   0000
   f_return set_file_perms "${SHADOW2}"  0000
   f_return set_file_perms "${GSHADOW}"  0000
   f_return set_file_perms "${GSHADOW2}" 0000 

 echo_bold "##### 6.1.1 - 8 Ensure owner on passwd(-), group(-) and shadow(-) files are configures #####"
   f_return set_file_owner "${PASSWD}"   "root:root"
   f_return set_file_owner "${PASSWD2}"  "root:root" 
   f_return set_file_owner "${GROUP}"    "root:root" 
   f_return set_file_owner "${GROUP2}"   "root:root" 
   f_return set_file_owner "${SHADOW}"   "root:root"
   f_return set_file_owner "${SHADOW2}"  "root:root"
   f_return set_file_owner "${GSHADOW}"  "root:root" 
   f_return set_file_owner "${GSHADOW2}" "root:root" 

 echo_bold "##### 6.1.9 Ensure no world writable files exist (Manual) #####"
  f_return world_writable_files

 echo_bold "##### 6.1.10 Ensure no unowned files or directories exist (Manual) #####"
  f_return unowned_files

 echo_bold "##### 6.1.11 Ensure no ungrouped files or directories exist (Manual) #####"
  f_return ungrouped_files
 
 echo_bold "##### 6.1.12 Ensure sticky bit is set on all world-writable directories #####"
  f_return sticky_bit

 echo_bold "##### 6.1.13 Audit SUID executables (Manual) #####"
  f_return SUID_executables
 
 echo_bold "##### 6.1.14 Audit SGID executables (Manual) #####"
  f_return SUID_executables
 
 echo_bold "##### 6.1.15 Audit system file permissions (from RPM package - Manual)) #####"
  f_return audit_sys_rpm
 
 echo_bold "##### 6.2.1 Ensure accounts in /etc/passwd use shadowed passwords #####"
  f_return shadow_password 

 echo_bold "##### 6.2.2 Ensure password fields are not empty #####"
  f_return empty_pass  

 echo_bold "##### 6.2.3 Ensure all groups in /etc/passwd exist in /etc/group #####" 
  f_return groups_passwd
  
 echo_bold "##### 6.2.4 Ensure no duplicate UIDs exist (Manual) #####"
  f_return duplicate_UID
 
 echo_bold "##### 6.2.5 Ensure no duplicate GIDs exist (Manual) #####"
  f_return duplicate_GID

 echo_bold "##### 6.2.6 Ensure no duplicate user names exist (Manual) #####"
  f_return duplicate_username

 echo_bold "##### 6.2.7 Ensure no duplicate group names exist (Manual) #####"
  f_return duplicate_groupname

 echo_bold "##### 6.2.8 Ensure root PATH Integrity (Manual) #####"
  f_return root_path

 echo_bold "##### 6.2.9 Ensure root is the only UID 0 account #####"
  f_return root_uid

 echo_bold "##### 6.2.10 Ensure local interactive user home directories exist #####"
  f_return home_dirs_exist 

 echo_bold "##### 6.2.11 Ensure local interactive users own their home directories #####"
  f_return home_dirs_owner

 echo_bold "##### 6.2.12 Ensure local interactive user home directories are mode 750 or more restrictive #####"
  f_return home_dirs_perm

 echo_bold "##### 6.2.13 Ensure no local interactive user has .netrc files #####"
  f_return  remove_netrc 
 
 echo_bold "##### 6.2.14 Ensure no local interactive user has .forward files #####"
  f_return remove_forward

 echo_bold "##### 6.2.15 Ensure no local interactive user has .rhosts files #####"
  f_return remove_rhosts

 echo_bold "##### 6.2.16 Ensure local interactive user dot files are not group or world writable #####"
  f_return dot_files
 
 echo_bold "other important actions"
  f_return cockpit



echo_bold "\n Hardening process successfully Completed!"
echo_bold "\n You can find changed files backup in \e[36m${BACKUP_DIR}\e[0m and hardening reports in \e[36m${LOGDIR}\e[0m."


results
###################END###################



