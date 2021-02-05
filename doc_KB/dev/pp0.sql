
--Tinhs PPo
--v_advanceSchedule
/*
balance: Số dư
OD.secureamt: Ký quỹ của lệnh
avladvance: sum(depoamt) from v_advanceSchedule
*/

            select count(1)
               -- into l_count
            from afmast af
            where af.acctno = '0001000601'
            and exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y');

            if l_count > 0 then
                l_isChkSysCtrlDefault:='Y';
            else
                l_isChkSysCtrlDefault:='N';
            end if;
         --Tai khoan margin khong tham gia group
         OPEN pv_refcursor FOR
              SELECT
                  af.acctno,
                  case when 'Y'='Y' then
                   least(round(--af.advanceline +
                                ci.balance
                               - nvl(OD.secureamt,0)
                               + nvl(adv.avladvance,0)
                               + least(nvl(AF.mrcrlimitmax,0) + nvl(af.mrcrlimit,0) - dfodamt ,
                                       nvl(af.mrcrlimit,0) + nvl(se.semramt,0))
                               - nvl(ci.odamt,0)
                               -nvl(dfdebtamt,0)
                               - nvl(dfintdebtamt,0)
                               - ramt
                               - ci.depofeeamt,
                               0)
                          ,
                           round(--af.advanceline +
                           ci.balance
                           - nvl(OD.secureamt,0)
                           + nvl(adv.avladvance,0)
                           + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,
                                   nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                           -nvl(dfdebtamt,0)
                           - nvl(dfintdebtamt,0)
                           - nvl(ci.odamt,0)
                           - ramt
                           - ci.depofeeamt,0)
                    )
                   else
                     round(--af.advanceline +
                           ci.balance
                           - nvl(OD.secureamt,0)
                           + nvl(adv.avladvance,0)
                           + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,
                                   nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                           -nvl(dfdebtamt,0)
                           - nvl(dfintdebtamt,0)
                           - nvl(ci.odamt,0)
                           - ramt
                           - ci.depofeeamt,0)
                   END PP,
                  case when 'Y'='Y' then
                   least(round(--af.advanceline +
                                ci.balance
                               - nvl(OD.secureamt,0)
                               + nvl(adv.avladvance,0)
                               + least(nvl(AF.mrcrlimitmax,0) + nvl(af.mrcrlimit,0) - dfodamt ,
                                       nvl(af.mrcrlimit,0) + nvl(se.semramt,0))
                               - nvl(ci.odamt,0)
                               -nvl(dfdebtamt,0)
                               - nvl(dfintdebtamt,0)
                               - ramt
                               - ci.depofeeamt,0),
                           round(--af.advanceline +
                           ci.balance
                           - nvl(OD.secureamt,0)
                           + nvl(adv.avladvance,0)
                           + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,
                                   nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                           - nvl(ci.odamt,0)
                           -nvl(dfdebtamt,0)
                           - nvl(dfintdebtamt,0)
                           - ramt
                           - ci.depofeeamt,0)
                   )
                   else
                         round(--af.advanceline +
                       ci.balance
                       - nvl(OD.secureamt,0)
                       + nvl(adv.avladvance,0)
                       + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,
                               nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                       - nvl(ci.odamt,0)
                       -nvl(dfdebtamt,0)
                       - nvl(dfintdebtamt,0)
                       - ramt
                       - ci.depofeeamt,0)
                   END PPREF,
                   ROUND(
                   nvl(adv.avladvance,0) + nvl(af.advanceline,0)  + nvl(AF.mrcrlimitmax,0)
                   +nvl(af.mrcrlimit,0)- ci.dfodamt + ci.balance - ci.odamt
                   - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt -  nvl(OD.secureamt,0) - ci.ramt)
                    avllimit,
                    GREATEST ( nvl(adv.avladvance,0) + ci.balance
                             - ci.odamt
                             - ci.dfdebtamt
                             - ci.dfintdebtamt
                             /*- NVL (advamt, 0)*/
                             - NVL (od.secureamt, 0)
                             - ci.ramt
                             - ci.depofeeamt,
                             0
                            ) avlwithdraw
           from  cimast ci ,
                 (SELECT af.*,CASE WHEN exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y')
                                            THEN 'Y' ELSE 'N' END isChkSysCtrlDefault
                 from afmast af
                 --
                 where acctno = '0001000601') af,
                 --v_getbuyorderinfo ,
                  (SELECT
                    od.afacctno afacctno,
                    sum(od.quoteprice* od.remainqtty* (od.bratio/100)
                         + od.execamt * (od.bratio/100)
                         + od.execamt * (case when od.execqtty<=0 then 0 else od.dfqtty/od.execqtty end) * (1 + typ.deffeerate / 100 - od.bratio/100)
                         + nvl( greatest((abod.ORDERQTTY-od.execqtty) * abod.BRATIO/100 * abod.QUOTEPRICE - od.remainqtty * od.QUOTEPRICE * od.BRATIO/100  ,0),0))   secureamt
                     FROM odmast od, odtype typ,  sysvar sy_CURRDATE,
                          ( select om.reforderid,om.orderqtty,om.quoteprice,om.bratio
                            from odmast om, ood od
                            where om.exectype ='AB'
                            and om.orderid = od.orgorderid
                            and od.oodstatus='N'   )abod
                     WHERE od.actype = typ.actype
                         AND od.txdate = to_date(sy_CURRDATE.VARVALUE,'DD/MM/RRRR')
                         AND od.deltd <> 'Y'
                         AND od.exectype IN ('NB', 'BC')
                         and od.stsstatus <> 'C'
                         and od.orderid = abod.REFORDERID(+)
                        and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
                        --
                        and od.afacctno = '0001000601'
                      group by od.afacctno
                            ) OD,
                 --v_getsecmargininfo se,
                 ( select se.afacctno ,
                   sum ((case when se.roomchk ='Y' then least(se.trade + se.receiving - se.execqtty + se.buyqtty,nvl(sy_pravlremain,0) + nvl(sy_prinused,0))
                        else (se.trade + se.receiving - se.execqtty + se.buyqtty) end)
                          * nvl(rsk1.mrratioloan,0)/100
                          * least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0)))
                       SEAMT,
                   sum ((case when se.roomchk ='Y' then least(se.trade + se.receiving - se.execqtty + se.buyqtty, nvl(pravlremain,0) + nvl(prinused,0))
                        else (se.trade + se.receiving - se.execqtty + se.buyqtty) end)
                        * least(nvl(rsk2.mrratioloan,0),100-se.mriratio)/100
                        * least(sb.MARGINREFPRICE,nvl(rsk2.mrpriceloan,0))) SEMRAMT
                   from
                    (select se.roomchk,se.codeid, af.actype, af.mriratio, af.acctno afacctno,se.acctno, se.trade ,
                        nvl(sts.receiving,0) receiving,
                        nvl(od.BUYQTTY,0) BUYQTTY,
                        nvl(od.EXECQTTY,0) EXECQTTY,
                        nvl(afpr.prinused,0) prinused,
                        nvl(afpr.sy_prinused,0) sy_prinused
                     from semast se,
                             afmast af,
                            (select sum(BUYQTTY) BUYQTTY,
                                    sum(EXECQTTY) EXECQTTY , AFACCTNO, CODEID
                                    from (
                                        SELECT (case when od.exectype IN ('NB','BC')
                                                    then  REMAINQTTY + EXECQTTY - DFQTTY
                                                    else 0 end) BUYQTTY,
                                                (case when od.exectype IN ('NS','MS') and od.stsstatus <> 'C'
                                                    then EXECQTTY
                                                    else 0 end) EXECQTTY,AFACCTNO, CODEID
                                        FROM odmast od
                                        where
                                            od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                           AND od.deltd <> 'Y'
                                           and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                           AND od.exectype IN ('NS', 'MS','NB','BC')
                                        )
                             group by AFACCTNO, CODEID
                             ) OD,
                            (SELECT sts.CODEID,sts.AFACCTNO,
                                SUM( QTTY-AQTTY ) RECEIVING
                             FROM STSCHD STS,  sysvar sy
                             WHERE STS.DUETYPE IN ('RS') AND STS.STATUS ='N'
                                and sy.grname = 'SYSTEM' and sy.varname = 'CURRDATE'
                                AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR')
                                AND STS.DELTD <>'Y'
                                GROUP BY sts.AFACCTNO,sts.CODEID
                              ) sts,
                            (  select afacctno, codeid,
                                    nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                    nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                                from vw_afpralloc_all
                                group by afacctno, codeid
                            ) afpr
                     where     se.afacctno =af.acctno
                               and  se.afacctno =OD.afacctno (+)
                               and  se.codeid = OD.codeid(+)
                               and  se.afacctno = sts.afacctno(+)
                               and  se.codeid = sts.codeid(+)
                               and  se.afacctno = afpr.afacctno (+)
                               and  se.codeid = afpr.codeid(+)
                        ) se,
                        afserisk rsk1,
                        afmrserisk rsk2,
                        securities_info sb,
                        (
                            select pr.codeid,
                                greatest(max(pr.roomlimit) -
                                         nvl(sum(case when restype = 'M' then nvl(afpr.prinused,0) else 0 end),0),0) pravlremain,
                                greatest(max(pr.syroomlimit)- max(pr.syroomused)
                                        - nvl(sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end),0),0) sy_pravlremain
                            from vw_marginroomsystem pr, vw_afpralloc_all afpr
                            where pr.codeid = afpr.codeid(+)
                            group by pr.codeid
                        ) pr
                        where se.codeid = pr.codeid
                        and (se.actype =rsk1.actype and se.codeid=rsk1.codeid)
                        and (se.actype =rsk2.actype and se.codeid=rsk2.codeid)
                        and se.codeid=sb.codeid
                        group by se.afacctno
                 )se,
           (select sum(depoamt) avladvance,afacctno
            from v_getAccountAvlAdvance group by afacctno) adv
           WHERE   ci.acctno=af.acctno
             and   ci.acctno=se.afacctno(+)
             AND   ci.acctno = od.afacctno(+)
             AND   CI.ACCTNO = ADV.afacctno(+)
             and   ci.acctno =  0001000601;
