#!/bin/bash

# DDOS IP
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
  echo "DDOS Protection with adding IP into CSF:deny & IMUNIFY:scope-group"
  echo
  echo -e "Syntax: "
  echo -e "\tddosip.sh [-d|-i|-c|-h] \n"
  echo -e "Usage: "
  echo -e "\tddosip.sh -d hilmiafifi.com"
  echo -e "\tddosip.sh -i 123.123.123.123"
  echo -e "\tddosip.sh -c hilmiafifi.com \n"
  echo -e "Options: "
  echo -e "\t-d \tspecify a Suspected Domains (then) add into csf and scope-group"
  echo -e "\t-i \tspecify a Suspected IP Addr (then) add into csf and scope-group"
  echo -e "\t-c \tspecify a Suspected IP Addr (then) only check using tail."
  echo -e "\t-h \tprint help message."
  echo
  tput sgr0
  exit 0
}

# main workhorse to grep and block ddos ip
ddosip () {

  # get some domain suspected
  suspect=$1

  # make sure domains is valid
  if [ $suspect ]

  # then start doing work
  then

    # start adding into csf and scope-group
    echo -e "\n${GREEN}==| Adding IP domain:'{$suspect}' into csf and scope-group ${EGREEN}"
    tail /var/log/nginx/access.log -n 1000 | grep $suspect | awk '{print $1}' | sort | uniq -c | sort -hr | awk {'print $2'} | grep -Ev '(8.8.8.8|8.8.4.4)' > /web/$suspect.ip

    for ip in $(cat /web/$suspect.ip)
      do
        echo -e "\n${YELLOW}CSF:deny${EGREEN}"
          csf -d $ip
      done

    # start adding into csf and scope-group
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

# second workhorse to grep and block ddos ip
ddosipin () {

  # get some ip suspected
  ip=$1

  # make sure ip is valid
  if [ $ip ]

  # then start doing work
  then

    # start adding into scope-group
    echo -e "\n${GREEN}==| Adding IP :'{$ip}' into csf and scope-group ${EGREEN}"

    echo -e "\n${YELLOW}CSF:deny${EGREEN}"
    csf -d $ip

    echo -e "\n${CYAN}IMUNIFY:scope-group${EGREEN}"
    imunify360-agent blacklist ip add $ip --scope group

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# third workhorse to check ip access domain suspected
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
