select * from allcode where cdname = 'APPRV_STS' and CDTYPE = 'SY';

select * from search where searchcode = 'AFMAST';

select * from DBNAVGRP for update;

select * from search where searchcode = 'DBNAVGRP';

select * from cfmast where custodycd like '%000207%'; --0001000405
select * from afmast where custid = '0001000405';

select * from afbasketext where basketid in ('SR002','1111') for update;
select * from carebybasketext where  basketid in ('SR002','1111');
select * from basketext where  basketid in ('SR002','1111');

select * from AFDBNAVGRP where refactype = '0003' for update;

select acctno, status from afmast where careby in ('0062','0111') and acctno = '0001000602';

INSERT INTO AFBASKETEXTTEMP (BASKETID,ACCTNO,EXPDATE,ACTYPE,DESCRIPTION) VALUES ('SR002','0001000601',TO_DATE('27/04/2020','dd/MM/yyyy'),'U','DESSC'); 
INSERT INTO AFBASKETEXTTEMP (BASKETID,ACCTNO,EXPDATE,ACTYPE,DESCRIPTION) VALUES ('SR002','0003',TO_DATE('21/04/2020','dd/MM/yyyy'),'G','DESSC'); 
INSERT INTO AFBASKETEXTTEMP (BASKETID,ACCTNO,EXPDATE,ACTYPE,DESCRIPTION) VALUES ('SR002','0001000093',TO_DATE('27/04/2020','dd/MM/yyyy'),'U','Tiểu khoản'); 



select * from afbasketexttemp for update; --0001000093

SELECT T.BASKETID, S.SYMBOL 
            FROM BASKETEXT T, SECBASKETEXT S,
                 (SELECT AF.ACCTNO, T.BASKETID FROM AFBASKETEXT AF, BASKETEXT T
                  WHERE AF.BASKETID = T.BASKETID AND AF.ACCTNO IS NOT NULL AND AF.STATUS IN ('P','A') AND AF.ACTYPE = 'U'
                  UNION
                  SELECT AF.AFACCTNO, T.BASKETID FROM AFDBNAVGRP AF, DBNAVGRP G, AFBASKETEXT AFT, BASKETEXT T
                  WHERE AFT.GRPACCT = G.ACTYPE AND AFT.GRPACCT IS NOT NULL AND AFT.ACTYPE = 'G'
                  AND AF.REFACTYPE = G.ACTYPE AND T.BASKETID = AFT.BASKETID AND AFT.STATUS IN ('A','P')) AF
            WHERE S.SYMBOL = 'AAA' AND T.BASKETID = S.BASKETID AND T.BASKETID <> 'SR002'
                  AND T.STATUS IN ('P','A') AND AF.BASKETID <> 'SR002'
                  AND AF.BASKETID = T.BASKETID AND AF.ACCTNO = '0001000602';


SELECT s.*
        FROM
        afbasketext s, afbasketexttemp t
        WHERE s.basketid = t.basketid and s.actype = t.actype
              and (case when t.actype = 'U' then s.acctno else s.grpacct end) = t.acctno 
              
  SELECT t.*
        FROM
              afbasketexttemp t
        WHERE
              t.acctno NOT IN (SELECT case when af.actype = 'U' then af.acctno else af.grpacct end acctno FROM afbasketext af
                               WHERE t.basketid = af.basketid and af.actype = t.actype)
                               
                               
  select AUTOID,BASKETID,ACCTNO,CUSTODYCD,CUSTNAME,GRPACCT,GRPNAME,EXPDATE,STATUS,PSTATUS,ACTYPE
    from AFBASKETEXT where basketid||case when actype = 'U' then acctno else grpacct end ||actype in (select basketid||acctno||actype from afbasketexttemp);
    
    SELECT s.*, t.expdate expdate_new, t.tellerid
        FROM
        afbasketext s, afbasketexttemp t
        WHERE s.basketid = t.basketid and s.actype = t.actype
              and (case when t.actype = 'U' then s.acctno else s.grpacct end ) = t.acctno 
