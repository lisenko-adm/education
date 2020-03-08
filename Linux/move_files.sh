#!/bin/bash
echo 0= $0
SCRIPTDIR=$(dirname "$0")
echo scriptdir= $SCRIPTDIR
CONFIGFILE=$SCRIPTDIR/cfg_move_files.conf
echo configfile= $CONFIGFILE
#get env from config file
while read LINE
  do
      VARNAME=$(echo $LINE | sed -e 's/\=.*//g')
      VARVALUE=$(echo $LINE | sed -e 's/.*\=//g')
      export $VARNAME=$VARVALUE
  done < $CONFIGFILE
echo $SOURCEDIR
echo $TARGETDIR
echo $LOGFILENAME

if [ -d $SOURCEDIR ]
  then
    echo $SOURCEDIR ok
  else
    echo ERROR: $SOURCEDIR can not be used; exit 1
fi
if [ -d $TARGETDIR ]
  then
    echo $TARGETDIR ok
  else
    echo ERROR: $TARGETDIR can not be used; exit 1
fi
touch $LOGFILENAME
if [ -w $LOGFILENAME ]
then
  echo "$LOGFILENAME is ok"
else
  echo "ERROR: $LOGFILENAME can't be used"
  exit 1
fi
find $SOURCEDIR -maxdepth 1 -type f -not -name "*.locked" |
while IFS= read FILENAME; do
  if [ -w $FILENAME ]
  then
    if ! [ -e $FILENAME.locked ]
    then
      touch $FILENAME.locked 2>&1
      FIRSTLINE=$(head -n 1 $FILENAME)
      LASTLINE=$(tail -n 1 $FILENAME)
      REGEXPUUID="^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
      if [[ $LASTLINE =~ $REGEXPUUID ]]
      then
        NAMEOBJECT=$(echo $FIRSTLINE | awk '{print $1}')
        TIMEOBJECT=$(echo $FIRSTLINE | awk '{print $2 "-" $3}'  | sed 's/:/-/g')
        #дата получения файла=дата последнего изменения
        FILEGETTIME=$(date -r $FILENAME +"%Y-%m-%d-%H-%M-%S" 2>&1 )
        NEWNAME=$NAMEOBJECT"_"$TIMEOBJECT"_"$FILEGETTIME
        mv $FILENAME $TARGETDIR/$NEWNAME 2>&1 && echo MOVED $FILENAME from $SOURCEDIR to $TARGETDIR with name $NEWNAME >> $LOGFILENAME
        rm $FILENAME.locked 2>&1
      else
        #echo BAD UUID: $LASTLINE
        rm $FILENAME.locked 2>&1
      fi
    else
      echo SKIPPED: File $FILENAME locked and can not be moved now
      continue
    fi
  else
    echo ERROR: $FILENAME not moved, please check permissons.
  fi
done
