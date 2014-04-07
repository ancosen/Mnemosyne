#!/bin/bash

# Mnemosyne is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Mnemosyne is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Mnemosyne.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2014 Andrea Cosentino and contributors

usage()
{
cat << EOF
usage: $0 options

Backup folder or file in a specific path with associated crontab rule

OPTIONS:
   -h      Show this message
   -o      File or folder to backup
   -d      Backup destination directory
   -c      Add a crontab rule to this command
   -a      Use Rsync in archive mode
   -u      Use Rsync in update mode
   -r      Use Rsync in recursive mode
   -v      Verbose
EOF
}

FULLOPTIONS="-"
ORIGIN=
DESTINATION=
CRONTAB=
COMMAND=
ARCHIVE=0
UPDATE=0
RECURSIVE=0

while getopts “hauro:d:c:v” OPTION
do
     case $OPTION in
         h)
             usage
             exit
             ;;
         o)
             ORIGIN=$OPTARG
             ;;
         d)
             DESTINATION=$OPTARG
             ;;
         c)
             CRONTAB=$OPTARG
             ;;
         v)
             set -x
             ;;
         a)
             ARCHIVE=1
             ;;
         u)
             UPDATE=1
             ;;
         r)
             RECURSIVE=1
             ;; 
         ?)
             usage
             exit
             ;;
     esac
done

if [ -z "$DESTINATION" ] || [ -z "$ORIGIN" ] || [ -z "$CRONTAB" ]; then
    usage
    exit 1
fi

if [ ! -d "$ORIGIN" ] && [ ! -f "$ORIGIN" ]; then
  echo "File or directory to copy doesn't exist"
  exit 1
fi

if [ ! -d "$DESTINATION" ]; then
  echo "Creating destination directory"
  mkdir $DESTINATION 
else
  echo "Destination directory already exists"
fi

if [ "$ARCHIVE" -eq 1 ]; then
  FULLOPTIONS+="a"
fi 
if [ "$UPDATE" -eq 1 ]; then
  FULLOPTIONS+="u"
fi
if [ "$RECURSIVE" -eq 1 ]; then
  FULLOPTIONS+="r"
fi 

if [ "$FULLOPTIONS" = "-" ]; then
  COMMAND="$CRONTAB rsync -r $ORIGIN $DESTINATION"
  crontab -l > mycron 2> /dev/null
  echo "$COMMAND" >> mycron
  crontab mycron
  rm mycron 
else
  COMMAND="$CRONTAB rsync $FULLOPTIONS $ORIGIN $DESTINATION"
  crontab -l > mycron 2> /dev/null
  echo "$COMMAND" >> mycron
  crontab mycron
  rm mycron 
fi
