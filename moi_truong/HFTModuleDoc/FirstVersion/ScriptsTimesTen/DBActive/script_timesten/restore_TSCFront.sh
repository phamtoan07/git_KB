#!/bin/sh
#	
# (C) Copyright (C) 2010, Thang Long Security. All rights reserved.
#  Ref http://venuandem.wordpress.com/category/timesten/
#  Ref
#
#  usage: restore <dsn> <file>
#echo Restore data for T_FRONT_SEQ_SECURITIES ...........
#ttbulkcp -i -e log_error.err dsn=$1 BACK.T_FRONT_SEQ_SECURITIES /home/fo/newfo/script_timesten/Data/T_FRONT_SEQ_SECURITIES.dump

#cd /home/fo/newfo/script_timesten
#ttisql -f delete_table.sql

echo Restore data for ACCOUNTS ...........
ttbulkcp -i -e log_error.err dsn=foActive FOPRO.ACCOUNTS /home/fo/newfo/script_timesten/Data/ACCOUNTS.dump
echo Restore data for ADVORDERS ...........
ttbulkcp -i -e log_error.err dsn=foActive FOPRO.ADVORDERS /home/fo/newfo/script_timesten/Data/ADVORDERS.dump
echo Restore data for ALLOCATION ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.ALLOCATION /home/fo/newfo/script_timesten/Data/ALLOCATION.dump
echo Restore data for BANKACCORDERS ...........
ttbulkcp -i -e log_error.err dsn=foActive FOPRO.BANKACCORDERS /home/fo/newfo/script_timesten/Data/BANKACCORDERS.dump
echo Restore data for BASKETS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.BASKETS /home/fo/newfo/script_timesten/Data/BASKETS.dump
echo Restore data for CROSSINFO ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.CROSSINFO /home/fo/newfo/script_timesten/Data/CROSSINFO.dump
echo Restore data for CUSTOMERS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.CUSTOMERS /home/fo/newfo/script_timesten/Data/CUSTOMERS.dump
echo Restore data for DEFRULES ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.DEFRULES /home/fo/newfo/script_timesten/Data/DEFRULES.dump
echo Restore data for DICERRORS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.DICERRORS /home/fo/newfo/script_timesten/Data/DICERRORS.dump
echo Restore data for EXCERROR ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.EXCERROR /home/fo/newfo/script_timesten/Data/EXCERROR.dump
echo Restore data for FOUSERS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.FOUSERS /home/fo/newfo/script_timesten/Data/FOUSERS.dump
echo Restore data for GW_MSG_LOGS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.GW_MSG_LOGS /home/fo/newfo/script_timesten/Data/GW_MSG_LOGS.dump
echo Restore data for HFT_MSG_LOGS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.HFT_MSG_LOGS /home/fo/newfo/script_timesten/Data/HFT_MSG_LOGS.dump
echo Restore data for INSTRUMENTS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.INSTRUMENTS /home/fo/newfo/script_timesten/Data/INSTRUMENTS.dump
echo Restore data for MARKETINFO ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.MARKETINFO /home/fo/newfo/script_timesten/Data/MARKETINFO.dump
echo Restore data for MSGERRORS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.MSGERRORS /home/fo/newfo/script_timesten/Data/MSGERRORS.dump
echo Restore data for ORDERS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.ORDERS /home/fo/newfo/script_timesten/Data/ORDERS.dump
echo Restore data for OWNPOOLROOM ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.OWNPOOLROOM /home/fo/newfo/script_timesten/Data/OWNPOOLROOM.dump
echo Restore data for POOLROOM ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.POOLROOM /home/fo/newfo/script_timesten/Data/POOLROOM.dump
echo Restore data for PORTFOLIOS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.PORTFOLIOS /home/fo/newfo/script_timesten/Data/PORTFOLIOS.dump
echo Restore data for PORTFOLIOSEX ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.PORTFOLIOSEX /home/fo/newfo/script_timesten/Data/PORTFOLIOSEX.dump
echo Restore data for PRODUCTS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.PRODUCTS /home/fo/newfo/script_timesten/Data/PRODUCTS.dump
echo Restore data for PROFILES ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.PROFILES /home/fo/newfo/script_timesten/Data/PROFILES.dump
echo Restore data for QUOTES ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.QUOTES /home/fo/newfo/script_timesten/Data/QUOTES.dump
echo Restore data for SYSCONFIG ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.SYSCONFIG /home/fo/newfo/script_timesten/Data/SYSCONFIG.dump
echo Restore data for TICKSIZE ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.TICKSIZE /home/fo/newfo/script_timesten/Data/TICKSIZE.dump
echo Restore data for TRADES ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.TRADES /home/fo/newfo/script_timesten/Data/TRADES.dump
echo Restore data for TRADING_EXCEPTION ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.TRADING_EXCEPTION /home/fo/newfo/script_timesten/Data/TRADING_EXCEPTION.dump
echo Restore data for TRADING_EXCEPTION_LOG ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.TRADING_EXCEPTION_LOG /home/fo/newfo/script_timesten/Data/TRADING_EXCEPTION_LOG.dump
echo Restore data for TRANSACTIONS ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.TRANSACTIONS /home/fo/newfo/script_timesten/Data/TRANSACTIONS.dump
echo Restore data for WORKINGCALENDAR ...........
ttbulkcp -i -e log_error.err -N UTF8 dsn=foActive FOPRO.WORKINGCALENDAR /home/fo/newfo/script_timesten/Data/WORKINGCALENDAR.dump
#echo Restore table & SP
#ttIsql -f master1_08_0000.sql -connstr "DSN=master1;UID=back;PWD=back"
echo Change password




