#!/bin/bash

#get env from config file
while read LINE
  do
      VARNAME=$(echo $LINE | sed -e 's/\=.*//g')
      VARVALUE=$(echo $LINE | sed -e 's/.*\=//g')
      export $VARNAME=$VARVALUE
  done < cfg_move_files.conf

if [ -d $SOURCEDIR ]
  then
    echo $SOURCEDIR ok
  else
    echo ERROR: $SOURCEDIR can not be used; exit
fi
if [ -d $TARGETDIR ]
  then
    echo $TARGETDIR ok
  else
    echo ERROR: $TARGETDIR can not be used; exit
fi
touch $LOGFILENAME
if [ -w $LOGFILENAME ]
then
  echo "$LOGFILENAME is ok"
else
  echo "ERROR: $LOGFILENAME can't be used"
  exit
fi
find $SOURCEDIR -maxdepth 1 -type f -not -name "*.locked" |
while IFS= read FILENAME; do
  if [ -w $FILENAME ]
  then
    if ! [ -e $FILENAME.locked ]
    then
      touch $FILENAME.locked
      FIRSTLINE=$(head -n 1 $FILENAME)
      LASTLINE=$(tail -n 1 $FILENAME)
      REGEXPUUID="^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
      if [[ $LASTLINE =~ $REGEXPUUID ]]
      then
        NAMEOBJECT=$(echo $FIRSTLINE | awk '{print $1}')
        TIMEOBJECT=$(echo $FIRSTLINE | awk '{print $2 "-" $3}'  | sed 's/:/-/g')
        #дата получения файла=дата последнего изменения
        FILEGETTIME=$(date -r $FILENAME +"%Y-%m-%d-%H-%M-%S")
        NEWNAME=$NAMEOBJECT"_"$TIMEOBJECT"_"$FILEGETTIME
        mv $FILENAME $TARGETDIR/$NEWNAME && echo MOVED $FILENAME from $SOURCEDIR to $TARGETDIR with name $NEWNAME >> $LOGFILENAME
        rm $FILENAME.locked
      else
        #echo BAD UUID: $LASTLINE
        rm $FILENAME.locked
      fi
    else
      echo SKIPPED: File $FILENAME locked and can not be moved now
      continue
    fi
  else
    echo ERROR: $FILENAME not moved, please check permissons.
  fi
done
