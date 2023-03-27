#!/bin/bash

# Look Full Backup cPanel
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
  echo "Look Full Backup cPanel"
  echo
  echo -e "Syntax: "
  echo -e "\tlookfullbackup.sh [-u|-h] \n"
  echo -e "Usage: "
  echo -e "\tlookfullbackup.sh -u hilmi \n"
  echo -e "Options: "
  echo -e "\t-u \tLook Tar Backup."
  echo -e "\t-h \tprint this help."
  echo
  tput sgr0
  exit 0
}

# main workhorse to view and check backup each passed user
look_fullbackup() {

  # get some user
  user=$1

  # make sure user is valid
  if [ $user ]

  # then start doing work
  then

    # start checking addon
    echo -e "\n${YELLOW}==| Checking Addon on '$user' ${EGREEN}"
    tar -Oxf *$user.tar* *$user/addons | wc -l

    # start checking aliases
    echo -e "\n${GREEN}==| Checking Aliases on '$user' ${EGREEN}"
    tar -Oxf *$user.tar* *$user/pds | wc -l

    # start checking mysql
    echo -e "\n${BLUE}==| Checking MySQL on '$user' ${EGREEN}"
    tar -tf *$user.tar* *$user/mysql | grep '\.sql' | wc -l

    # start checking postgresql
    echo -e "\n${CYAN}==| Checking PostgreSQL on '$user' ${EGREEN}"
    tar -tf *$user.tar* *$user/psql | grep '\.tar' | wc -l

    # start checking email
    echo -e "\n${MAGENTA}==| Checking Email on '$user' ${EGREEN}"
    tar -Oxf *$user.tar* *$user/homedir/etc/*/passwd | wc -l

    # start checking nodejs
    echo -e "\n${GREEN}==| Checking Nodejs on '$user' ${EGREEN}"
    tar -Oxf *$user.tar* *$user/homedir/.cl.selector/node-selector.json | jq ".[].domain" | wc -l

    # start checking python
    echo -e "\n${BLUE}==| Checking Python on '$user' ${EGREEN}"
    tar -Oxf *$user.tar* *$user/homedir/.cl.selector/python-selector.json | jq ".[].domain" | wc -l

    # start checking ruby
    echo -e "\n${RED}==| Checking Ruby on '$user' ${EGREEN}"
    tar -tf *$user.tar* *$user/homedir/rubyvenv/ | awk -F/ '{if (NF<5) print }'
    echo

  # else, start doing work
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
    -u)
      look_fullbackup "$3"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;

  esac
  ;;
    -u)
      look_fullbackup "$2"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;
  esac
