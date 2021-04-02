select * from cmdmenu where prid ='111500' order by cmdid for update;

select * from objmaster where objname = 'SA.BASKETEXT';
select * from objmaster where objname = 'SA.SECBASKETEXT';

select * from objmaster where objname = 'LN.LNSPECRATE' for update;
select * from objmaster where objname = 'LN.LNSPECRATELIST' for update;


select * from grmaster where objname like 'LN.LNSPECRATE' for update;
select * from grmaster where objname like 'LN.LNSPECRATELIST' for update;--LNSPECRATELIST

--------
select * from search where searchcode = 'BASKETEXT';
select * from search where searchcode = 'LNSPECRATE' for update;
SELECT * FROM SEARCHFLD WHERE SEARCHCODE = 'LNSPECRATE' FOR UPDATE;

select * from search where searchcode = 'LNSPECRATELIST' for update;
SELECT * FROM SEARCHFLD WHERE SEARCHCODE = 'LNSPECRATELIST' FOR UPDATE;


select * from fldmaster where objname = 'LN.LNSPECRATE' for update;
select * from fldval where objname = 'LN.LNSPECRATE';
select * from fldmaster where objname = 'LN.LNSPECRATELIST' for update;
select * from fldval where objname = 'LN.LNSPECRATELIST' for update; --RATE

select * from fldmaster where invname is not null and invformat is not null; --[0000]

--------them moi giao dich gan tieu khoan vao danh muc
select * from tltx where tltxcd like '5580' order by tltxcd for update;
select * from tltx where tltxcd like '5581' order by tltxcd for update;
select * from tltx where tltxcd like '5582' order by tltxcd for update;

select * from fldmaster where objname = '5580' for update;
select * from fldmaster where objname = '5581' for update;

select * from fldval where objname = 'SA.SECBASKETEXT';
select * from fldval where objname = '5582' for update;

select * from cmdmenu where prid = '111502' for update;

select * from appchk where tltxcd = '5580' for update;

select * from deferror where errnum like '-540%' order by errnum for update;

---
select * from appchk where apptype = 'CF' and rulecd in ('01','04','33'); 0001 CF
select * from APPRULES where tblname = 'AFMAST';


------them moi giao dich go tieu khoan vao danh muc
select * from cmdmenu where prid ='111504';
select * from rptmaster where modcode = 'LN' and cmdtype = 'V' for update;

insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('LN5581', 'HOST', 'LN', '12', '5', '5', '60', '5', '5', 'Gỡ tiểu khoản khỏi danh mục ưu đãi', 'Y', 1, '1', 'P', 'LN5581', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Remove account from list of interest rate (wait for 5581)', null, 0, 0, 0, 0, 'N', 'N', 'Y');

insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('LN5582', 'HOST', 'LN', '12', '5', '5', '60', '5', '5', 'Thay đổi thông tin tiểu khoản trong danh mục ưu đãi', 'Y', 1, '1', 'P', 'LN5582', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Adjust account from list of interest rate (wait for 5582)', null, 0, 0, 0, 0, 'N', 'N', 'Y');

select * from fldmaster where objname = '5581' for update;
select * from search where searchcode = 'LN5581' for update;
select * from searchfld where searchcode = 'LN5581' for update;

-----
------them moi giao dich thay doi thong tin tieu khoan vao danh muc
select * from fldmaster where objname = '5582' for update;
select * from search where searchcode IN ('LN5582') for update;
select * from searchfld where searchcode IN ('LN5582') for update;

select * from allcode where cdtype = 'LN' and cdname = 'SPECTYPE' for update;



