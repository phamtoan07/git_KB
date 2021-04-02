
drop table camast_mr_notify_events;
create table camast_mr_notify_events
(
  autoid number,
  txdate date,
  txtime VARCHAR2(20),
  action varchar2(10),
  camastid varchar2(20),
  catype   varchar2(10),
  ISINCODE varchar2(30),
  codeid   varchar2(10),
  optcodeid varchar2(20),
  optsymbol varchar2(50),
  castatus  varchar2(1),
  repordate date,
  reportdate_old date,
  status    varchar2(1)
);
create sequence seq_camast_mr_notify_events;

drop table secmrcamap;
create table SECMRCAMAP
(
  autoid      NUMBER,
  createdate  DATE,
  createtime  VARCHAR2(20),
  camastid    VARCHAR2(20),
  catype      VARCHAR2(10),
  isincode    VARCHAR2(30),
  codeid      VARCHAR2(10),
  optcodeid   VARCHAR2(20),
  optsymbol   VARCHAR2(50),
  mrseccodeid VARCHAR2(10),
  mrsecsymbol VARCHAR2(50),
  reportdate  DATE,
  status      VARCHAR2(1),
  deltd       VARCHAR2(1),
  expdate     DATE
)
create sequence seq_secmrcamap;
------
select * from camast;
select *from camast_mr_notify_events;
/
select * from allcode where cdname = 'CASTATUS';
/
select count(1) from camast where actiondate <= to_date('27/10/2018','dd/mm/rrrr') ;
select count(1) from caschd;
select getcurrdate - 180 from dual;

----
select status from camast where camastid = '0001002510112342';
----
 select * from sbsecurities where codeid = '900267';
  SELECT TO_NUMBER(SUBSTR((TO_CHAR(MAX(TO_NUMBER(nvl(invacct,0))) + 1)), 2, LENGTH((TO_CHAR(MAX(TO_NUMBER(nvl(invacct,0))) + 1))) - 1)) autoinv,
                  (MAX(nvl(odr,0)) + 1) odr
                  FROM   (
                         SELECT   ROWNUM odr, invacct
                         FROM   
                           (SELECT   invacct
                            FROM   
                               (SELECT   codeid invacct FROM sbsecurities WHERE substr(codeid, 1, 1)=9 UNION ALL SELECT '900001' FROM dual)
                            ORDER BY   invacct
                            ) dat
                  ) invtab
                  
  select LAST_DAY(getcurrdate) from dual;
  select getcurrdate from dual;
  select to_char(to_date('20-04-2021','dd-mm-rrrr'),'yymm') from dual;
  select instr('ABCC_q_2104_S_12','_',-1) from dual;
  select to_number(substr('ABCC_q_2104_S_12', instr('ABCC_q_2104_S_12','_',-1)+1, length('ABCC_q_2104_S_12'))) from dual;
----màn hình x,y
drop table casecmrrate;
create table CASECMRRATE
(
  autoid         NUMBER,
  codeid         VARCHAR2(10),
  symbol         VARCHAR2(50),
  secrank        VARCHAR2(1),
  mrratiorate    NUMBER(20,4) default 0,
  mrratioloan    NUMBER(20,4) default 0,
  mrpricerate    NUMBER(20,4) default 0,
  mrpriceloan    NUMBER(20,4) default 0,
  newmrratiorate NUMBER(20,4) default 0,
  newmrpricerate NUMBER(20,4) default 0,
  notes          VARCHAR2(500),
  status         VARCHAR2(1),
  pstatus        VARCHAR2(1000)
);
create sequence seq_casecmrrate;
select * from allcode where cdname = 'SECRANK' order by lstodr for update;
select * from allcode  where cdname = 'MRRATETYPE' and cdtype = 'CA' order by lstodr for update;
--search casecmrrate
select ca.autoid, ca.codeid, ca.symbol, ca.mrratetype actypecd, a1.cdcontent actype,
       ca.secrank rankcd, a2.cdcontent rankdesc, 
       ca.mrratiorate, ca.mrratioloan, ca.mrpricerate, ca.mrpriceloan, ca.newmrpricerate,
       ca.newmrratiorate, ca.status statuscd, a3.cdcontent status, ca.notes,
       (case when ca.status in ('B','C','N') then 'N' else 'Y' end) editallow,
       (case when ca.status in ('P') then 'Y' else 'N' end) aprallow, 'Y' delallow
from casecmrrate ca, sbsecurities sb, allcode a1, allcode a2, allcode a3
where sb.codeid = ca.codeid
      and a1.cdtype = 'CA' and a1.cdname= 'MRRATETYPE' and a1.cdval = ca.mrratetype
      and a2.cdtype = 'SA' and a2.cdname = 'SECRANK' and a2.cdval = ca.secrank
      and a3.cdtype = 'CF' and a3.cdname= 'CFSTATUS' and a3.cdval = ca.status
      
--
create table casbsecurities_bk as select * from sbsecurities where 0=1;
create table casecurities_ratehist as select * from securities_rate where 0=1;
create table casecurities_info_bk as select * from securities_info where 0=1;

--
select * from casbsecurities_bk;
alter table casbsecurities_bk add bkdate date;
alter table casecurities_ratehist add bkdate date;
alter table casecurities_info_bk  add bkdate date;

----
select * from tlog where luser=user order by id desc;
--
SELECT CAMASTID, DEVIDENTRATE, STATUS FROM CAMAST WHERE 0=0 AND CAMASTID = '0001003746112345';
select * from camast order by autoid desc;
--

alter table camast_mr_notify_events add note varchar2(500);
alter table secmrcamap add secrank varchar2(1);
--
select * from camast_mr_notify_events order by autoid desc for update;

select * from casecmrrate where symbol = 'ABC';
select * from secmrcamap order by autoid desc;

select * from secbasket where basketid in ('3101','PT MG'); -- 3101 PT MG
select * from secbasketext where basketid in ('1111','SR002'); -- 3101 PT MG
select * from secbasketexteffdt order by autoid desc;

select * from sbsecurities where symbol like 'ABC%';
select * from securities_info where symbol like 'ACB%';
select * from securities_rate where symbol like 'ACB%';
select * from securities_risk where codeid in ('900269','900271','900270');

---
select * from secbasket_log where autoid is not null order by autoid desc;
select * from secbasketext_log where autoid is not null order by autoid desc;

update secbasketexteffdt set deltd = 'Y' where isprocess = 'N' and refid = '22' and isext = 'Y' and effdate >=getcurrdate;

