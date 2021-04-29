select * from sbsecurities where codeid = '000566';

select * from camast_mr_notify_events order by autoid desc for update;
select * from secmrcamap where status = 'A' order by autoid desc for update;

select * from sbsecurities where codeid = '900275';

select * from secbasket where symbol like '%_q_S_%';
select * from secbasketext where symbol = '%_q_S_%';

select * from tlog where luser= user order by id desc;

select * from camast_mr_notify_events where status = 'P' and camastid = '0001000244112542'
         and action <> 'ADD' order by autoid
         --0001000622112549\
         
---
select * from camast order by autoid desc;
select * from caschd where camastid = '0001000623112550'; --0001000041 0001000055
select * from caschd where camastid = '0001002892112551';
select * from caschd where camastid = '0001000793112552' and afacctno = '0001000601'; 
---
select * from allcode where cdname = 'CASTATUS';
----
select s.acctno, s.afacctno,s.actype,s.acctno,s.codeid, sec.symbol, s.trade,s.receiving from semast s, sbsecurities sec
where s.afacctno = '0001000601' and s.codeid = sec.codeid --and symbol like '%AAA%';

select s.acctno, s.afacctno,s.actype,s.acctno,s.codeid, sec.symbol, s.trade,s.receiving from semast s, sbsecurities sec
where s.afacctno IN ('0001000041','0001000055') and s.codeid = sec.codeid and symbol like '%AAA%';

select * from setran where acctno = '0001000601002892';

select getcurrdate from dual;

select * from appmap where tltxcd = '3380' for update;

-------
--sửa pck_newfo 
