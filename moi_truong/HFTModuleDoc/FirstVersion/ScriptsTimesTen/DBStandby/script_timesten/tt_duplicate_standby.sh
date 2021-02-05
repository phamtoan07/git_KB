#!/bin/sh

echo 
echo Setting standby machine to duplicate from master
echo

ttRepAdmin -duplicate -from foActive -host "front-active" -uid cacheuseradmin -pwd timesten -keepcg -cacheuid cacheuseradmin -cachepwd oracle "dsn=foStandby"