#!/bin/sh

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
   -v      Verbose
EOF
}

ORIGIN=
DESTINATION=
CRONTAB=
COMMAND=

while getopts “ho:d:c:v” OPTION
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
fi

  COMMAND="$CRONTAB cp -r $ORIGIN $DESTINATION"
  crontab -l > mycron 2> /dev/null
  echo "$COMMAND" >> mycron
  crontab mycron
  rm mycron
