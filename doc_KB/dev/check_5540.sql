select * from tllog where tltxcd in ('5567','5566');
select * from tllog where tltxcd in ('5540');
select * from prchk where tltxcd in ('5567','5566');

select * from prtran where txnum = '9900000260'; --5567
select * from prtran where txnum = '0001000137'; --5566

select * from tllogfld where txnum = '9900000261';
---
select * from prtran where txnum = '0001000118';

select  6469348 + 965026 from dual;

select * from prmaster where prcode in ('0001','0002','0003') for update;

--BO 3334022051666  UB 3293058802545 0003: 116659690585
--FO 3334022051666  UB 3293058802545 0003: 116659690585 account.poolid = 0003
------sau
--BO 3334021911838  UB 3293057411310 0003:  116659253729
--FO 3334021911838  UB 3293058462717 0003:  116659350757

select 3293057411310 - 3293058365689 from dual; -954379
select 3293058462717 - 3293058365689 from dual; -97028

select 116659350757 - 116659253729 from dual; --97028


select * from afpoolallocation where afacctno = '0001002804';
select custid from afmast where acctno = '0001002804';
--UB, HT, 0003: 35619181
--gốc :3590377, lãi: 373000 = 3963377
--sau : 35182325
select 35182325 - 35279353 from dual;
---
select * from fotxmap where tltxcd = '5540';
select * from fldmaster where objname = '5540';
select * from prchk where tltxcd = '5540';
---
