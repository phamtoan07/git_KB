﻿select * from basket;

--Thông tin rổ đặc biệt
CREATE TABLE BASKETEXT 
(
  BASKETID   VARCHAR2(50),
  BASKETNAME VARCHAR2(150),
  FROMDATE   DATE,--DEFAULT SYSDATE
  EXPDATE    DATE,
  STATUS     VARCHAR2(1),
  NOTES      VARCHAR2(250)
);

--Chứng khoán trong rổ đặc biệt
create table SECBASKETEXT 
(
  AUTOID      NUMBER(20)
  BASKETID    VARCHAR2(50),
  SYMBOL      VARCHAR2(20) NOT NULL,
  MRRATIORATE NUMBER(20,4) DEFAULT 0,
  MRRATIOLOAN NUMBER(20,4) DEFAULT 0,
  MRPRICERATE NUMBER(20,4) DEFAULT 0,
  MRPRICELOAN NUMBER(20,4) DEFAULT 0,
  DESCRIPTION VARCHAR2(500),
  IMPORTDT    DATE,
  NEWMRRATIORATE NUMBER(20,4), --TI LE TINH TAI SAN MOI
  NEWMRPRICERATE NUMBER(20,4), --GIA TINH TAI SAN MOI
  EFFDATE     DATE             --NGAY HIEU LUC
);

--Thông tin thay đổi tỉ lệ chờ thực hiện
create table SECBASKETEXTEFFDT
(
  AUTOID      NUMBER(20)
  BASKETID    VARCHAR2(50),
  SYMBOL      VARCHAR2(20) NOT NULL,
  NEWMRRATIORATE NUMBER(20,4), --TI LE TINH TAI SAN MOI
  NEWMRPRICERATE NUMBER(20,4), --GIA TINH TAI SAN MOI
  EFFDATE     DATE,            --NGAY HIEU LUC MOI
  CREATEDT      DATE,
  ISPROCESS   VARCHAR2(1),
  DELTD       VARCHAR2(1)            
);

--Thông tin careby rổ đặc biệt
create table CAREBYBASKETEXT
(
  BASKETID    VARCHAR2(50),
  CAREBYID    VARCHAR2(4) NOT NULL,
  CAREBYNAME  VARCHAR2(50)
);

select * from fldmaster where objname like '%CF.CFMAST%';

select * from search where searchcode = 'TLPROFILES_TX'

SELECT PR.TLID, PR.TLNAME, PR.TLFULLNAME, GR.GRPID, GR.GRPNAME, A.CDCONTENT TLAPARTMENT
FROM TLGROUPS GR, TLPROFILES PR, TLGRPUSERS GPR, ALLCODE A
WHERE GPR.GRPID = GR.GRPID AND PR.TLID  = GPR.TLID  AND GR.ACTIVE = 'Y' AND GR.GRPTYPE =  '2'
AND A.CDTYPE = 'SA' AND A.CDNAME = 'TLGROUP' AND TRIM(A.CDVAL) = TRIM(PR.TLGROUP)
AND GR.GRPID IN
    (
    SELECT GR.GRPID FROM TLGROUPS GR, TLPROFILES PR, TLGRPUSERS GPR
    WHERE  GPR.GRPID = GR.GRPID AND PR.TLID  = GPR.TLID  AND GR.ACTIVE = 'Y' AND GR.GRPTYPE =  '2'
    AND PR.TLID = '0001'
    ) 

--Thông tin tiểu khoản gán rổ đặc biệt
create table AFBASKETEXT
(
  AUTOID     NUMBER(20)
  BASKETID   VARCHAR2(50),
  ACTYPE     VARCHAR(1),--U -> SỐ TIỂU KHOẢN, G -> GROUP
  ACCTNO     VARCHAR2(20),
  CUSTODYCD  VARCHAR2(20),
  CUSTNAME   VARCHAR2(100),
  GRPACCT    VARCHAR2(10),
  EXPDATE    DATE,
  STATUS     VARCHAR2(1)
);

select * from cmdmenu where cmdid = '020132';
select * from grmaster where objname like '%DBNAVGRP%'
select * from DBNAVGRP;
select * from AFDBNAVGRP;
------
create table AFSERISKEXT
(
  CODEID        VARCHAR2(6) NOT NULL,
  ACTYPE        VARCHAR2(4) NOT NULL,
  MRRATIORATE   NUMBER(20,4) DEFAULT 0,
  MRRATIOLOAN   NUMBER(20,4) DEFAULT 0,
  MRPRICERATE   NUMBER(20,4) DEFAULT 0,
  MRPRICELOAN   NUMBER(20,4) DEFAULT 0,
  EXPDATE       DATE,
  ISMARGINALLOW VARCHAR2(1) DEFAULT 'N'
)
------Đồng bộ HFT
select * from user_Source where upper(text) like '%T_FO_EVENT%';
------Import
select * from filemaster where filecode = 'I002';
select * from SECBASKETTEMP;
select * from SECBASKETTEMPDTL;

FILLTER_SEC_BASKET

