select * from t_fo_event order by autoid desc for update; --RI0001108388 0001.921511

select * from cmdmenu where  cmdid = '020131';
select * from grmaster where objname = 'SA.SELIMITGRP';
select * from search where searchcode = 'SELIMITGRP';

--ADDSPROOM
select * from SELIMITGRP where autoid = '17202';
select * from AFSELIMITGRP where refautoid ='17202';
select * from t_fo_inday_ownpoolroom t where t.prid = '17202';
SELECT * FROM t_fo_inday_poolroom WHERE POLICYCD =  '17202';
SELECT * FROM T_FO_POOLROOM  WHERE POLICYCD =  '17202';
select * from tlog where luser = user order by id desc;
---\
SELECT to_char(s.AUTOID) PRID,  a.afacctno ACCTNO,'R' policytype, si.symbol refsymbol,
        0 inused,substr('RI0001108388',2,1) ACTIONTYPE,
        SYSTIMESTAMP lastchange, 'N' status
FROM SELIMITGRP s, SECURITIES_INFO si,  AFSELIMITGRP a
       WHERE s.codeid =si.codeid AND  s.autoid = a.refautoid
             and s.autoid = '17202' and a.afacctno =  substr('RI0001108388',3)
             and substr('RI0001108388',2,1) <>'D'
---
select substr('RI0001108388',1,1) from dual;
select substr('RI0001108388',2,1) from dual;
---
select length(SUBSTR('RI0001108388',3)) from dual;--10
select * from t_fo_inday_ownpoolroom where acctno = '0001108388';
--
SELECT pr.prcode PRID,SUBSTR('I0001108388',2) ACCTNO,'P' POLICYTYPE,'VND' REFSYMBOL,
       0 INUSED ,SUBSTR('I0001108388',1,1) ACTIONTYPE,SYSTIMESTAMP lastchange, 'N' status
from pracctnomap pr
WHERE pr.acctno = SUBSTR('I0001108388',2);
---
select * from pracctnomap;
select * from prtypemap;
---
select * from selimitgrp;
select * from afprallocation order by autoid desc;
select * from afpralloc;
---
select * from user_source where upper(text) like '%INSERT INTO AFPRALLOC%';
---
alter table t_fo_inday_ownpoolroom add prlimit NUMBER(20) default(0);
alter table t_fo_inday_ownpoolroom add refprid VARCHAR2(10);

select * from t_fo_inday_ownpoolroom;

select prcode v_syspool from prmaster where prtyp = 'S' and prstatus = 'A';
