#!/bin/sh

echo 
echo reset sequence timesten database... 
echo

cd /home/fo/newfo/script_timesten
ttisql -f tt_reset_sequence.sql -connstr "dsn=foActive" 

#dsn=NEWFOTEST2


