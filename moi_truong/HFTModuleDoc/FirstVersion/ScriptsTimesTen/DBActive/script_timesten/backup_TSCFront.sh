#!/bin/sh
#	
# (C) Copyright (C) 2010, Thang Long Security. All rights reserved.
#  Ref http://venuandem.wordpress.com/category/timesten/
#  Ref
#
#  usage: backup <dsn> <file>

date2stamp () {
    date --utc --date "$1" +%s
}

stamp2date (){
    date --utc --date "1970-01-01 $1 sec" "+%Y-%m-%d %T"
}

dateDiff (){
    case $1 in
        -s)   sec=1;      shift;;
        -m)   sec=60;     shift;;
        -h)   sec=3600;   shift;;
        -d)   sec=86400;  shift;;
        *)    sec=86400;;
    esac
    dte1=$(date2stamp $1)
    dte2=$(date2stamp $2)
    diffSec=$((dte2-dte1))
    if ((diffSec < 0)); then abs=-1; else abs=1; fi
    echo $((diffSec/sec*abs))
}

# convert a date into a UNIX timestamp

stamp=$(date +"%r_%d_%h_%y")

echo Backup schema ...........
ttschema  dsn=$1 > $2
#echo Backup data for T_FRONT_SEQ_SECURITIES ...........
#ttbulkcp -o dsn=$1 BACK.T_FRONT_SEQ_SECURITIES /home/fo/newfo/script_timesten/Data/T_FRONT_SEQ_SECURITIES.dump
echo Backup data for ACCOUNTS ...........
ttbulkcp -o dsn=foActive FOPRO.ACCOUNTS /home/fo/newfo/script_timesten/Data/ACCOUNTS.dump
echo Backup data for ADVORDERS ...........
ttbulkcp -o dsn=foActive FOPRO.ADVORDERS /home/fo/newfo/script_timesten/Data/ADVORDERS.dump
echo Backup data for ALLOCATION ...........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.ALLOCATION /home/fo/newfo/script_timesten/Data/ALLOCATION.dump
echo Backup data for BANKACCORDERS ...........
ttbulkcp -o dsn=foActive FOPRO.BANKACCORDERS /home/fo/newfo/script_timesten/Data/BANKACCORDERS.dump
echo Backup data for BASKETS ...........
ttbulkcp -o dsn=foActive FOPRO.BASKETS /home/fo/newfo/script_timesten/Data/BASKETS.dump
echo Backup data for CROSSINFO ...........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.CROSSINFO /home/fo/newfo/script_timesten/Data/CROSSINFO.dump
echo Backup data for CUSTOMERS ...........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.CUSTOMERS /home/fo/newfo/script_timesten/Data/CUSTOMERS.dump
echo Backup data for DEFRULES ...........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.DEFRULES /home/fo/newfo/script_timesten/Data/DEFRULES.dump
echo Backup data for DICERRORS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.DICERRORS /home/fo/newfo/script_timesten/Data/DICERRORS.dump
echo Backup data for EXCERROR..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.EXCERROR /home/fo/newfo/script_timesten/Data/EXCERROR.dump
echo Backup data for FOUSERS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.FOUSERS /home/fo/newfo/script_timesten/Data/FOUSERS.dump
echo Backup data for GW_MSG_LOGS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.GW_MSG_LOGS /home/fo/newfo/script_timesten/Data/GW_MSG_LOGS.dump
echo Backup data for HFT_MSG_LOGS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.HFT_MSG_LOGS /home/fo/newfo/script_timesten/Data/HFT_MSG_LOGS.dump
echo Backup data for INSTRUMENTS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.INSTRUMENTS /home/fo/newfo/script_timesten/Data/INSTRUMENTS.dump
echo Backup data for MARKETINFO..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.MARKETINFO /home/fo/newfo/script_timesten/Data/MARKETINFO.dump
echo Backup data for MSGERRORS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.MSGERRORS /home/fo/newfo/script_timesten/Data/MSGERRORS.dump
echo Backup data for ORDERS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.ORDERS /home/fo/newfo/script_timesten/Data/ORDERS.dump
echo Backup data for OWNPOOLROOM..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.OWNPOOLROOM /home/fo/newfo/script_timesten/Data/OWNPOOLROOM.dump
echo Backup data for POOLROOM..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.POOLROOM /home/fo/newfo/script_timesten/Data/POOLROOM.dump
echo Backup data for PORTFOLIOS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.PORTFOLIOS /home/fo/newfo/script_timesten/Data/PORTFOLIOS.dump
echo Backup data for PORTFOLIOSEX..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.PORTFOLIOSEX /home/fo/newfo/script_timesten/Data/PORTFOLIOSEX.dump
echo Backup data for PRODUCTS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.PRODUCTS /home/fo/newfo/script_timesten/Data/PRODUCTS.dump
echo Backup data for PROFILES..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.PROFILES /home/fo/newfo/script_timesten/Data/PROFILES.dump
echo Backup data for QUOTES..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.QUOTES /home/fo/newfo/script_timesten/Data/QUOTES.dump
echo Backup data for SYSCONFIG..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.SYSCONFIG /home/fo/newfo/script_timesten/Data/SYSCONFIG.dump
echo Backup data for TICKSIZE..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.TICKSIZE /home/fo/newfo/script_timesten/Data/TICKSIZE.dump
echo Backup data for TRADES..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.TRADES /home/fo/newfo/script_timesten/Data/TRADES.dump
echo Backup data for TRADING_EXCEPTION..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.TRADING_EXCEPTION /home/fo/newfo/script_timesten/Data/TRADING_EXCEPTION.dump
echo Backup data for TRADING_EXCEPTION_LOG..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.TRADING_EXCEPTION_LOG /home/fo/newfo/script_timesten/Data/TRADING_EXCEPTION_LOG.dump
echo Backup data for TRANSACTIONS..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.TRANSACTIONS /home/fo/newfo/script_timesten/Data/TRANSACTIONS.dump
echo Backup data for WORKINGCALENDAR..........
ttbulkcp -N UTF8 -o dsn=foActive FOPRO.WORKINGCALENDAR /home/fo/newfo/script_timesten/Data/WORKINGCALENDAR.dump

