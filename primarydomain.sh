#!/bin/bash

# Primary Domain Change
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
  echo "Check & Change Primary Domain"
  echo
  echo -e "Syntax: "
  echo -e "\t primarydomain.sh [-d|-c|-h] \n"
  echo -e "Usage: "
  echo -e "\t primarydomain.sh -d user domain.com"
  echo -e "\t primarydomain.sh -c user \n"
  echo -e "Options: "
  echo -e "\t-d \t Primary Domain Change."
  echo -e "\t-c \t Primary Domain Check."
  echo -e "\t-h \t print this help."
  echo
  tput sgr0
  exit 0
}

# main workhorse to change domain each passed user
domain_change() {

  # get some cpanel user
  user=$1

  # input new domain
  domain=$2

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

  # make sure user & domain not empty
  if [[ -z $user && -z $domain ]]
  then
    tput bold
    tput setaf 1
    echo "Need an account name!"
    tput sgr0
    helper

  # else, start doing work
  else

    # start change current primary domain
    echo -e "\n${GREEN}==| Change Primary Domain '$user' ${EGREEN}"
    /usr/sbin/whmapi1 --output=jsonpretty modifyacct user="$user" domain="$domain" | jq '.metadata | {result: .result, reason: .reason}'

    # start check current primary domain
    echo -e "\n${GREEN}==| Current Primary Domain '$user' ${EGREEN}"
    grep -oP "\S+: $user" /etc/trueuserdomains | cut -d ":" -f1
    echo

    fi
  return 0
}

# second workhorse to check domain each passed user
domain_check() {

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
    helper

  # else, start doing work
  else

    # start check current primary domain
    echo -e "\n${GREEN}==| Current Primary Domain '$user' ${EGREEN}"
    grep -oP "\S+: $user" /etc/trueuserdomains | cut -d ":" -f1
    echo

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
      domain_change "$3" "$4"
      ;;
    -c)
      domain_check "$3"
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
      domain_change "$2" "$3"
      ;;
    -c)
      domain_check "$2"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;
  esac
