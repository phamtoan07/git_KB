--Debug pr_GetPPSE
-------
 select se.marginprice, se.marginrefprice, se.floorprice, se.codeid, se.tradelot, sb.sectype
        --into l_MarginPrice, l_MarginRefPrice, l_FloorPrice, l_codeid, l_TradeLot, l_SecType
        --     48600	        48600	            43800	        000430	  100	        001
    from securities_info se, sbsecurities sb
    where se.codeid = sb.codeid and se.symbol = 'ACB';
-------  
 select actype l_Aftype from afmast where acctno = '0001000601'; --0087
-------
  SELECT deffeerate/100
       --into l_DefFeeRate
       FROM (  SELECT a.deffeerate, b.ODRNUM
               FROM odtype a, afidtype b
               WHERE     a.status = 'Y'
                     AND (a.via = 'O' OR a.via = 'A') 
                     AND (instr(case when '001' in ('001','002','011') then '001' || ',' || '111,333'
                                     when '001' in ('003','006') then '001' || ',' || '222,333,444'
                                     when '001' in ('008') then '001' || ',' || '111,444'
                                     else '001' end , a.sectype)>0 OR a.sectype = '000')
                     AND (CASE WHEN A.CODEID IS NULL THEN '000430' ELSE A.CODEID END)='000430'
                     AND a.actype = b.actype and b.aftype='0087' and b.objname='OD.ODTYPE'
               ORDER BY CASE WHEN (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'ORDER_ORD') = 'ODRNUM' THEN ODRNUM ELSE DEFFEERATE END ASC
             ) where rownum<=1;
--------          
   select nvl(fn_getmaxdeffeerate('0001000601'),0)  l_DefFeeRate from dual; --0.003
   
   select max(odt.deffeerate)  l_maxdeffeerate
   from afmast af, afidtype afid, odtype odt
   where af.actype = afid.aftype and afid.objname = 'OD.ODTYPE' and odt.actype = afid.actype and odt.status = 'Y' and af.acctno = '0001000601';
   
   select max(deffeerate) l_maxdeffeerate from odtype where status = 'Y';

--------
l_quoteprice:= greatest(p_quoteprice,l_FloorPrice); --43800
--------
select mrt.mrtype, nvl(chksysctrl,'N'), (af.trfbuyext * af.trfbuyrate) --
        --into l_MarginType, l_ChkSysCtrl, l_IsLateTransfer
        --     T             N             0
    from afmast af, aftype aft, lntype lnt, mrtype mrt
    where af.actype  = aft.actype and aft.lntype = lnt.actype(+) and aft.mrtype = mrt.actype and af.acctno = '0001000601';
--------
select rsk.mrratioloan/100, rsk.mrpriceloan, rsk.ismarginallow
                --into l_RskMarginRate, l_RskMarginPrice, l_IsMarginAllow
                --     0.5              20000.0000        Y
            from afmast af, afserisk rsk
            where af.actype = rsk.actype and af.acctno = '0001000601' and rsk.codeid = '000430';
exception when others then
            l_RskMarginRate:=0;
            l_RskMarginPrice:=0;
            l_IsMarginAllow:='N';
            l_RskMarginRate_in_basket:=null;
            l_RskMarginPrice_in_basket:=null;

select * from afserisk where actype = '0087' for update;
insert into afserisk (CODEID, ACTYPE, MRRATIORATE, MRRATIOLOAN, MRPRICERATE, MRPRICELOAN, EXPDATE, ISMARGINALLOW)
values ('000430', '0123', 70.0000, 50.0000, 15000.0000, 20000.0000, null, 'Y');

select * from user_source where upper(text) like '%INSERT INTO AFSERISK%';

select * from user_source where upper(text) like '%FN_APPLYSYSTEMPARAM%';
--------
SELECT cf.t0loanrate l_t0loanrate, nvl(af.deal,'Y') l_deal -- 0, Y
FROM cfmast cf, afmast af
WHERE cf.custid = af.custid AND af.acctno = '0001000601';
select * from afmast where acctno = '0001000601';
   /*     exception when others then
            l_t0loanrate:=0;
            'Y':='Y';
        END;*/
--------
if l_ChkSysCtrl = 'Y' then
            if l_IsMarginAllow = 'N' then
                l_RskMarginRate:=0;
            else
                l_MarginPrice:= least(l_MarginPrice, l_MarginRefPrice, l_RskMarginPrice);
                --select least(48600,48600,20000) from dual; = 20000
            end if;
            select (1-to_number(varvalue)/100) into l_SysMarginRate from sysvar where varname = 'IRATIO' and grname = 'MARGIN';
            l_RskMarginRate:=least(l_RskMarginRate,l_SysMarginRate);
        else
            l_MarginPrice:= least(l_MarginPrice, l_RskMarginPrice);
        end if;
