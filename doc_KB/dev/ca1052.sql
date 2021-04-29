
---
select instr('1234','34') from dual;

select fnc_getbasket_ca1052('AAA_q_C_1904_1') from dual;
select * from sbsecurities where symbol = 'AAA_q_C_1904_1';

select * from secbasket where symbol like '%q_C_%' or symbol like '%q_S_%';
select * from secbasketext where symbol like '%q_C_%' or symbol like '%q_S_%';

select * from semast;
select substr('0001920102000314',length('0001920102000314')-1, length('0001920102000314')) from dual;
select FN_GET_SUMSEMAST_TRADE_CA1052('900275') from dual;

select * from sbsecurities where symbol IN ('ACL','BBC');
select * from sbsecurities where refcodeid = '000623';
select * from secmrcamap where mrsecsymbol = 'AAA_q_C_1904_1';

SELECT sec.codeid, sec.symbol, sec.refcodeid, sb1.symbol refsymbol,
       fnc_getbasket_ca1052(sec.symbol) listbasket, fn_get_sumsemast_trade_ca1052(sec.codeid) sumtrade,
       nvl(r.ranksec,'') secrank, rate.mrratiorate, rate.mrratioloan, rate.mrpricerate, rate.mrpriceloan,
       rate.newmrratiorate, rate.newmrpricerate, m.createdate, m.createtime,
       ca.camastid, ca.catype catypecd,a1.cdcontent catype, ca.codeid execcodeid, sb2.symbol execsymbol,
       ca.reportdate, ca.description, ca.makerid, maker.tlname makername, ca.apprvid, checker.tlname checkername
from sbsecurities sec, secmrcamap m, sbsecurities sb1, secrank r, sbsecurities sb2,
     casecmrrate rate, camast ca, allcode a1, tlprofiles maker, tlprofiles checker
where sec.sectype = '013'
      and m.mrseccodeid = sec.codeid
      and m.mrsecsymbol = sec.symbol
      and sb1.codeid = sec.refcodeid
      and r.codeid(+) = sb1.codeid
      and rate.codeid(+) = sb1.codeid
      and rate.secrank = r.ranksec
      and m.camastid = ca.camastid
      and a1.cdname = 'CATYPE' and a1.cdtype = 'CA' and a1.cdval = ca.catype
      and ca.codeid = sb2.codeid
      and maker.tlid = ca.makerid
      and checker.tlid = ca.apprvid

select * from secrank where codeid in ('000244','000040');
---
select listagg (basketid,'/') within group (order by basketid) as lsbasket, symbol
          from ( 
              select b.basketid, s.symbol from basket b, secbasket s where s.basketid = b.basketid
              union all
              select b.basketid, s.symbol from basketext b, secbasketext s where s.basketid = b.basketid 
            )
group by symbol
--
select distinct listagg (basketid,'/') within group (order by basketid) over(partition by symbol) lsbasket, symbol
          from ( 
              select b.basketid, s.symbol from basket b, secbasket s where s.basketid = b.basketid
              union all
              select b.basketid, s.symbol from basketext b, secbasketext s where s.basketid = b.basketid 
            );
