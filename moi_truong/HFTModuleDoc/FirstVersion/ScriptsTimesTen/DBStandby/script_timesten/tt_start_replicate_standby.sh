#!/bin/sh

echo 
echo start replicate and grid attach on your standby machine
echo

cd /home/fo/newfo/script_timesten
#ttisql -f config_timesten_standby.sql -connstr "dsn=foStandby"
ttisql -f tt_start_replicate_standby.sql



