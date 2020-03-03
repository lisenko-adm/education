#!/bin/bash
function cfg_generate {

# get keys
while [ -n "$1" ]
do
case "$1" in
-t|--template) if [[ $2 =~ ^$|^-r$|^--result$ ]]
               then
                 echo "ERROR: template file needed"
                 exit 1
               else
                 templatefile="$2"
                 echo "template file: $templatefile"
                 shift
               fi ;;
-r|--result)  if [[ $2 =~ ^$|^-t$|^--template$ ]]
               then
                 echo "ERROR: result key needed"
                 exit 1
               else
                 resultfile="$2"
                 echo "result file: $resultfile"
                 shift
               fi ;;
*) echo "ERROR: incorrect input, use -t/--template and -r/--result keys only"
               exit 1
esac
shift
done

[ -z $templatefile ] && echo "ERROR: missed -t key" && exit 1

[ -z $resultfile ] && echo "ERROR: missed -r key" && exit 1

echo "keys check passed"

# check keys
if [ -r $templatefile ]
then
  echo "$templatefile exist and readble"
else
  echo "ERROR: $templatefile not exist or not readble"
  exit 1
fi

if [ -s $resultfile ]
then
  echo "ERROR: $resultfile exist and not empty"
  exit 1
elif touch $resultfile
then
  echo "$resultfile is ok"
else
  echo "ERROR: $resultfile can't be used"
  exit 1
fi
echo  "file check passed"

while read LINE
     do
REGEXP="-<-.*->-"
      while [[ $LINE =~ $REGEXP ]]
       do
         FVAR=$(echo "${LINE}" | sed -n 's/\(.*\)\(-<-[a-zA-Z0-9_]*->-\)\(.*\)/\1/p' )
         SVAR=$(echo "${LINE}" | sed -e 's/\(.*\)\(-<-[a-zA-Z0-9_]*->-\)\(.*\)/\2/1' -e 's/^.*-<-//1' -e 's/->-.*//1')
         TVAR=$(echo "${LINE}" | sed -e 's/\(.*\)\(-<-[a-zA-Z0-9_]*->-\)\(.*\)/\3/1' )
         RVAR="${!SVAR}"
         LINE="$FVAR$RVAR$TVAR"
      done
       echo $LINE >> $resultfile
done < $templatefile
}

cfg_generate $@
