﻿select * from pracctnomap where prcode = '1407' for update;
select * from prmaster where prtyp in ('S','U') or prcode = '1407';
--3112125929062 3045754003101
--
/*
Hệ thống: 3090823169582
UB:       3048929419856
1407:     24588840598
Dư nợ tiểu khoản: 5145774307
*/
select 3093238238097 - 3088464535487 from dual; --4773702610
--
select * from prmasterlog order by createdate desc; --0001037053

select * from t_fo_event order by autoid desc;
select isfo from afmast where acctno = '0006000649';
select * from tlog where luser = user order by id desc;
---
--delete from t_fo_inday_ownpoolroom;
select * from t_fo_inday_ownpoolroom;

SELECT NVL(varvalue, 'OFF')  v_FOMODE FROM sysvar WHERE varname = 'FOMODE';

SELECT * FROM t_fo_event WHERE instr('N',process) >0
---
select cspks_system.fn_get_sysvar('SYSTEM', 'HOSTATUS') from dual;
---
select aftype from afmast where acctno = '0006000649';
select * from pracctnomap where acctno = '0006000649';
select * from prtypemap where actype = '001';
select fn_get_AccPoolID('0006000649') from dual;
--
select odamt, odamt - nvl(t0.t0prin,0) amt, cf.brid, af.actype, nvl(t0.t0prin,0) t0prin
     -- into   l_odamt, l_excamt, l_brid, l_actype, l_T0prin
      from cimast ci, cfmast cf, afmast af,
           (select trfacctno,
                   sum(oprinnml + oprinovd + ointnmlacr + ointdue + ointovdacr + ointnmlovd) t0prin
            from lnmast ln, lntype lnt
                         where ln.actype = lnt.actype and ln.ftype = 'AF'
                         group by trfacctno) t0
 where ci.acctno = af.acctno
            and cf.custid = af.custid and af.acctno = t0.trfacctno(+)
            and ci.acctno = '0006000649';

select 404775178 - 223954454 from dual;