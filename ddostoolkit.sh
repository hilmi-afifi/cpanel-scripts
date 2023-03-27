#!/bin/bash

# DDOS Toolkit Protection cPanel
# (c) 2022 Hilmi

# set verbose to null
verbose=""

# set custom coloring using varible xterm terminal
BLACK=$(tput bold; tput setaf 0)
RED=$(tput bold; tput setaf 1)
GREEN=$(tput bold; tput setaf 2)
EGREEN=$(tput sgr0)
YELLOW=$(tput bold; tput setaf 3)
BLUE=$(tput bold; tput setaf 4)
MAGENTA=$(tput bold; tput setaf 5)
CYAN=$(tput bold; tput setaf 6)
WHITE=$(tput bold; tput setaf 7)

# print help message
helper() {
  tput bold
  tput setaf 2
  echo "DDOS Toolkit Protection cPanel"
  echo
  echo -e "Syntax: "
  echo -e "\t ddostoolkit.sh [-s|-u|-d|-i|-c|-h] \n"
  echo -e "Usage: "
  echo -e "\t ddostoolkit.sh -s hilmiafifi.com"
  echo -e "\t ddostoolkit.sh -u hilmiafifi.com"
  echo -e "\t ddostoolkit.sh -d hilmiafifi.com"
  echo -e "\t ddostoolkit.sh -i 123.123.123.123"
  echo -e "\t ddostoolkit.sh -c hilmiafifi.com \n"
  echo -e "Options: "
  echo -e "\t-s \t specify a Suspected Domains (then) swap/block"
  echo -e "\t-u \t specify a Suspected Domains (then) unswap/unblock"
  echo -e "\t-d \t specify a Suspected Domains (then) add into csf and scope-group"
  echo -e "\t-i \t specify a Suspected IP Addr (then) add into csf and scope-group"
  echo -e "\t-c \t specify a Suspected IP Addr (then) only check using tail."
  echo -e "\t-h \t print help message."
  echo
  tput sgr0
  exit 0
}

# main workhorse to swap each passed domains
ddoson () {

  # get some domain suspected
  suspect=$1	

  # make sure domains is valid
  if [ $suspect ]

  # then start doing work
  then

    # start blocking suspected domain
    echo -e "\n${YELLOW}Swapping domain : '$suspect' using SWAPIP ${EGREEN}";
    /usr/local/cpanel/bin/swapip $(hostname -i) 127.0.0.1 127.0.0.1 $suspect

    # checking log
    echo -e "\n${YELLOW}Checking NGINX access.log past 30 minutes${EGREEN}"
    rm -f type f /web/$suspect.log
    awk -vDate=`date -d'now-30 minutes' +[%d/%b/%Y:%H:%M:%S` '$5 > Date {print Date, $0}' /var/log/nginx/access.log | grep $suspect > /web/$suspect.log
    echo -e "Export to '/web/$suspect.log'"

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# second workhorse to unswap each passed domains
ddosoff () {

  # get some domain suspected
  suspect=$1

  # make sure domains is valid
  if [ $suspect ]

  # then start doing work
  then

    # start unblocking suspected domain
    echo -e "\n${YELLOW}Unswapping domain : '$suspect' using SWAPIP ${EGREEN}";
    /usr/local/cpanel/bin/swapip 127.0.0.1 $(hostname -i) $(hostname -i) $suspect

    # else, print helper
    else
      helper
      exit 1
    fi
  return 0
}

# third workhorse to grep and block ddos ip
ddosip () {

  # get some domain suspected
  suspect=$1

  # make sure domains is valid
  if [ $suspect ]

  # then start doing work
  then

    # start checking suspect ip addr
    echo -e "\n${GREEN}==| Adding IP domain:'{$suspect}' into csf and scope-group ${EGREEN}"
    tail /var/log/nginx/access.log -n 1000 | grep $suspect | awk '{print $1}' | sort | uniq -c | sort -hr | awk {'print $2'} | grep -Ev '(8.8.8.8|8.8.4.4)' > /web/$suspect.ip

    # start adding into csf
    for ip in $(cat /web/$suspect.ip)
      do
        echo -e "\n${YELLOW}CSF:deny${EGREEN}"
          csf -d $ip
      done

    # start adding imunify360
    for ip in $(cat /web/$suspect.ip)
      do
        echo -e "\n${CYAN}IMUNIFY:scope-group${EGREEN}"
          imunify360-agent blacklist ip add $ip --scope group
      done

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# forth workhorse to grep and block ddos ip
ddosipin () {

  # get some ip suspected
  ip=$1

  # make sure ip is valid
  if [ $ip ]

  # then start doing work
  then

    # start adding into csf and imunify360
    echo -e "\n${GREEN}==| Adding IP :'{$ip}' into csf and scope-group ${EGREEN}"

    # start adding into csf
    echo -e "\n${YELLOW}CSF:deny${EGREEN}"
    csf -d $ip

    # start adding into imunify360
    echo -e "\n${CYAN}IMUNIFY:scope-group${EGREEN}"
    imunify360-agent blacklist ip add $ip --scope group

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# fifth workhorse to check ip access domain suspected
ddosipcheck () {

  # get some domain suspected
  suspect=$1

  # make sure domains is valid
  if [ $suspect ]

  # then start doing work
  then

    # start check ip domain suspected
    echo -e "\n${GREEN}==| Check IP access domain:'{$suspect}' ${EGREEN}"
    tail /var/log/nginx/access.log -n 1000 | grep $suspect | awk '{print $1}' | sort | uniq -c | sort -hr | grep -Ev '(8.8.8.8|8.8.4.4)'

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# main case function, switches options passed to it
case "$1" in
    -h)
      helper
      ;;
    --help)
      helper
      ;;
    -v)
      verbose="-v"

case "$2" in
    -s)
      ddoson "$3"
      ;;
    -u)
      ddosoff "$3"
      ;;
    -d)
      ddosip "$3"
      ;;
    -i)
      ddosipin "$3"
      ;;
    -c)
      ddosipcheck "$3"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;

  esac
  ;;
    -s)
      ddoson "$2"
      ;;
    -u)
      ddosoff "$2"
      ;;
    -d)
      ddosip "$2"
      ;;
    -i)
      ddosipin "$2"
      ;;
    -c)
      ddosipcheck "$2"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;
esac
