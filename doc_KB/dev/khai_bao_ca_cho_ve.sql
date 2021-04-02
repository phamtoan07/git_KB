Hạng CK:
select * from cmdmenu where cmdid = '020136'; --SECRANK
select * from search where searchcode = 'SECRANK';
select * from fldmaster where objname like '%SECRANK%';
----
select * from cmdmenu where prid = '220000' order by cmdid for update; --CASECRANK
select * from objmaster where objname = 'CA.CASECMRRATE' for update; --SECBASKETEXT

select * from grmaster where objname = 'CA.CASECMRRATE' for update; --CA.CASECRANK
--
select ca.autoid, ca.CODEID, ca.symbol,
       ca.SECRANK RANKCD, a2.cdcontent RANKDESC, 
       ca.mrratiorate, ca.mrratioloan, ca.mrpricerate, ca.mrpriceloan, ca.newmrpricerate,
       ca.newmrratiorate, ca.status statuscd, a3.cdcontent status, ca.notes,
       (case when ca.status in ('B','C','N') then 'N' else 'Y' end) editallow,
       (case when ca.status in ('P') then 'Y' else 'N' end) aprallow, 'Y' delallow
from casecmrrate ca, sbsecurities sb, allcode a2, allcode a3
where sb.codeid = ca.codeid
      and a2.cdtype = 'SA' and a2.cdname = 'SECRANK' and a2.cdval = ca.secrank
      and a3.cdtype = 'CF' and a3.cdname= 'CFSTATUS' and a3.cdval = ca.status;
---      
select * from search where searchcode = 'CASECMRRATE' for update; --CA.CASECRANK
select * from searchfld where searchcode= 'CASECMRRATE' order by position for update;

select * from search where searchcode = 'SECMRCAMAP' for update; 
select * from searchfld where searchcode= 'SECMRCAMAP' order by position for update;
--
select * from fldmaster where objname = 'CA.CASECMRRATE' for update;
select * from fldval where objname = 'CA.CASECMRRATE' for update;

--
select * from fldmaster where objname = 'CA.SECMRCAMAP' for update;
select * from fldval where objname = 'CA.SECMRCAMAP' for update;

--
SELECT M.AUTOID,M.CREATEDATE,M.CAMASTID, M.CATYPE CATYPECD, A1.CDCONTENT CATYPE,
       M.CODEID, SB.SYMBOL, M.OPTSYMBOL, M.MRSECCODEID, M.MRSECSYMBOL, 
       M.SECRANK SECRANKCD, A3.CDCONTENT SECRANK,
       M.STATUS STATUSCD, A2.CDCONTENT STATUS, M.EXPDATE,
       M.CREATETIME, M.ISINCODE, M.OPTCODEID, M.REPORTDATE, M.DELTD
FROM SECMRCAMAP M, SBSECURITIES SB, ALLCODE A1, ALLCODE A2, ALLCODE A3, CASECMRRATE RATE
WHERE M.CODEID = SB.CODEID
      AND A1.CDNAME = 'CATYPE' AND A1.CDTYPE = 'CA' AND A1.CDVAL = M.CATYPE
      AND A2.CDNAME = 'CFSTATUS' AND A2.CDTYPE = 'CF' AND A2.CDVAL = M.STATUS
      AND A3.CDNAME = 'SECRANK' AND A3.CDTYPE = 'SA' AND A3.CDVAL = M.SECRANK
      AND M.CODEID = RATE.CODEID AND RATE.AUTOID = <$KEYVAL>
      AND RATE.SECRANK = M.SECRANK
--
select * from deferror where errnum like '-300%' order by errnum for update;  
-----
select * from tltx where tltxcd = '5504' for update;
select *from fldmaster where objname = '5504' for update

---
AUTOID  CREATEDATE  CREATETIME  CAMASTID  CATYPE  ISINCODE  CODEID  
OPTCODEID OPTSYMBOL MRSECCODEID MRSECSYMBOL REPORTDATE  STATUS  
    DELTD EXPDATE SECRANK

