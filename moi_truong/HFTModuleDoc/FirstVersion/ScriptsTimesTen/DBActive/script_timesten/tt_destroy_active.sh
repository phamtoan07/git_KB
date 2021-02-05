#!/bin/sh

echo 
echo Stop Oracle Timesten
echo ttdaemonadmin -stop -force
echo

ttdaemonadmin -stop -force

echo Start Oracle Timesten
echo ttdaemonadmin -start
echo

ttdaemonadmin -start

echo Destroy DSN="foActive"
echo ttdestroy foActive
echo

ttdestroy foActive

echo Clear cache config on Oracle
echo 

cd /home/fo/newfo/script_timesten
java -version
java -jar FSS_clearCacheConfig.jar jdbc:oracle:thin:@10.100.21.43:1521:HFT cacheuseradmin oracle

