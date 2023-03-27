#!/bin/bash

# Tools Count & List Checker cPanel
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
  echo "Tools Count & List Checker cPanel"
  echo
  echo -e "Syntax: "
  echo -e "\tlistuserdata.sh [-c|-l|-f|-h] \n"
  echo -e "Usage: "
  echo -e "\tlistuserdata.sh -c hilmi"
  echo -e "\tlistuserdata.sh -l hilmi"
  echo -e "\tlistuserdata.sh -f hilmi"
  echo -e "\tlistuserdata.sh -h \n"
  echo -e "Options: "
  echo -e "\t-c \tspecify a cPanel Username (do) count"
  echo -e "\t-l \tspecify a cPanel Username (do) list"
  echo -e "\t-f \tspecify a cPanel Username (do) count & list"
  echo -e "\t-h \tprint help message."
  echo
  tput sgr0
  exit 0
}

# main workhorse to count each passed user
count_data () {

  # get some user cpanel
  user=$1

  # make sure user is valid
  if [ $user ]

  # then start doing work
  then

    # start tools count

        # Disk Usage Check :
        echo -e "\n${GREEN}Disk Usage Check : '$1' ${EGREEN}";
        du -sh /home/$1
        echo

        # Addon Count
        echo -e "\n${YELLOW}Addon Count : '$1' ${EGREEN}";
        /usr/bin/uapi --output=jsonpretty --user=$1 DomainInfo list_domains | jq '.result.data.addon_domains[]' | wc -l
        echo

        # Email Count :
        echo -e "\n${MAGENTA}Email Count : '$1' ${EGREEN}";
        /usr/sbin/whmapi1 --output=jsonpretty list_pops_for user=$1 | jq '.data.pops[]' | wc -l
        echo

        # MySQL Count :
        echo -e "\n${BLUE}MySQL Count : '$1' ${EGREEN}";
        /usr/sbin/whmapi1 --output=jsonpretty list_mysql_databases_and_users user=$1 | jq '.data.mysql_databases[][]' | wc -l
        echo

        # PostgreSQL Count :
        echo -e "\n${CYAN}PostgreSQL Count : '$1' ${EGREEN}";
        /usr/bin/uapi --output=jsonpretty --user=$1 Postgresql list_databases | jq '.result.data[].database' | wc -l
        echo

        # Nodejs Ghost Count :
        echo -e "\n${GREEN}Nodejs Ghost Count : '$1' ${EGREEN}";
        /usr/sbin/cloudlinux-selector get --json --interpreter=nodejs --user=$1 | jq '.' | grep domain | sed s/'\s'//g | wc -l
        echo

        # Python Django Count :
        echo -e "\n${BLUE}Python Django Count : '$1' ${EGREEN}";
        /usr/sbin/cloudlinux-selector get --json --interpreter=python --user=$1 | jq '.' | grep domain | sed s/'\s'//g | wc -l
        echo

        # Ruby Count :
        echo -e "\n${RED}Ruby Count : '$1' ${EGREEN}";
        /usr/bin/selectorctl -i ruby -s -u "$1" --json | jq '.data[].domain' | wc -l
        echo

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# second workhorse to list each passed user
list_data () {

  # get some user cpanel
  user=$1

  # make sure user is valid
  if [ $user ]

  # then start doing work
  then

    # start tools list

        # Disk Usage Check :
        echo -e "\n${GREEN}Disk Usage Check : '$1' ${EGREEN}";
        du -sh /home/$1
        echo

        # Addon List :
        echo -e "\n${YELLOW}Addon List : '$1' ${EGREEN}";
        /usr/bin/uapi --output=jsonpretty --user=$1 DomainInfo list_domains | jq '.result.data | {Addon: .addon_domains}'
        echo

        # Email List :
        echo -e "\n${MAGENTA}Email List : '$1' ${EGREEN}";
        /usr/sbin/whmapi1 --output=jsonpretty list_pops_for user=$1 | jq '.data | {List_Emails : .pops}'
        echo

        # MySQL List :
        echo -e "\n${BLUE}MySQL List : '$1' ${EGREEN}";
        /usr/sbin/whmapi1 --output=jsonpretty list_mysql_databases_and_users user=$1 | jq '.data.mysql_databases[][]'
        echo

        # PostgreSQL List :
        echo -e "\n${CYAN}PostgreSQL List : '$1' ${EGREEN}";
        /usr/bin/uapi --output=jsonpretty --user=$1 Postgresql list_databases | jq '.result.data[].database'
        echo

        # Nodejs Ghost List :
        echo -e "\n${GREEN}Nodejs Ghost List : '$1' ${EGREEN}";
        /usr/sbin/cloudlinux-selector get --json --interpreter=nodejs --user=$1 | jq '.' | grep domain | sed s/'\s'//g
        echo

        # Python Django List :
        echo -e "\n${BLUE}Python Django Count : '$1' ${EGREEN}";
        /usr/sbin/cloudlinux-selector get --json --interpreter=python --user=$1 | jq '.' | grep domain | sed s/'\s'//g
        echo

        # Ruby List :
        echo -e "\n${RED}Ruby List : '$1' ${EGREEN}";
        /usr/bin/selectorctl -i ruby -s -u "$1" --json | jq '.data[].domain'
        echo

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# third workhorse to count & list each passed user
count_list_data () {

  # get some user cpanel
  user=$1

  # make sure user is valid
  if [ $user ]

  # then start doing work
  then

    # start tools count & list

        # Disk Usage Check :
        echo -e "\n${GREEN}Disk Usage Check : '$1' ${EGREEN}";
        du -sh /home/$1
        echo

        # Addon Count
        echo -e "\n${YELLOW}Addon Count : '$1' ${EGREEN}";
        /usr/bin/uapi --output=jsonpretty --user=$1 DomainInfo list_domains | jq '.result.data.addon_domains[]' | wc -l
        echo

        # Addon List :
        echo -e "\n${YELLOW}Addon List : '$1' ${EGREEN}";
        /usr/bin/uapi --output=jsonpretty --user=$1 DomainInfo list_domains | jq '.result.data | {Addon: .addon_domains}'
        echo

        # Email Count :
        echo -e "\n${MAGENTA}Email Count : '$1' ${EGREEN}";
        /usr/sbin/whmapi1 --output=jsonpretty list_pops_for user=$1 | jq '.data.pops[]' | wc -l
        echo

        # Email List :
        echo -e "\n${MAGENTA}Email List : '$1' ${EGREEN}";
        /usr/sbin/whmapi1 --output=jsonpretty list_pops_for user=$1 | jq '.data | {List_Emails : .pops}'
        echo

        # MySQL Count :
        echo -e "\n${BLUE}MySQL Count : '$1' ${EGREEN}";
        /usr/sbin/whmapi1 --output=jsonpretty list_mysql_databases_and_users user=$1 | jq '.data.mysql_databases[][]' | wc -l
        echo

        # MySQL List :
        echo -e "\n${BLUE}MySQL List : '$1' ${EGREEN}";
        /usr/sbin/whmapi1 --output=jsonpretty list_mysql_databases_and_users user=$1 | jq '.data.mysql_databases[][]'
        echo

        # PostgreSQL Count :
        echo -e "\n${CYAN}PostgreSQL Count : '$1' ${EGREEN}";
        /usr/bin/uapi --output=jsonpretty --user=$1 Postgresql list_databases | jq '.result.data[].database' | wc -l
        echo

        # PostgreSQL List :
        echo -e "\n${CYAN}PostgreSQL List : '$1' ${EGREEN}";
        /usr/bin/uapi --output=jsonpretty --user=$1 Postgresql list_databases | jq '.result.data[].database'
        echo

        # Nodejs Ghost Count :
        echo -e "\n${GREEN}Nodejs Ghost Count : '$1' ${EGREEN}";
        /usr/sbin/cloudlinux-selector get --json --interpreter=nodejs --user=$1 | jq '.' | grep domain | sed s/'\s'//g | wc -l
        echo

        # Nodejs Ghost List :
        echo -e "\n${GREEN}Nodejs Ghost List : '$1' ${EGREEN}";
        /usr/sbin/cloudlinux-selector get --json --interpreter=nodejs --user=$1 | jq '.' | grep domain | sed s/'\s'//g
        echo

        # Python Django Count :
        echo -e "\n${BLUE}Python Django Count : '$1' ${EGREEN}";
        /usr/sbin/cloudlinux-selector get --json --interpreter=python --user=$1 | jq '.' | grep domain | sed s/'\s'//g | wc -l
        echo

        # Python Django List :
        echo -e "\n${BLUE}Python Django Count : '$1' ${EGREEN}";
        /usr/sbin/cloudlinux-selector get --json --interpreter=python --user=$1 | jq '.' | grep domain | sed s/'\s'//g
        echo

        # Ruby Count :
        echo -e "\n${RED}Ruby Count : '$1' ${EGREEN}";
        /usr/bin/selectorctl -i ruby -s -u "$1" --json | jq '.data[].domain' | wc -l
        echo

        # Ruby List :
        echo -e "\n${RED}Ruby List : '$1' ${EGREEN}";
        /usr/bin/selectorctl -i ruby -s -u "$1" --json | jq '.data[].domain'
        echo

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# case function, switches options passed to it
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
    -c)
      count_data "$3"
      ;;
    -l)
      list_data "$3"
      ;;
    -f)
      count_list_data "$3"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;

  esac
  ;;
    -c)
      count_data "$2"
      ;;
    -l)
      list_data "$2"
      ;;
    -f)
      count_list_data "$2"
      ;;
    *)
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;
esac
