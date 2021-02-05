#!/bin/sh

echo 
echo Setting up the quickstart environment 
echo
#. ttquickstartenv.sh
echo 
echo Removing existing FSS Front database
echo


echo 
echo Building new active database
echo

cd /home/fo/newfo/script_timesten
ttisql -f build_db.sql -connstr "dsn=foActive" 

#ttSize -tbl  FO.ACCOUNTS active


