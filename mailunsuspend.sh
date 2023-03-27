#!/bin/bash

# Unsuspend Specify Email
# (c) 2022 Hilmi

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

# check valid user
username=`grep $(echo $1 | cut -d@ -f2) /etc/userdomains | cut -d' ' -f2 | head -1`

# unsuspend incoming email
echo -e "\n${YELLOW}Unsuspend Incoming : '$1' ${EGREEN}";
/usr/bin/uapi --output=jsonpretty --user=$username Email unsuspend_incoming email=$1
echo

# unsuspend outgoing email
echo -e "\n${YELLOW}Unsuspend Outgoing : '$1' ${EGREEN}";
/usr/bin/uapi --output=jsonpretty --user=$username Email unsuspend_outgoing email=$1
echo
