#!/bin/bash

# Check Backup
# (c) 2023 HilmiNesia

# set verbose to null
verbose=""

GREEN=$(tput bold; tput setaf 2)
EGREEN=$(tput sgr0)
YELLOW=$(tput bold; tput setaf 3)
BLACK=$(tput bold; tput setaf 0)
RED=$(tput bold; tput setaf 1)
BLUE=$(tput bold; tput setaf 4)
MAGENTA=$(tput bold; tput setaf 5)
CYAN=$(tput bold; tput setaf 6)
WHITE=$(tput bold; tput setaf 7)

# print help message
helper() {
  tput bold
  tput setaf 2
  echo "Finding Location Backup User"
  echo
  echo -e "Syntax: "
  echo -e "\tcheckbackup.sh [-u|-s|-h] \n"
  echo -e "Usage: "
  echo -e "\tcheckbackup.sh -u hilmi \n"
  echo -e "Options: "
  echo -e "\t-u \tspecify a cPanel account."
  echo -e "\t-s \tshow backup inside."
  echo -e "\t-h \tprint this help."
  echo
  tput sgr0
  exit 0
}

# main workhorse to finding backup each passed user
find_backup() {

  # get some cpanel user
  user=$1
  backup=$(find /backup /web /storage/drive -type f -name "*$user*.tar" -o -name "*$user*.tar.gz" | xargs -r du -bh --time | awk '{print $2, $3 "\t" $1 "\t" $4}' | sort -hr;)

  if [ ! -z $user ]

  # then, start doing work
  then

    # start finding backup
    echo -e "\n${GREEN}==| Result Backup user : '$user' ${EGREEN}"
    printf "\n"

    if [[ ! -z $backup ]]
    then

      # proccesing find backup user
      echo -e "$backup"
      printf "\n"

      # save the process
      read -p "${YELLOW}Do you want to save backup to /storage/drive ? ${EGREEN} ${GREEN}[y/n] : ${EGREEN} " yn
      if [[ $yn = y ]]; then

          read -p "${YELLOW}Which row do you want to save : ${EGREEN}" number
          printf "\n"
          echo -e "${GREEN}Saving the backup in progress${EGREEN}"
          printf "\n"
          locationbackup=$(echo "$backup" | sed -n "${number}p" | awk '{print $4}')

          # rsync file to backup
          rsync -Paz $locationbackup /storage/drive/

          cd /storage/drive/

          printf "\n"
          echo -e "${GREEN}Viewing inside backup file${EGREEN}"
          printf "\n"

          # check backup start
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

          # check backup stop

      else
          exit 1
      fi

    else
      echo -e "Sorry, backup not found. You're not lucky at this moment. :("
      printf "\n"
      exit 1
    fi

  # else, print helper
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
    -u)
      find_backup "$3"
      ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        echo ""
        helper
      ;;

  esac
  ;;
    -u)
      find_backup "$2"
    ;;
    *)
      tput bold
      tput setaf 1
        echo "Invalid Option!"
        echo ""
        helper
      ;;
  esac
