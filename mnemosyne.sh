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
   -s      File or folder to backup
   -d      Backup destination directory
   -c      Add a crontab rule to this command
   -a      Archive mode
   -u      Update mode
   -r      Recursive mode
   -l      Copy symlinks as symlinks
   -p      Preserve permissions
   -g      Preserve groups
   -t      Preserve modification times
   -o      Preserve owner
   -v      Verbose
   -I      Don't skip files that match size and time
   -X      Preserve extended attributes
   -O      Omit directories from -t
EOF
}

FULLOPTIONS="-"
SOURCE=
DESTINATION=
CRONTAB=
COMMAND=
ARCHIVE=0
UPDATE=0
RECURSIVE=0
IGNORETIMES=0
SYMLINKS=0
PERMISSION=0
GROUP=0
MODIFICATION=0
OWNER=0
OMIT_DIRECTORIES_T=0
EXTENDEDATTRS=0

while getopts “IOXhaurlpgtos:d:c:v” OPTION
do
     case $OPTION in
         h)
             usage
             exit
             ;;
         s)
             SOURCE=$OPTARG
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
         l)
             SYMLINKS=1
             ;; 
         p)
             PERMISSION=1
             ;; 
         g)
             GROUP=1
             ;;
         t)
             MODIFICATION=1
             ;;  
         o)
             OWNER=1
             ;; 
         I)
             IGNORETIMES=1
             ;; 
         O)
             OMIT_DIRECTORIES_T=1
             ;; 
         X)
             EXTENDEDATTRS=1
             ;; 
         ?)
             usage
             exit
             ;;
     esac
done

if [ -z "$DESTINATION" ] || [ -z "$SOURCE" ] || [ -z "$CRONTAB" ]; then
    usage
    exit 1
fi

if [ ! -d "$SOURCE" ] && [ ! -f "$SOURCE" ]; then
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
if [ "$IGNORETIMES" -eq 1 ]; then
  FULLOPTIONS+="I"
fi 
if [ "$SYMLINKS" -eq 1 ]; then
  FULLOPTIONS+="l"
fi 
if [ "$PERMISSION" -eq 1 ]; then
  FULLOPTIONS+="p"
fi 
if [ "$GROUP" -eq 1 ]; then
  FULLOPTIONS+="g"
fi 
if [ "$MODIFICATION" -eq 1 ]; then
  FULLOPTIONS+="t"
fi 
if [ "$OWNER" -eq 1 ]; then
  FULLOPTIONS+="o"
fi 
if [ "$EXTENDEDATTRS" -eq 1 ]; then
  FULLOPTIONS+="X"
fi 
if [ "$MODIFICATION" -eq 1 ] && [ "$OMIT_DIRECTORIES_T" -eq 1 ]; then
  FULLOPTIONS+="O"
fi 

if [ "$FULLOPTIONS" = "-" ]; then
  COMMAND="$CRONTAB rsync -r $SOURCE $DESTINATION"
  crontab -l > mycron 2> /dev/null
  echo "$COMMAND" >> mycron
  crontab mycron
  rm mycron 
else
  COMMAND="$CRONTAB rsync $FULLOPTIONS $SOURCE $DESTINATION"
  crontab -l > mycron 2> /dev/null
  echo "$COMMAND" >> mycron
  crontab mycron
  rm mycron 
fi
