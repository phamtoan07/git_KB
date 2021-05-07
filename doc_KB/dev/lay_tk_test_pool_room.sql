select af.acctno, odamt, odamt - nvl(t0.t0prin,0) amt, cf.brid, af.actype, nvl(t0.t0prin,0) t0prin,
      nvl(lnt.chksysctrl,'N') chksysctrl, lnt.actype
      from cimast ci, cfmast cf, afmast af,
           (select trfacctno,
                   sum(oprinnml + oprinovd + ointnmlacr + ointdue + ointovdacr + ointnmlovd) t0prin
            from lnmast ln, lntype lnt
                         where ln.actype = lnt.actype and ln.ftype = 'AF'
                         group by trfacctno) t0,
            aftype aft, mrtype mrt, lntype lnt
      where ci.acctno = af.acctno
            and cf.custid = af.custid and af.acctno = t0.trfacctno(+)
            and ci.odamt > 0
            --
            and af.actype = aft.actype and aft.mrtype = mrt.actype 
            and aft.lntype = lnt.actype(+) and mrt.mrtype = 'T'
            and af.acctno in (select acctno from  
                (SELECT pr.prcode, af.acctno from  prmaster pr, afmast af, aftype typ, lntype LN 
                 WHERE af.actype = typ.actype and typ.lntype = ln.Actype 
                      AND ln.Custbank = pr.custbank
                      and pr.prcode = '1407'))
           and af.acctno = '0002008233';
----
----
select * from prmaster where prcode = '1407';
select actype from afmast where acctno = '0002008233';
select * from prtypemap where actype = '9301';
select * from pracctnomap where acctno = '0002008233';
      
---
select * from tlog where luser = user order by id desc;
 
