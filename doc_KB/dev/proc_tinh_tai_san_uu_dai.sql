    
SELECT ms.acctno afacctno, i.specid
    FROM afmast ms, lnspecrate i, lnspecrateacct af
    WHERE ms.acctno = af.acctno and i.specid = af.specid
    AND i.status = 'A' and getcurrdate <= af.expdate and af.opndate >=  getcurrdate
    AND EXISTS (SELECT 1 FROM lnschd schd, lnmast mst
                WHERE schd.acctno = mst.acctno AND mst.trfacctno = ms.acctno  and reftype = 'P'
                AND schd.nml > 0);
select count(1) from (
 SELECT greatest(0, floor((se.trade + nvl(sts.receiving,0) /*- nvl(od.execqtty,0)*/ + nvl(od.buyqtty,0))*least(nvl(rsk.mrpricerate,0), sb.marginprice)*nvl(rsk.mrratiorate,0)/100)) seamt,
        sb.symbol, sb.codeid, least(nvl(rsk.mrpricerate,0),sb.marginprice) price_asset, nvl(rsk.mrratiorate,0) mrrate,
        se.trade, nvl(sts.receiving,0) receiving, nvl(od.execqtty,0) execqtty, nvl(od.buyqtty,0) buyqtty,
        item.specid, item.rate
        FROM semast se
        INNER JOIN afmast af ON af.acctno = se.afacctno
        INNER JOIN aftype aft ON af.actype = aft.actype
        INNER JOIN securities_info sb ON sb.codeid = se.codeid
        INNER JOIN afserisk rsk ON rsk.codeid = se.codeid and rsk.actype=aft.actype
        INNER JOIN mrtype mrt ON aft.mrtype = mrt.actype
        LEFT JOIN 
             (select sum(buyqtty) buyqtty,sum(totalbuyqtty) totalbuyqtty, sum(execqtty) execqtty , afacctno, codeid
              from (
                    SELECT (case when od.exectype IN ('NB','BC')
                                            then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                    + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                            else 0 end) BUYQTTY,
                                            (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                        (case when od.exectype IN ('NS','MS') and od.stsstatus <> 'C' then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,AFACCTNO, CODEID
                    FROM odmast od, afmast af,
                                    (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                    (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                   where od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                   and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                   AND od.deltd <> 'Y'
                                   and not(od.grporder='Y' and od.matchtype='P')
                                   AND od.exectype IN ('NS', 'MS','NB','BC')           
                    )
                 where afacctno = '0001000602'
                 group by afacctno, codeid
               ) OD ON se.afacctno = od.afacctno AND se.codeid = od.codeid
          LEFT JOIN
           (select od.codeid,od.afacctno,
                              sum(case when duetype ='RM' then amt-aamt-famt+paidamt+paidfeeamt-amt*typ.deffeerate/100 else 0 end) mamt,
                              sum(case when duetype ='RS' and nvl(sts_trf.islatetransfer,0) = 0 and sts.txdate <> to_date(sy.varvalue,'DD/MM/RRRR') then qtty-aqtty else 0 end) receiving,
                              sum(case when duetype ='RS' and (nvl(sts_trf.islatetransfer,0) = 0 or sts_trf.trfbuydt = to_date(sy.varvalue,'DD/MM/RRRR')) and sts.txdate <> to_date(sy.varvalue,'DD/MM/RRRR') then qtty-aqtty else 0 end) t0receiving,
                              sum(case when duetype ='RS' and sts.txdate <> to_date(sy.varvalue,'DD/MM/RRRR') then qtty-aqtty else 0 end) totalreceiving
                          from stschd sts, odmast od, odtype typ,
                          (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer, trfbuydt from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                          sysvar sy
                          where sts.duetype in ('RM','RS') and sts.status ='N'
                              and sy.grname = 'SYSTEM' and sy.varname = 'CURRDATE'
                              and sts.deltd <>'Y' and sts.orgorderid=od.orderid and od.actype =typ.actype
                              and od.orderid = sts_trf.orgorderid(+)
                              and od.afacctno = '0001000602'
                              group by od.afacctno,od.codeid
                       ) sts ON sts.afacctno =se.afacctno and sts.codeid=se.codeid
        LEFT JOIN (SELECT * from LNSPECRATELIST WHERE specid = '0001') item on item.symbol = sb.symbol  
        WHERE mrt.mrtype = 'T'
              AND af.acctno = '0001000602'
              AND sb.symbol not in (SELECT symbol FROM vw_basketext_acct_info ext WHERE ext.acctno = '0001000602')
  UNION ALL
  SELECT greatest(0, floor((se.trade + nvl(sts.receiving,0) /*- nvl(od.execqtty,0)*/ + nvl(od.buyqtty,0))*nvl(ext.price_asset,0)*nvl(ext.RATE_ASSET,0)/100)) seamt,
        sb.symbol, sb.codeid, nvl(ext.price_asset,0) price_asset, nvl(ext.RATE_ASSET,0) mrrate,
        se.trade, nvl(sts.receiving,0) receiving, nvl(od.execqtty,0) execqtty, nvl(od.buyqtty,0) buyqtty,
        item.specid, item.rate
        FROM semast se
        INNER JOIN afmast af ON af.acctno = se.afacctno
        INNER JOIN aftype aft ON af.actype = aft.actype
        INNER JOIN mrtype mrt ON aft.mrtype = mrt.actype
        INNER JOIN securities_info sb ON sb.codeid = se.codeid    
        INNER JOIN vw_basketext_acct_info ext ON af.acctno = ext.acctno and ext.symbol = sb.symbol
        LEFT JOIN 
             (select sum(buyqtty) buyqtty,sum(totalbuyqtty) totalbuyqtty, sum(execqtty) execqtty , afacctno, codeid
              from (
                    SELECT (case when od.exectype IN ('NB','BC')
                                            then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                    + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                            else 0 end) BUYQTTY,
                                            (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                        (case when od.exectype IN ('NS','MS') and od.stsstatus <> 'C' then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,AFACCTNO, CODEID
                    FROM odmast od, afmast af,
                                    (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                    (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                   where od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                   and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                   AND od.deltd <> 'Y'
                                   and not(od.grporder='Y' and od.matchtype='P')
                                   AND od.exectype IN ('NS', 'MS','NB','BC')           
                    )
                 where afacctno = '0001000602'
                 group by afacctno, codeid
               ) OD ON se.afacctno = od.afacctno AND se.codeid = od.codeid
         LEFT JOIN
           (select od.codeid,od.afacctno,
                              sum(case when duetype ='RM' then amt-aamt-famt+paidamt+paidfeeamt-amt*typ.deffeerate/100 else 0 end) mamt,
                              sum(case when duetype ='RS' and nvl(sts_trf.islatetransfer,0) = 0 and sts.txdate <> to_date(sy.varvalue,'DD/MM/RRRR') then qtty-aqtty else 0 end) receiving,
                              sum(case when duetype ='RS' and (nvl(sts_trf.islatetransfer,0) = 0 or sts_trf.trfbuydt = to_date(sy.varvalue,'DD/MM/RRRR')) and sts.txdate <> to_date(sy.varvalue,'DD/MM/RRRR') then qtty-aqtty else 0 end) t0receiving,
                              sum(case when duetype ='RS' and sts.txdate <> to_date(sy.varvalue,'DD/MM/RRRR') then qtty-aqtty else 0 end) totalreceiving
                          from stschd sts, odmast od, odtype typ,
                          (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer, trfbuydt from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                          sysvar sy
                          where sts.duetype in ('RM','RS') and sts.status ='N'
                              and sy.grname = 'SYSTEM' and sy.varname = 'CURRDATE'
                              and sts.deltd <>'Y' and sts.orgorderid=od.orderid and od.actype =typ.actype
                              and od.orderid = sts_trf.orgorderid(+)
                              and od.afacctno = '0001000602'
                              group by od.afacctno,od.codeid
                       ) sts ON sts.afacctno =se.afacctno and sts.codeid=se.codeid
        LEFT JOIN (SELECT * from LNSPECRATELIST WHERE specid = '0001') item on item.symbol = sb.symbol
        WHERE mrt.mrtype = 'T'
              AND af.acctno = '0001000602'
)

        
        select * from v_basket_ext_info;
       
        select * from securities_info where symbol = 'ACB';
        select * from vw_basketext_acct_info where acctno = '0001000602'; --AAA ABC ABI
        select * from LNSPECRATELIST where specid = '0001'; --AAA ABC ABI AGP
                                                           --AAA ABC ABI AGP ACB
        
        select sb.symbol from semast, sbsecurities sb where afacctno = '0001000602' and sb.codeid = semast.codeid;



select * from V_GETSECMARGININFO;
SELECT * from secbasketext where basketid = '1111';
FROM ALLCODE WHERE CDTYPE = 'SA' AND CDNAME = 'MARGINTYPE' and cdval <> 'L' ORDER BY LSTODR


create table LNAFRATEDTLHIST as select * from LNAFRATEDTL;
 
 
create table LNAFRATEDTL
(
  autoid        NUMBER,
  txdate        DATE,
  afacctno      VARCHAR2(20),
  codeid        VARCHAR2(10),
  symbol        VARCHAR2(100),
  balance       number(20), --tong so luong CK tinh vao tai san
  trade         number(20), --
  receiving     number(20),
  sending       number(20),
  buyqtty       number(20),
  price_asset   NUMBER(20),  --giá tính sm ứng với rổ,
  mrrate	      NUMBER(20),  --tỉ lệ tinh suc mua
  seamt         NUMBER(20),  -- balance*price_asset*mrrate
  assetamt      NUMBER(23),  --Tổng giá trị CK ưu đãi
  seamtrate     NUMBER(23,4),--Tỉ trọng ứng với mã CK
  intrate       NUMBER(23,4),--Tỷ lệ lãi ưu đãi
  specid        VARCHAR2(50)
);
create sequence seq_LNAFRATEDTL;
create table LNINTTRAN_BYASSET
(
  autoid         NUMBER,
  txdate         DATE,
  frdate         DATE,
  todate         DATE,
  afacctno       VARCHAR2(20),
  lnacctno       VARCHAR2(20),
  lnschdid       NUMBER,
  nml            NUMBER(23),
  nmlint         NUMBER(23,4),
  refid          NUMBER,
  intrate        NUMBER(23,4),
  intbal         NUMBER(23,4),
  seamtrate      NUMBER(23,4),
  codeid         VARCHAR2(10),
  symbol         VARCHAR2(100),
  specid         VARCHAR2(50)
);
create sequence seq_LNINTTRAN_BYASSET;
