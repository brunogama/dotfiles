#!/bin/bash

REQUIRED_ARGS=2
PULL_DIR="./"
ADB_PATH=`which adba`
if [ $? -ne 0 ]
    then
        cat <<__HEREDOC__

adb not fount in the PATH variable.
Make sure you have the "sdk/platform-tools".

__HEREDOC__
    exit 1
fi;

if [ $# -ne $REQUIRED_ARGS ]
    then
        cat <<__HEREDOC__

Usage:
$(basename $0) [package_name] [database_name]
eg. adb_db_pull.sh com.company.app.namespace database.sqlite

__HEREDOC__

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