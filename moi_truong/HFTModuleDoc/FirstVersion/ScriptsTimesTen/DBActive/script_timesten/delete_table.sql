set echo off
spool delete_table.log

connect "dsn=foActive;uid=fopro;pwd=fopro";

PROMPT delete all table ...


delete from ACCOUNTS;
delete from ADVORDERS;
delete from ALLOCATION;
delete from BANKACCORDERS;
delete from BASKETS;
delete from CROSSINFO;
delete from CUSTOMERS;
delete from DEFRULES;
delete from DICERRORS;
delete from EXCERROR;
delete from FOUSERS;
delete from GW_MSG_LOGS;
delete from HFT_MSG_LOGS;
delete from INSTRUMENTS;
delete from MARKETINFO;
delete from MSGERRORS;
delete from ORDERS;
delete from OWNPOOLROOM;
delete from PORTFOLIOS;
delete from PORTFOLIOSEX;
delete from PRODUCTS;
delete from PROFILES;
delete from QUOTES;
delete from SYSCONFIG;
delete from TICKSIZE;
delete from TRADES;
delete from TRADING_EXCEPTION;
delete from TRADING_EXCEPTION_LOG;
delete from TRANSACTIONS;
delete from WORKINGCALENDAR;

exit;