else
  --l_MarginPrice:= least(l_MarginPrice, l_RskMarginPrice);
  l_MarginPrice:= least(46800, 20000); -> 20000;
  select cf.custatcom from cfmast cf where custodycd = '091C000207' for update;
  select * from afmast where acctno = '0001000601';
  select * from cimast where acctno = '0001000601';
-------- ứng trước ?
select round(nvl(adv.avladvance,0) + nvl(balance,0)- nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0)  - nvl (overamt,0) -nvl(secureamt,0) +
           CASE WHEN 'Y' = 'N' THEN greatest(least(ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt -
                NVL(ci.ovamt,0),0) * 0 /100,nvl(v_getsec.SELIQAMT2,0))),af.advanceline),0) ELSE af.advanceline END
           - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - nvl(depofeeamt,0) + AF.mrcrlimitmax+nvl(AF.mrcrlimit,0) - dfodamt,0),
        CASE WHEN 'Y' = 'N' THEN greatest(least(ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt -
        NVL(ci.ovamt,0),0) * 0 /100,nvl(v_getsec.SELIQAMT2,0)))
        ,af.advanceline),0) ELSE af.advanceline END advanceline,
        nvl(b.trft0amt,0), (nvl(b.buyamt,0) * af.trfbuyrate/100)  + (case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end)
        --into l_AvlLimit, l_Advanceline, l_Trft0amt, l_T0SecureAmt
        --     5000000     0              0           0
    from cimast ci inner join afmast af on ci.acctno=af.acctno
        left join
        (select * from v_getbuyorderinfo where afacctno = '0001000601') b
        on  ci.acctno = b.afacctno
        LEFT JOIN
        (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from v_getAccountAvlAdvance where afacctno = '0001000601' group by afacctno) adv
        on adv.afacctno=ci.acctno
        LEFT JOIN
        (select * from v_getdealpaidbyaccount p where p.afacctno = '0001000601') pd
        on pd.afacctno=ci.acctno
        LEFT JOIN
        (SELECT * FROM v_getsecmargininfo_ALL) v_getsec
        ON ci.acctno = v_getsec.afacctno
        where ci.acctno = '0001000601';
/*Tính avlLimit*/
select * from v_getbuyorderinfo where afacctno = '0001000601'; 
--b.secureamt = (số tiền mua đã khớp + phí đã khớp) +  (số tiền chưa mua + phí chưa mua) + df? + số tiền chênh lệch lệnh sửa bán nếu Host active
        --  = sum(execbuyamt)= tiền mua + phí mua đã khớp. hosts: inactive
--b.trft0amt, b.trft0addamt, b.trfsecuredamt
--af.ADVANCELINE Bảo lãnh cấp cho tiểu khoản
  --          select * from tltx where tltxcd in ('1158','1186','1805','1810','1811','1812','1816','1818');
--ADV.avladvance: v_getaccountavladvance -> V_ADVANCESCHEDULE = depoamt = (stschd.amt-số tiền lãi)... Số tiền thanh toán -> tiền bán ứng trước
  --
--v_getsec.senavamt:  Tai san tinh tai san rong,  v_getsec.SELIQAMT2: Gia tri thanh khoan cua tai san (Khả năng thanh toán)

--vw_afpralloc_all: Pool, room
        
--ci.T0ODAMT: Tổng số tiền chờ nhận vay bảo lãnh, ci.DUEAMT: Tổng số tiền vay đến hạn của tài khoản, OVAMT: Tổng số tiền vay quá hạn của tài khoản
--ci.DFODAMT: Tổng số tiền vay theo deal, ci.RAMT, ci.depofeeamt: phí lưu ký?, mrcrlimitmax mrcrlimit
/*
AF.MRIRATE: Tỷ lệ an toàn tài khoản. Dùng cho hợp đồng margin
AF.MRMRATE: Tỷ lệ call tài khoản. Dùng cho hợp đồng margin
AF.MRLRATE: Tỷ lệ xử lý tài khoản. Dùng cho hợp đồng margin
AF.MRDUEDAY: Số ngày ân hạn. Số ngày kể từ ngày đến hạn mà không tính lãi quá hạn. Dùng cho hợp đồng margin
AF.MREXTDAY: Số ngày được phép gia hạn tối đa. Dùng cho hợp đồng margin
AF.MRCLAMT: Giá trị tài sản đảm bảo ngoài chứng khoán. Dùng để tăng sức mua chơ hợp đồng margin
AF.MRCRLIMIT: Hạn mức cấp dựa trên tổng tài sản đảm bảo ngoài chứng khoán. Dùng để tính vào sức mua -> Tiền gửi tiết kiệm
AF.MRCRLIMITMAX: Hạn mức vay tối đa của tiểu khoản
*/
select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from     
where afacctno = '0001000601' group by afacctno;
select * from v_getdealpaidbyaccount p where p.afacctno = '0001000601';
SELECT * FROM v_getsecmargininfo_ALL;

