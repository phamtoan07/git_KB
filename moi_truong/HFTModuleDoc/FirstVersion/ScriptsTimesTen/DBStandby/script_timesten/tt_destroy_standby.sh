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

echo Destroy DSN="foStandby"
echo ttdestroy foStandby
echo

ttdestroy foStandby

echo Clear cache config on Oracle
echo 

#java -version
#java -jar FSS_clearCacheConfig.jar jdbc:oracle:thin:@10.1.34.46:1521:HFT cacheuseradmin oracle

