#!/bin/bash

# MySQL Toolkit
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
  echo "MySQL Abuse Handler"
  echo
  echo -e "Syntax: "
  echo -e "\t mysqltoolkit.sh [-a|-m|-l|-e|-c|-s|-u|-h] \n"
  echo -e "Usage: "
  echo -e "\t mysqltoolkit.sh -a"
  echo -e "\t mysqltoolkit.sh -m hilmi"
  echo -e "\t mysqltoolkit.sh -l hilmi_userdb"
  echo -e "\t mysqltoolkit.sh -e hilmi_userdb"
  echo -e "\t mysqltoolkit.sh -c hilmi_userdb"
  echo -e "\t mysqltoolkit.sh -s hilmi"
  echo -e "\t mysqltoolkit.sh -u hilmi \n"
  echo -e "Options: "
  echo -e "\t-a \t MySQL (do) show all processlist."
  echo -e "\t-m \t MySQL (do) show user processlist."
  echo -e "\t-l \t MySQL (do) database max_user_connections set limit to 7."
  echo -e "\t-e \t MySQL (do) database max_user_connections set unlimit to 0."
  echo -e "\t-c \t MySQL (do) database max_user_connections check."
  echo -e "\t-s \t MySQL (do) suspend mysql user."
  echo -e "\t-u \t MySQL (do) unsuspend mysql user."
  echo -e "\t-h \t print help message."
  echo
  tput sgr0
  exit 0
}

# main workhorse show processlist
mysqlprocall () {

    # start show all MySQL processlist
    echo -e "\n${GREEN}==| Show All MySQL Processlist${EGREEN}"
    mysql -e "show processlist;"
    echo

}

# second workhorse show $user MySQL processlist
mysqlprocuser () {

  # get some user suspected
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

  # make user not empty
  if [ -z $user ]
  then
    tput bold
    tput setaf 1
    echo "Need an account name!"
    tput sgr0
    helper

  # else, start doing work
  else

    # start show processlist
    echo -e "\n${GREEN}==| Show $user MySQL Processlist${EGREEN}"
    mysql -e "show processlist;" | grep $user
    echo

    fi
  return 0
}

# third workhorse limit max_user_connections to 7
mysqllimit () {

  # get some user suspected
  userdb=$1
  hostname=$(mysql -e "select @@hostname" | grep -v hostname)

  # make sure user is valid
  if [ $userdb ]

  # then start doing work
  then

    # start limit max_user_connetions
    echo -e "\n${GREEN}==| Limit max_user_connections:'{$userdb}' ${EGREEN}"
    mysql -e "ALTER USER '$userdb'@'$hostname' WITH max_user_connections 7;"
    mysql -e "SELECT max_user_connections FROM mysql.user WHERE user = '$userdb';"
    echo

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# fourth workhorse limit max_user_connections to 7
mysqlunlimit () {

  # get some user suspected
  userdb=$1
  hostname=$(mysql -e "select @@hostname" | grep -v hostname)

  # make sure user is valid
  if [ $userdb ]

  # then start doing work
  then

    # start limit max_user_connetions
    echo -e "\n${GREEN}==| Unlimit max_user_connections:'{$userdb}' ${EGREEN}"
    mysql -e "ALTER USER '$userdb'@'$hostname' WITH max_user_connections 0;"
    mysql -e "SELECT max_user_connections FROM mysql.user WHERE user = '$userdb';"
    echo

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# fifth workhorse check max_user_connections
mysqllimitcheck () {

  # get some user suspected
  userdb=$1

  # make sure user is valid
  if [ $userdb ]

  # then start doing work
  then

    # start check max_user_connections
    echo -e "\n${GREEN}==| Check max_user_connections:'{$userdb}' ${EGREEN}"
    mysql -e "SELECT max_user_connections FROM mysql.user WHERE user = '$userdb';"
    echo

    # else print helper
    else
      helper
      exit 1
    fi
  return 0
}

# sixth suspend mysql user databases
mysqlsuspend () {

  # get some user suspected
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

  # make user not empty
  if [ -z $user ]
  then
    tput bold
    tput setaf 1
    echo "Need an account name!"
    tput sgr0
    helper

  # else, start doing work
  else

    # start suspend mysql user databases
    echo -e "\n${GREEN}==| Suspend MySQL user:'{$user}' ${EGREEN}"
    /scripts/suspendmysqlusers $user
    echo

    fi
  return 0
}

# seventh unsuspend mysql user databases
mysqlunsuspend () {

  # get some user suspected
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

  # make user not empty
  if [ -z $user ]
  then
    tput bold
    tput setaf 1
    echo "Need an account name!"
    tput sgr0
    helper

  # else, start doing work
  else

    # start unsuspend mysql user databases
    echo -e "\n${GREEN}==| Unsuspend MySQL user:'{$user}' ${EGREEN}"
    /scripts/unsuspendmysqlusers $user
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
    -a)
      mysqlprocall "$3"
      ;;
    -m)
      mysqlprocuser "$3"
      ;;
    -l)
      mysqllimit "$3"
      ;;
    -e)
      mysqlunlimit "$3"
      ;;
    -c)
      mysqllimitcheck "$3"
      ;;
    -s)
      mysqlsuspend "$3"
      ;;
    -u)
      mysqlunsuspend "$3"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;

  esac
  ;;
    -a)
      mysqlprocall "$2"
      ;;
    -m)
      mysqlprocuser "$2"
      ;;
    -l)
      mysqllimit "$2"
      ;;
    -e)
      mysqlunlimit "$2"
      ;;
    -c)
      mysqllimitcheck "$2"
      ;;
    -s)
      mysqlsuspend "$2"
      ;;
    -u)
      mysqlunsuspend "$2"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        helper
      ;;
esac