--==END Tính avlLimit=====
-----------
/*l_RskMarginRate=0.5, l_MarginPrice = 20000, l_quoteprice = 44000
l_IsLateTransfer = 0
l_pp0:=5000000;
l_pp0Ref:=5000000;
l_Advanceline = 0;
l_Trft0amt = 0;
l_DefFeeRate = 0.003
*/
    select (1- 0.5 * 20000/44000) from dual; -- 0.772727272727273
    if  (1 - l_RskMarginRate * l_MarginPrice/l_quoteprice) <> 0 and l_IsLateTransfer = 0 then
        --(1 - 0.5 * 15800/13500)
        l_ppSE:=(l_pp0+ greatest(l_Advanceline - l_Trft0amt,0)) /
              ((1 + l_DefFeeRate - l_RskMarginRate * l_MarginPrice/l_quoteprice)
              /(1 + l_DefFeeRate))  - l_T0SecureAmt;
        --l_ppSE: = 6464900.97269425
        select (5000000  + greatest(0 - 0,0)) /((1 + 0.003 - 0.5 * 20000/44000)/(1 + 0.003)) - 0 from dual;
    else
        l_ppSE:=l_pp0 + greatest(l_Advanceline - l_Trft0amt,0) - l_T0SecureAmt;
    end if;
    if (1 - l_RskMarginRate * l_MarginPrice/l_quoteprice) <> 0 then
        l_ppSERef:=(l_pp0Ref+ greatest(l_Advanceline - l_Trft0amt,0)) /
                       ((1 + l_DefFeeRate - l_RskMarginRate * l_MarginPrice/l_quoteprice)/(1 + l_DefFeeRate)) ;
        select (5000000+ greatest(0 - 0,0))/ ((1 + 0.003 - 0.5 * 20000/44000)/(1 + 0.003)) from dual; --6464900.97269425
    else
        l_ppSERef:=l_pp0Ref + greatest(l_Advanceline - l_Trft0amt,0);
    end if;
-----------xu ly room đặc biệt
select nvl(roomchk,'Y') l_roomchk from semast se
        where se.afacctno = '0001000601' and se.codeid = '000430';
--vw_marginroomsystem: securities_info se, securities_risk rsk
--vw_afpralloc_all
-----------
 select greatest(r1.syroomlimit - r1.syroomused - nvl(u1.sy_prinused,0),0) avlsyroom,
                   greatest(r1.roomlimit - nvl(u1.prinused,0),0) avlroom
                   -- into l_avlsyroomqtty, l_avlroomqtty
                   --      0                1673525
            from vw_marginroomsystem r1,
            (select codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                        sum(case when restype = 'S' then prinused else 0 end) sy_prinused
                from vw_afpralloc_all
                where codeid = '000430'
                group by codeid) u1
            where r1.codeid = u1.codeid(+)
            and r1.codeid = '000430';
------------
---afpralloc
select * from AFPRALLOC;
select * from fldmaster where objname like '%AFPRALLOC%';

select * from semast se where se.afacctno = '0001000601' and se.codeid = '000430';

select se.codeid, case when rsk.ismarginallow = 'Y' then least(se.roomlimit,se.roomlimitmax) else 10000000000 end roomlimit,
se.syroomlimit, se.syroomused
from securities_info se, securities_risk rsk
where se.codeid = rsk.codeid(+)
      and roomlimit > 0
      and se.codeid = '000430';
      
select * from securities_info where codeid= '000430';

select * from user_source where upper(text) like '%SYROOMLIMIT%';
select * from user_source where upper(text) like '%INSERT INTO AFPRALLOC%';
select * from allcode where cdname = 'RESTYPE';

select codeid, case when restype = 'M' then prinused else 0 end prinused,
               case when restype = 'S' then prinused else 0 end sy_prinused
                from vw_afpralloc_all
                where codeid = '000430'
                group by codeid
