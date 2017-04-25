#!/bin/sh

if [ $# -ne 4 ]; then
        echo "Usage: plistgen.sh <appversion> <filename> <plistemplate> <plistname>"
        exit
fi

#echo 'Generating installer plist'
echo "Generating $4 ..."

#TODO - get version info from file name
#eg: echo isms-1.0-snapshot-0224.pxl | awk -F '-' '{print $2}'
#APPMAJORVERSION=$1
#APPMINVERSION=$2
#APPVERSION="$APPMAJORVERSION-$APPMINVERSION"
APPVERSION=$1
APPFILENAME=$2
APPBASEFILENAME=`basename $APPFILENAME`
APPSIZE=`ls -l $APPFILENAME | awk '{print $5}'`
APPDATE=`ls -l --time-style=+%s $APPFILENAME | awk '{print $6}'`
sed -e "s#APPMAJORVERSION#$APPMAJORVERSION#" \
-e "s#APPMINVERSION#$APPMINVERSION#" \
-e "s#APPVERSION#$APPVERSION#" \
-e "s#APPFILENAME#$APPBASEFILENAME#" \
-e "s#APPDATE#$APPDATE#" \
-e "s#APPSIZE#$APPSIZE#" $3 > $4