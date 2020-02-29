#!/bin/bash
function cfg_generate {

# get keys
while [ -n "$1" ]
do
case "$1" in
-t|--template) if [[ $2 =~ ^$|^-r$|^--result$ ]]
               then
                 echo "ERROR: template file needed"
                 exit
               else
                 templatefile="$2"
                 echo "template file: $templatefile"
                 shift
               fi ;;
-r|--result)  if [[ $2 =~ ^$|^-t$|^--template$ ]]
               then
                 echo "ERROR: result key needed"
                 exit
               else
                 resultfile="$2"
                 echo "result file: $resultfile"
                 shift
               fi ;;
*) echo "ERROR: incorrect input, use -t/--template and -r/--result keys only"
               exit
esac
shift
done

[ -z $templatefile ] && echo "ERROR: missed -t key" && exit

[ -z $resultfile ] && echo "ERROR: missed -r key" && exit

echo "keys check passed"

# check keys
if [ -r $templatefile ]
then
  echo "$templatefile exist and readble"
else
  echo "ERROR: $templatefile not exist or not readble"
  exit
fi

if [ -s $resultfile ]
then
  echo "ERROR: $resultfile exist and not empty"
  exit
elif touch $resultfile
then
  echo "$resultfile is ok"
else
  echo "ERROR: $resultfile can't be used"
  exit
fi
echo  "file check passed"

while read LINE
     do
       TEMPVAR=$(echo $LINE | sed -e 's/.*-<-//g' -e 's/->-//g')
       RESULTVAR="${!TEMPVAR}"
       RESULTLINE="$(echo $LINE | sed 's/-<-.*->-//g')$RESULTVAR"
       echo $RESULTLINE >> $resultfile
done < $templatefile
}

cfg_generate $@
