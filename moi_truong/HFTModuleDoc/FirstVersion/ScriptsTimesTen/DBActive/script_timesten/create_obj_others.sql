REM
REM Create table
REM

CREATE GLOBAL TEMPORARY TABLE CONSIDERED_SYMBOLS_TMP(
	ROOMID          VARCHAR2(20),
	SYMBOL          VARCHAR2(15),
	PRICE_ASSET     NUMBER(20,2),
	RATE_ASSET      NUMBER(10,4),
	PRIORITY        NUMBER
) ON COMMIT PRESERVE ROWS;

CREATE TABLE TTLOGS(
	AUTOID VARCHAR2(20),
	TXCODE VARCHAR2(20),
	ACCTNO VARCHAR2(20),
	ORDERID VARCHAR2(20), 
	FLDNAME VARCHAR2(50),
	FLDVALUE VARCHAR2(200),
	PRIMARY KEY(AUTOID));
		
CREATE TABLE TBL_MATCHED_TRANS(
	MSGID				VARCHAR2(20)	PRIMARY KEY,
	CLORDID 			VARCHAR2(20),
	ORIGCLORDID 		VARCHAR2(20),
	EXECID 				VARCHAR2(20),
	LASTQTY 			NUMBER,
	LASTPX 				NUMBER);

	
REM
REM Create sequence
REM
@tt_create_sequence.sql

REM BACKUP DU LIEU


REM
REM Create indexes
REM
@tt_create_indexs.sql

REM
REM Return a list of tables created in the FOPRO schema
REM
tables;