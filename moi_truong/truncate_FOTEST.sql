--
--
/
CREATE TABLE GW_MSG_LOGS_B_n AS SELECT * FROM GW_MSG_LOGS_B WHERE gw_date >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table GW_MSG_LOGS_B;
INSERT INTO GW_MSG_LOGS_B SELECT * FROM GW_MSG_LOGS_B_n;
commit;
/
CREATE TABLE TRANSACTIONS_B_n AS SELECT * FROM TRANSACTIONS_B WHERE time_created >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table TRANSACTIONS_B;
INSERT INTO TRANSACTIONS_B SELECT * FROM TRANSACTIONS_B_n;
commit;
/
CREATE TABLE HFT_MSG_LOGS_B_n AS SELECT * FROM HFT_MSG_LOGS_B WHERE hft_date >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table HFT_MSG_LOGS_B;
INSERT INTO HFT_MSG_LOGS_B SELECT * FROM HFT_MSG_LOGS_B_n;
commit;
/
CREATE TABLE QUOTES_B_n AS SELECT * FROM QUOTES_B WHERE createddt >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table QUOTES_B;
INSERT INTO QUOTES_B SELECT * FROM QUOTES_B_n;
commit;
/