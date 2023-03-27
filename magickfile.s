#!/bin/bash

# Magick File Delete
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
  echo "Deleting Temporary File Magick User"
  echo
  echo -e "Syntax: "
  echo -e "\t magickfile.sh [-u|-h] \n"
  echo -e "Usage: "
  echo -e "\t magickfile.sh -u hilmi \n"
  echo -e "Options: "
  echo -e "\t-u \t specify a cPanel account."
  echo -e "\t-h \t print this help."
  echo
  tput sgr0
  exit 0
}

# main workhorse to finding magick file each passed user
magick_file() {

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

    # list directory contain magick file before deletion
    echo -e "\n${GREEN}==| Checking some file Magick : '$user' ${EGREEN}"
    ls -lah /home/$user/.cagefs/tmp/

    # find and delete file magick
    find /home/$user*/.cagefs/tmp -type f -name 'magick-*' -delete

    # list directory contain magick file after deletion
    echo -e "\n${GREEN}==| Here's Result! ${EGREEN}"
    ls -lah /home/$user/.cagefs/tmp/
    printf "\n"

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
    -u)
      magick_file "$3"
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
      magick_file "$2"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;
  esac
