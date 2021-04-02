select * from filemaster where FILECODE = 'I075'; --SECBASKETTEMP  CAL_SEC_BASKET FILLTER_SEC_BASKET

select * from SECBASKETTEMP;

select * from filemap where FILECODE = 'I002';

select * from file

-----

select * from filemaster where FILECODE = 'I009'; --SECBASKETEDIT  CAL_SEC_BASKET_EDIT FILLTER_SEC_BASKET_EDIT

select * from SECBASKETTEMP;

select * from filemap where FILECODE = 'I009';

select * from basket where basketid like '%PT MG%';

select * from secbasket where basketid like 'PT MG';

---

    SELECT basketid,symbol, count(1) FROM secbaskettemp
    HAVING count(1) <> 1
    GROUP BY  basketid,symbol;
    
    SELECT s.basketid, s.symbol,
            t.mrratiorate mrratiorate, t.mrratioloan mrratioloan,
            t.mrpricerate mrpricerate, t.mrpriceloan mrpriceloan,
            s.mrratiorate mrratiorate_old, s.mrratioloan mrratioloan_old,
            s.mrpricerate mrpricerate_old, s.mrpriceloan mrpriceloan_old, t.tellerid
        FROM
        secbasket s, secbaskettemp t
        WHERE s.basketid = t.basketid AND s.symbol = t.symbol
----------

--import tiểu khoản vào rổ đặc biệt
select * from filemaster where filecode in ('I002','I075'); --SECBASKETEDIT  CAL_SEC_BASKET_EDIT FILLTER_SEC_BASKET_EDIT

insert into filemaster (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE)
values ('I', 'I075', 'Import tiểu khoản được rổ đặc biệt', null, 'AFBASKETEXTTEMP', '1', 1, 'N', '.xls', 100, 'CAL_AF_BASKETEXT_ADD', 'FILLTER_AF_BASKETEXT_ADD', 'Y', null, null, null);

AFBASKETEXTTEMP

AFBASKETEXT

select * from secbaskettemp;

CREATE TABLE AFBASKETEXTTEMP
(
  BASKETID    VARCHAR2(50) DEFAULT 0,
  ACCTNO    VARCHAR2(20),
  EXPDATE   DATE,
  ACTYPE    VARCHAR2(1),
  DESCRIPTION VARCHAR2(500),
  STATUS      CHAR(1) DEFAULT 'Y',
  APPROVED    CHAR(1) DEFAULT 'N',
  TELLERID    VARCHAR2(4),
  APRID       VARCHAR2(4)
);

select * from filemap where filecode = 'I075' for update;

select * from deferror where errnum like '-1004%' order by errnum for update;
secbasket_log
create table AFBASKETEXT 

drop table AFBASKETEXT_LOG;
create table AFBASKETEXT_LOG
(
  txdate          DATE,
  txtime          VARCHAR2(20),
  basketid        VARCHAR2(50) default 0,
  acctno          VARCHAR2(20),
  EXPDATE         DATE,
  ACTYPE          VARCHAR2(1),
  EXPDATE_old     DATE,
  makerid         VARCHAR2(4),
  checkerid       VARCHAR2(4),
  action          VARCHAR2(20),
  refid           number
);

create table AFBASKETEXTHIST as select * from AFBASKETEXT where 0=1;


select * from AFBASKETEXTHIST;
select * from AFBASKETEXT_LOG;

select * from tlog where luser = user order by id desc;
