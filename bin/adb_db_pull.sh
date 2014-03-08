#!/bin/bash
 
REQUIRED_ARGS=2
PULL_DIR="./"
ADB_PATH=`which adb`
if [ $? -ne 0 ]
    then
    echo "Could not find adb!"
    exit 1
fi;
 
if [ $# -ne $REQUIRED_ARGS ]
    then
        echo ""
        echo "Usage:"
        echo "adb_db_pull.sh [package_name] [db_name]"
        echo "eg. adb_db_pull.sh lt.appcamp.impuls impuls.db"
        echo ""
    exit 1
fi;
 
 
echo""
 
cmd1="$ADB_PATH -d shell 'run-as $1 cat /data/data/$1/databases/$2 > /sdcard/$2' "
cmd2="$ADB_PATH pull /sdcard/$2 $PULL_DIR"
 
echo $cmd1
eval $cmd1
if [ $? -eq 0 ]
    then
    echo ".........OK"
fi;
 
echo $cmd2
eval $cmd2
 
if [ $? -eq 0 ]
    then
    echo ".........OK"
fi;
 
exit 0