CREATE VIEW VW_PRMASTER_DETAIL AS
SELECT PRCODE, PRNAME, PRTYPECD, PRTYPE, CUSTBANK, STATUSCD, STATUS, BRID,
       PRLIMIT, PRINUSED, PRLIMITEXT, PRINUSEDEXT,
       RLSAMT, RLSAMTEXT, REMAIN, REMAINEXT, TOTAL_REMAIN
FROM
(
select pr.prcode, pr.prname, pr.prtyp prtypecd, a1.cdcontent prtype, pr.custbank, pr.prstatus statuscd, a2.cdcontent status, 
       nvl(br.brid,'') brid,
       pr.prlimit + ext.prlimitext prlimit, pr.prinused + ext.prinusedext prinused,
       ext.prlimitext prlimitext, ext.prinusedext prinusedext,
       nvl(log.prinused,0) rlsamt, logext.prinused rlsamtext,
       pr.prlimit - pr.prinused - nvl(log.prinused,0) remain,
       ext.prlimitext - ext.prinusedext - logext.prinused remainext,
       pr.prlimit - pr.prinused - nvl(log.prinused,0) + ext.prlimitext - ext.prinusedext - logext.prinused total_remain
from prmaster pr, allcode a1, allcode a2,
     (select nvl(sum(prlimit),0) prlimitext, nvl(sum(prinused),0) prinusedext from prmaster where prtyp in ('P','T') and prstatus = 'A') ext,
     (select log.prcode, pr.prtyp, sum(log.prinused) prinused from prinusedlog log, prmaster pr where pr.prcode = log.prcode
             group by log.prcode, pr.prtyp) log,
     (select nvl(sum(log.prinused),0) prinused from prinusedlog log, prmaster pr 
             where pr.prcode = log.prcode and pr.prtyp in ('P','T') and pr.prstatus = 'A') logext,
     (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) br
where a1.cdname = 'POOLTYPE' and a1.cdtype = 'SY' and a1.cdval = pr.prtyp
      and a2.cdname = 'CFSTATUS' and a2.cdtype = 'CF' and a2.cdval = pr.prstatus
      and pr.prtyp in ('S') and log.prcode(+) = pr.prcode
      and br.prcode(+) = pr.prcode
union all
select pr.prcode, pr.prname, pr.prtyp prtypecd, a1.cdcontent prtype, pr.custbank, pr.prstatus statuscd, a2.cdcontent status, 
       nvl(br.brid,'') brid,
       pr.prlimit + ext.prlimitext prlimit, pr.prinused + ext.prinusedext prinused,
       ext.prlimitext prlimitext, ext.prinusedext prinusedext,
       nvl(log.prinused,0) rlsamt, logext.prinused rlsamtext,
       pr.prlimit - pr.prinused - nvl(log.prinused,0) remain,
       ext.prlimitext - ext.prinusedext - logext.prinused remainext,
       pr.prlimit - pr.prinused - nvl(log.prinused,0) + ext.prlimitext - ext.prinusedext - logext.prinused total_remain
from prmaster pr, allcode a1, allcode a2,
     (select nvl(sum(prlimit),0) prlimitext, nvl(sum(prinused),0) prinusedext from prmaster where prtyp in ('P') and prstatus = 'A') ext,
     (select log.prcode, pr.prtyp, sum(log.prinused) prinused from prinusedlog log, prmaster pr where pr.prcode = log.prcode
             group by log.prcode, pr.prtyp) log,
     (select nvl(sum(log.prinused),0) prinused from prinusedlog log, prmaster pr 
             where pr.prcode = log.prcode and pr.prtyp in ('P') and pr.prstatus = 'A') logext,
     (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) br
where a1.cdname = 'POOLTYPE' and a1.cdtype = 'SY' and a1.cdval = pr.prtyp
      and a2.cdname = 'CFSTATUS' and a2.cdtype = 'CF' and a2.cdval = pr.prstatus
      and pr.prtyp in ('U') and log.prcode(+) = pr.prcode
      and br.prcode(+) = pr.prcode
union all
select pr.prcode, pr.prname, pr.prtyp prtypecd, a1.cdcontent prtype, pr.custbank, pr.prstatus statuscd, a2.cdcontent status, 
       nvl(br.brid,'') brid,
       pr.prlimit prlimit, 0 prinused,
       pr.prlimit prlimitext, pr.prinused prinusedext,
       0 rlsamt, nvl(log.prinused,0) rlsamtext,
       0 remain,
       pr.prlimit - pr.prinused remainext,
       pr.prlimit - pr.prinused total_remain
from prmaster pr, allcode a1, allcode a2,
     (select log.prcode, pr.prtyp, sum(log.prinused) prinused from prinusedlog log, prmaster pr where pr.prcode = log.prcode
             group by log.prcode, pr.prtyp) log,
     (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) br
where a1.cdname = 'POOLTYPE' and a1.cdtype = 'SY' and a1.cdval = pr.prtyp
      and a2.cdname = 'CFSTATUS' and a2.cdtype = 'CF' and a2.cdval = pr.prstatus
      and pr.prtyp in ('T') and log.prcode(+) = pr.prcode
      and br.prcode(+) = pr.prcode
union all
select pr.prcode, pr.prname, pr.prtyp prtypecd, a1.cdcontent prtype, pr.custbank, pr.prstatus statuscd, a2.cdcontent status, 
       nvl(br.brid,'') brid,
       pr.prlimit prlimit, 0 prinused,
       pr.prlimit prlimitext, pr.prinused prinusedext,
       0 rlsamt, nvl(log.prinused,0) rlsamtext,
       0 remain,
       pr.prlimit - pr.prinused remainext,
       pr.prlimit - pr.prinused total_remain
from prmaster pr, allcode a1, allcode a2,
     (select log.prcode, pr.prtyp, sum(log.prinused) prinused from prinusedlog log, prmaster pr where pr.prcode = log.prcode
             group by log.prcode, pr.prtyp) log,
     (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) br
where a1.cdname = 'POOLTYPE' and a1.cdtype = 'SY' and a1.cdval = pr.prtyp
      and a2.cdname = 'CFSTATUS' and a2.cdtype = 'CF' and a2.cdval = pr.prstatus
      and pr.prtyp in ('P') and log.prcode(+) = pr.prcode
      and br.prcode(+) = pr.prcode
union all
select pr.prcode, pr.prname, pr.prtyp prtypecd, a1.cdcontent prtype, pr.custbank, pr.prstatus statuscd, a2.cdcontent status, 
       nvl(br.brid,'') brid,
       pr.prlimit + nvl(t.prlimitext,0) prlimit, pr.prinused + nvl(t.prinusedext,0) prinused,
       nvl(t.prlimitext,0) prlimitext, nvl(t.prinusedext,0) prinusedext,
       nvl(log.prinused,0) rlsamt, nvl(logext.rlsamtext,0) rlsamtext,
       pr.prlimit - pr.prinused - nvl(log.prinused,0) remain,
       nvl(t.prlimitext,0) - nvl(t.prinusedext,0) - nvl(logext.rlsamtext,0) remainext,
       pr.prlimit - pr.prinused - nvl(log.prinused,0) + nvl(t.prlimitext,0) - nvl(t.prinusedext,0) - nvl(logext.rlsamtext,0) total_remain
from prmaster pr, allcode a1, allcode a2,
     (select nvl(sum(prlimitext),0) prlimitext,nvl(sum(prinusedext),0) prinusedext,
       prcode, custbank
      from
        (
          select distinct nvl(brid.brid,'') bridlist, pr.prcode, pr.custbank, ext.prcode prcodeext, ext.prlimitext, ext.prinusedext
          from prmaster pr,
              (select nvl(sum(pr.prlimit),0) prlimitext, nvl(sum(pr.prinused),0) prinusedext, br.brid, pr.custbank, pr.prcode from prmaster pr, bridmap br 
                       where pr.prtyp in ('T') and pr.prstatus = 'A' and br.prcode = pr.prcode
                       group by pr.prcode, br.brid, pr.custbank) ext,
              (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) brid
          where pr.custbank = ext.custbank
                and (case when instr(nvl(brid.brid,''),'ALL') > 0 then 'Y'
                          when ext.brid = 'ALL' then 'Y'
                          else (case when instr(nvl(brid.brid,''),ext.brid) > 0 then 'Y' else 'N' end)
                     end) = 'Y'
                and pr.prtyp = 'A'
                and pr.prcode = brid.prcode(+)
        )
      group by prcode, custbank) t,
     (select log.prcode, pr.prtyp, sum(log.prinused) prinused from prinusedlog log, prmaster pr where pr.prcode = log.prcode
             group by log.prcode, pr.prtyp) log,
     (select nvl(sum(prinused),0) rlsamtext,
            prcode, custbank
      from
        (
          select distinct nvl(brid.brid,'') bridlist, pr.prcode, pr.custbank, ext.prcode prcodeext, ext.prinused
          from prmaster pr,
              (select nvl(sum(log.prinused),0) prinused, br.brid, pr.custbank, pr.prcode from prinusedlog log, prmaster pr, bridmap br 
                       where pr.prtyp in ('T') and pr.prstatus = 'A' and br.prcode = pr.prcode and log.prcode = pr.prcode
                       group by pr.prcode, br.brid, pr.custbank) ext,
              (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) brid
          where pr.custbank = ext.custbank
                and (case when instr(nvl(brid.brid,''),'ALL') > 0 then 'Y'
                          when ext.brid = 'ALL' then 'Y'
                          else (case when instr(nvl(brid.brid,''),ext.brid) > 0 then 'Y' else 'N' end)
                     end) = 'Y'
                and pr.prtyp = 'A'
                and pr.prcode = brid.prcode(+)
        )
      group by prcode, custbank) logext,
     (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) br
where a1.cdname = 'POOLTYPE' and a1.cdtype = 'SY' and a1.cdval = pr.prtyp
      and a2.cdname = 'CFSTATUS' and a2.cdtype = 'CF' and a2.cdval = pr.prstatus
      and pr.prtyp in ('A') and log.prcode(+) = pr.prcode
      and pr.prcode = t.prcode(+) and pr.custbank = t.custbank(+)
      and br.prcode(+) = pr.prcode
      and pr.prcode=logext.prcode(+) and pr.custbank = logext.custbank(+)
union all
select pr.prcode, pr.prname, pr.prtyp prtypecd, a1.cdcontent prtype, pr.custbank, pr.prstatus statuscd, a2.cdcontent status, 
       nvl(br.brid,'') brid,
       pr.prlimit + nvl(t.prlimitext,0) prlimit, pr.prinused + nvl(t.prinusedext,0) prinused,
       nvl(t.prlimitext,0) prlimitext, nvl(t.prinusedext,0) prinusedext,
       nvl(log.prinused,0) rlsamt, nvl(logext.rlsamtext,0) rlsamtext,
       pr.prlimit - pr.prinused - nvl(log.prinused,0) remain,
       nvl(t.prlimitext,0) - nvl(t.prinusedext,0) - nvl(logext.rlsamtext,0) remainext,
       pr.prlimit - pr.prinused - nvl(log.prinused,0) + nvl(t.prlimitext,0) - nvl(t.prinusedext,0) - nvl(logext.rlsamtext,0) total_remain
from prmaster pr, allcode a1, allcode a2,
     (select nvl(sum(prlimitext),0) prlimitext,nvl(sum(prinusedext),0) prinusedext, prcode
      from
        (
          select distinct nvl(brid.brid,'') bridlist, pr.prcode, pr.custbank, ext.prcode prcodeext, ext.prlimitext, ext.prinusedext
          from prmaster pr,
              (select nvl(sum(pr.prlimit),0) prlimitext, nvl(sum(pr.prinused),0) prinusedext, br.brid, pr.prcode from prmaster pr, bridmap br 
                       where pr.prtyp in ('P') and pr.prstatus = 'A' and br.prcode = pr.prcode
                       group by pr.prcode, br.brid) ext,
              (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) brid
          where (case when instr(nvl(brid.brid,''),'ALL') > 0 then 'Y'
                          when ext.brid = 'ALL' then 'Y'
                          else (case when instr(nvl(brid.brid,''),ext.brid) > 0 then 'Y' else 'N' end)
                end) = 'Y'
                and pr.prtyp = 'M'
                and pr.prcode = brid.prcode(+)
        )
      group by prcode) t,
     (select log.prcode, pr.prtyp, sum(log.prinused) prinused from prinusedlog log, prmaster pr where pr.prcode = log.prcode
             group by log.prcode, pr.prtyp) log,
     (select nvl(sum(prinused),0) rlsamtext, prcode
      from
        (
          select distinct nvl(brid.brid,'') bridlist, pr.prcode, pr.custbank, ext.prcode prcodeext, ext.prinused
          from prmaster pr,
              (select nvl(sum(log.prinused),0) prinused, br.brid, pr.prcode from prinusedlog log, prmaster pr, bridmap br 
                       where pr.prtyp in ('P') and pr.prstatus = 'A' and br.prcode = pr.prcode and log.prcode = pr.prcode
                       group by pr.prcode, br.brid) ext,
              (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) brid
          where (case when instr(nvl(brid.brid,''),'ALL') > 0 then 'Y'
                          when ext.brid = 'ALL' then 'Y'
                          else (case when instr(nvl(brid.brid,''),ext.brid) > 0 then 'Y' else 'N' end)
                end) = 'Y'
                and pr.prtyp = 'M'
                and pr.prcode = brid.prcode(+)
        )
      group by prcode) logext,
     (select prcode, listagg(brid, ', ') within group (order by brid) brid from bridmap group by prcode) br
where a1.cdname = 'POOLTYPE' and a1.cdtype = 'SY' and a1.cdval = pr.prtyp
      and a2.cdname = 'CFSTATUS' and a2.cdtype = 'CF' and a2.cdval = pr.prstatus
      and pr.prtyp in ('M') and log.prcode(+) = pr.prcode
      and pr.prcode = t.prcode(+)
      and br.prcode(+) = pr.prcode
      and pr.prcode=logext.prcode(+)
)
WHERE 0=0;

