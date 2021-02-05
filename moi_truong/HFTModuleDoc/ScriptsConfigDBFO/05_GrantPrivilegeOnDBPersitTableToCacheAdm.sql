--- Sử dụng user full quyền SYSTEM hoặc SYS...

--- Grant quyền cho cache admin user lên các bảng new fo
grant select, insert, update, delete on fotest.ACCOUNTS to cacheadm;
grant select, insert, update, delete on fotest.ORDERS to cacheadm;
grant select, insert, update, delete on fotest.PORTFOLIOS to cacheadm;
grant select, insert, update, delete on fotest.TRADES to cacheadm;
grant select, insert, update, delete on fotest.QUOTES to cacheadm;
grant select, insert, update, delete on fotest.POOLROOM to cacheadm;

grant select, insert, update, delete on fotest.BASKETS to cacheadm;
grant select, insert, update, delete on fotest.FOUSERS to cacheadm;
grant select, insert, update, delete on fotest.PROFILES to cacheadm;
grant select, insert, update, delete on fotest.CUSTOMERS to cacheadm;
grant select, insert, update, delete on fotest.PRODUCTS to cacheadm;
grant select, insert, update, delete on fotest.INSTRUMENTS to cacheadm;
grant select, insert, update, delete on fotest.MARKETINFO to cacheadm;


grant select, insert, update, delete on fotest.ALLOCATION to cacheadm;
grant select, insert, update, delete on fotest.DEFRULES to cacheadm;
grant select, insert, update, delete on fotest.DICERRORS to cacheadm;
grant select, insert, update, delete on fotest.BANKACCORDERS to cacheadm;


grant select, insert, update, delete on fotest.STATICDATA to cacheadm;
grant select, insert, update, delete on fotest.TICKSIZE to cacheadm;
grant select, insert, update, delete on fotest.TRACKUNIQUE to cacheadm;

grant select, insert, update, delete on fotest.TRANSACTIONS to cacheadm;
grant select, insert, update, delete on fotest.SYSCONFIG  to cacheadm;

grant select, insert, update, delete on fotest.MSGERRORS  to cacheadm;
grant select, insert, update, delete on fotest.CROSSINFO  to cacheadm;
grant select, insert, update, delete on fotest.ADVORDERS  to cacheadm;
grant select, insert, update, delete on fotest.EXCERROR  to cacheadm;

grant select, insert, update, delete on fotest.WORKINGCALENDAR  to cacheadm;
grant select, insert, update, delete on fotest.OWNPOOLROOM  to cacheadm;

grant select, insert, update, delete on fotest.PORTFOLIOSEX  to cacheadm;

grant select, insert, update, delete on fotest.GW_MSG_LOGS  to cacheadm;
grant select, insert, update, delete on fotest.HFT_MSG_LOGS  to cacheadm;
grant select, insert, update, delete on fotest.TRADING_EXCEPTION  to cacheadm;
grant select, insert, update, delete on fotest.TRADING_EXCEPTION_LOG  to cacheadm;