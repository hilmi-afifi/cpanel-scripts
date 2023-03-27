#!/bin/bash

# Integration Link cPanel Tools
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
  echo "Integration Links cPanel Tools"
  echo
  echo -e "Syntax: "
  echo -e "\t integrationlink.sh [-c|-d|-h] \n"
  echo -e "Usage: "
  echo -e "\t integrationlink.sh -c hilmi"
  echo -e "\t integrationlink.sh -d hilmi \n"
  echo -e "Options: "
  echo -e "\t-c \t Check Integration Links"
  echo -e "\t-d \t Remove Integration Links"
  echo -e "\t-h \t print help message."
  echo
  tput sgr0
  exit 0
}

# main workhorse to check integration links
linkscheck () {

  # get some cpanel user
  user=$1

  # check user from trueuserdomains
  # make sure user is valid
  if ! grep -oP "\S+: $user$" /etc/trueuserdomains
  then
    tput bold
    tput setaf 1
    echo "Invalid cPanel account"
    tput sgr0
    exit 0
  fi

  # make sure user is not empty
  if [ -z $user ]
  then
    tput bold
    tput setaf 1
    echo "Need an account name!"
    tput sgr0
    helper

  # else, start doing work
  else

    # start checking some integration links
    echo -e "\n${CYAN}==| Checking some intregation links : '$user' ${EGREEN}"
    /usr/sbin/whmapi1 --output=jsonpretty list_integration_links user='$1' | jq '.data.links[].app' | sed 's/"//g'
    printf "\n"

    fi
  return 0
}

# second workhorse to remove integration links
linksdel () {

  # get some cpanel user
  user=$1

  # check user from trueuserdomains
  # make sure user is valid
  if ! grep -oP "\S+: $user$" /etc/trueuserdomains
  then
    tput bold
    tput setaf 1
    echo "Invalid cPanel account"
    tput sgr0
    exit 0
  fi

  # make sure user is not empty
  if [ -z $user ]
  then
    tput bold
    tput setaf 1
    echo "Need an account name!"
    tput sgr0
    helper

  # else, start doing work
  else

    # start removing some integration links
    echo -e "\n${CYAN}==| Remove some intregation links : '$user' ${EGREEN}"
    for app in $(/usr/sbin/whmapi1 --output=jsonpretty list_integration_links user='$1' | jq '.data.links[].app' | sed 's/"//g');
    do
      /usr/sbin/whmapi1 remove_integration_link user='$1' app="$app";
    done
    printf "\n"

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
      linkscheck "$3"
      ;;
    -d)
      linksdel "$3"
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
      linkscheck "$2"
      ;;
    -d)
      linksdel "$2"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;
esac
