#!/bin/bash

#----------------------------------------------------------------------------------------
# Dev: Peter Ton
# Created: 8 Sep 2017
# Description: This script adds the necessary entries into the hosts file for devboxes
# This should be run with sudo.
#----------------------------------------------------------------------------------------

# CHANGE THESE VALUES:
NA=192.168.101.231
EU=192.168.101.240


# Update hosts file
echo -e "$NA\tdevbox-na-me" >> /etc/hosts
echo -e "$EU\tdevbox-eu-me" >> /etc/hosts

exit 0