------------
--l_avlroomqtty= 1673525, l_avlsyroomqtty = 0
    select greatest(nvl(0 + nvl(sy_prinused,0),0) - nvl(least(trade + receiving - execqtty + buyqtty,0 + nvl(sy_prinused,0)),0),0) avlsyqtty,
                   greatest(nvl(0 + nvl(prinused,0),0) - nvl(least(trade + receiving - execqtty + buyqtty,0 + nvl(prinused,0)),0),0) avlqtty
               --into l_avlsyqtty, l_avlqtty
            from
            (select se.codeid, af.actype,se.afacctno,se.acctno, se.trade + se.grpordamt trade, nvl(sts.receiving,0) receiving,nvl(sts.TOTALRECEIVING,0) TOTALRECEIVING,nvl(BUYQTTY,0) BUYQTTY,nvl(TOTALBUYQTTY,0) TOTALBUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY,  nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused
              from (select * from semast where afacctno = '0001000601' and codeid = '000430') se
                inner join (select * from afmast where acctno = '0001000601') af on se.afacctno =af.acctno
              left join
              (select sum(buyqtty) buyqtty, sum(TOTALBUYQTTY) TOTALBUYQTTY, sum(execqtty) execqtty , seacctno
                      from (
                          SELECT (case when od.exectype IN ('NB','BC')
                                      then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                              + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                      else 0 end) BUYQTTY,
                                 (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                 (case when od.exectype IN ('NS','MS') then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,SEACCTNO
                          FROM odmast od, afmast af, (select orgorderid, (trfbuyext * trfbuyrate) * (amt- trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                        (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                             where od.afacctno = '0001000601' and od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                             and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                             AND od.deltd <> 'Y'
                             and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                             AND od.exectype IN ('NS', 'MS','NB','BC')
                          )
               group by seacctno
               ) OD
              on OD.seacctno =se.acctno
              left join
              (SELECT STS.CODEID,STS.AFACCTNO,
                      SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE') THEN QTTY-AQTTY ELSE 0 END) RECEIVING,
                      SUM(CASE WHEN DUETYPE ='RS' and STS.TXDATE <> (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE') THEN QTTY-AQTTY ELSE 0 END) TOTALRECEIVING
                  FROM STSCHD STS, ODMAST OD, ODTYPE TYP, (select orgorderid, (trfbuyext * trfbuyrate) * (amt - trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf
                  WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                      AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                      and od.orderid = sts_trf.orgorderid(+) and sts.afacctno = '0001000601'
                      GROUP BY STS.AFACCTNO,STS.CODEID
               ) sts
              on sts.afacctno =se.afacctno and sts.codeid=se.codeid
              left join
              (
                  select afacctno, codeid,
                      nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                      nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                  from vw_afpralloc_all
                  where codeid = '000430' and afacctno = '0001000601'
                  group by afacctno, codeid
              ) afpr  on afpr.afacctno =se.afacctno and afpr.codeid=se.codeid
            ) se,
            afmast af, afserisk rsk,securities_info sb
            where se.afacctno =af.acctno and se.codeid=sb.codeid
            and se.codeid=rsk.codeid (+) and se.actype =rsk.actype (+)
            and se.afacctno = '0001000601' and se.codeid = '000430';
            
select * from user_source where upper(
-----------------
        if l_ChkSysCtrl = 'Y' then
            l_PP0_add:= l_RskMarginRate * l_MarginPrice * LEAST(l_avlsyqtty,l_avlqtty);
            select  0.5 * 20000*1673525 from dual; --16735250000
        else 
            l_PP0_add:= l_RskMarginRate * l_MarginPrice * l_avlsyqtty;
            select 0.5 * 20000* 0 from dual= 0;
        end if;
        --l_ppSE: = 6464900.97269425
        l_PPse:= least(l_PPse,l_pp0 + greatest(l_Advanceline - l_Trft0amt,0) - l_T0SecureAmt + l_PP0_add);
        select least(6464900,5000000 + greatest(0 - 0,0) - 0 + 16735250000) from dual;--6464900
        
        l_ppSERef:= least(l_ppSERef,l_pp0Ref + greatest(l_Advanceline - l_Trft0amt,0) + l_PP0_add);
        select least(6464900,5000000 + greatest(0 - 0,0)+ 16735250000) from dual;--6464900    
-------------------
        l_ppSE:= least(l_ppSE,l_AvlLimit); --l_AvlLimit= 5000000
        l_ppSERef:= least(l_ppSERef,l_AvlLimit);
