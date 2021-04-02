select * from search where searchcode = 'CFMAST';
select * from searchfld where searchcode = 'CFMAST';
-------
select * from cmdmenu where prid = '020000' and cmdid = '020134' order by cmdid for update;
--
select * from objmaster where objname like '%BASKET%' for update;
--SA.BASKETEXT
select * from grmaster where objname like '%SA.BASKETEXT%' for update;
select * from grmaster where objname like '%SA.SECBASKETEXT%' for update;
select * from grmaster where objname like '%SA.CAREBYBASKETEXT%' for update;


--
select * from search where searchcode like 'BASKETEXT' for update;
select * from searchfld where searchcode = 'BASKETEXT' order by position for update;

SELECT T.BASKETID, T.BASKETNAME, T.EXPDATE, T.STATUS STATUSCD, A1.CDCONTENT STATUS, T.NOTES,
       (CASE WHEN T.STATUS IN ('B','C','N') THEN 'N' ELSE 'Y' END) EDITALLOW,
       (CASE WHEN T.STATUS IN ('P') THEN 'Y' ELSE 'N' END) APRALLOW, 'Y' DELALLOW
FROM BASKETEXT T, ALLCODE A1
WHERE A1.CDTYPE = 'CF' AND A1.CDNAME = 'CFSTATUS'  AND A1.CDVAL = T.STATUS
      AND T.BASKETID IN (
            SELECT T.BASKETID
                   --NVL(C.CAREBYID,'----') CAREBY
            FROM BASKETEXT T,CAREBYBASKETEXT C
            WHERE NVL(C.CAREBYID,'----') IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = '<$TELLERID>' UNION SELECT '----' FROM DUAL)
                   AND T.BASKETID = C.BASKETID(+) )

select * from allcode where cdname = 'CFSTATUS';
----
select * from fldmaster where objname like 'SA.BASKETEXT'order by odrnum for update;
select * from fldval where objname like 'SA.BASKETEXT' for update; --<$WORKDATE>

---rổ CK đặc biệt
select * from apprvrqd where objname = 'BASKETEXT' ;
---
select * from search where searchcode = 'SECBASKETEXT' for update;
select * from searchfld where searchcode = 'SECBASKETEXT'order by position for update;


SELECT T.AUTOID, T.BASKETID, T.SYMBOL, T.MRRATIORATE, T.MRRATIOLOAN, T.MRPRICERATE, T.MRPRICELOAN,
       T.DESCRIPTION,T.NEWMRRATIORATE, T.NEWMRPRICERATE, T.EFFDATE NEWEFFDATE
FROM SECBASKETEXT T, SBSECURITIES B
WHERE T.SYMBOL=B.SYMBOL AND T.BASKETID = '<$KEYVAL>'
      
select * from fldmaster where objname = 'SA.SECBASKETEXT' order by odrnum for update;
select * from fldval where objname = 'SA.SECBASKETEXT' order by odrnum for update;


----careby
select * from search where searchcode = 'CAREBYBASKETEXT' for update;
select * from searchfld where searchcode = 'CAREBYBASKETEXT' order by position  for update;

SELECT T.AUTOID, T.BASKETID, T.CAREBYID, T.CAREBYNAME
FROM CAREBYBASKETEXT T, BASKETEXT B
WHERE 0=0 AND B.BASKETID = T.BASKETID AND T.BASKETID = '<$KEYVAL>'

select * from fldmaster where objname = 'SA.CAREBYBASKETEXT' for update;
select * from fldval where objname = 'SA.CAREBYBASKETEXT' for update;
-----

----- Tiểu khoản đc gán rổ đặc biệt: AFBASKETEXT
select * from cmdmenu where prid = '020000' and cmdid = '020135' order by cmdid for update;

select * from objmaster where objname like '%BASKET%' for update;

select * from grmaster where objname like '%SA.BASKETEXT%' for update;
select * from grmaster where objname like '%SA.AFBASKETEXT%' for update;

----
select * from search where searchcode = 'AFBASKETEXT' for update;
select * from searchfld where searchcode = 'AFBASKETEXT' order by position for update;

select T.AUTOID, T.BASKETID, B.BASKETNAME, T.ACCTNO, T.CUSTODYCD, NVL(T.CUSTNAME,'') FULLNAME,
       T.GRPACCT, NVL(GR.GRPNAME,'') GRPNAME, T.EXPDATE,T.STATUS STATUSCD, A1.CDCONTENT STATUS,
       (CASE WHEN T.STATUS IN ('B','C','N') THEN 'N' ELSE 'Y' END) EDITALLOW,
       (CASE WHEN T.STATUS IN ('P') THEN 'Y' ELSE 'N' END) APRALLOW, 'Y' DELALLOW 
FROM AFBASKETEXT T, ALLCODE A1, BASKETEXT B, DBNAVGRP GR, AFMAST AF
WHERE A1.CDTYPE = 'CF' AND A1.CDNAME = 'CFSTATUS'  AND A1.CDVAL = T.STATUS
      AND B.BASKETID = T.BASKETID
      AND T.ACCTNO = AF.ACCTNO(+)
      AND T.GRPACCT = GR.ACTYPE(+)
      AND B.BASKETID IN (
            SELECT T.BASKETID
            FROM BASKETEXT T,CAREBYBASKETEXT C
            WHERE NVL(C.CAREBYID,'----') IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = '<$TELLERID>' UNION SELECT '----' FROM DUAL)
                   AND T.BASKETID = C.BASKETID(+) );
      
select * from fldmaster where objname = 'SA.AFBASKETEXT' for update;
select * from fldval where objname = 'SA.AFBASKETEXT' for update;

select * from apprvrqd where objname = 'BASKETEXT' for update;

select * from apprvrqd where objname = 'AFBASKETEXT'

select * from allcode where cdname = 'CFSTATUS' for update;

select * from deferror where errnum like '%-1004%' order by errnum for update;

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100415, '[-100415]: Rổ đặc biệt đã được gán chứng khoán!', '[-100415]: Rổ đặc biệt đã được gán chứng khoán!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100416, '[-100416]: Rổ đặc biệt đã được gán care by!', '[-100416]: Rổ đặc biệt đã được gán care by!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100417, '[-100417]: Rổ đặc biệt đã được gán tiểu khoản khách hàng!', '[-100417]: Rổ đặc biệt đã được gán tiểu khoản khách hàng!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100418, '[-100418]: Không được xóa rổ đặc biệt đã hết hiệu lực!', '[-100418]: Không được xóa rổ đặc biệt đã hết hiệu lực!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100419, '[-100419]: Tỷ lệ tài sản mới, giá tài sản mới không được nhỏ hơn Tỷ lệ sức mua, giá sức mua!', '[-100419]: Tỷ lệ tài sản mới, giá tài sản mới không được nhỏ hơn Tỷ lệ sức mua, giá sức mua!', 'SA', 0);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100425, '[-100425]: Đã gán nhóm care by này vào rổ!', '[-100425]: Care by already exists!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100426, '[-100426]: Ngày hết hiệu lực phải nhỏ hơn ngày hết hiệu lực của rổ!', '[-100426]: Ngày hết hiệu lực phải nhỏ hơn ngày hết hiệu lực của rổ!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100427, '[-100427]: Tiểu khoản không thuộc care by của rổ!', '[-100427]: Tiểu khoản không thuộc care by của rổ!', 'SA', null);


insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100428, '[-100428]: Số tiểu khoản hoặc nhóm tiểu khoản không được trống!', '[-100428]: Số tiểu khoản hoặc nhóm tiểu khoản không được trống!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100429, '[-100429]: Trạng thái rổ đặc biệt không hợp lệ!', '[-100429]: Trạng thái rổ đặc biệt không hợp lệ!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100429, '[-100429]: Trạng thái rổ đặc biệt không hợp lệ!', '[-100429]: Trạng thái rổ đặc biệt không hợp lệ!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100438, '[-100438]: Tiểu khoản đã được gán với rổ khác có mã chứng khoán tương ứng!', '[-100438]: Tiểu khoản đã được gán với rổ khác có mã chứng khoán tương ứng!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100439, '[-100439]: Đã gán tiểu khoản thuộc care by vào rổ!', '[-100439]: Đã gán tiểu khoản thuộc care by vào rổ!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100440, '[-100440]: Không thể thay đổi care by khi đã gán rổ đặc biệt!', '[-100440]: Không thể thay đổi care by khi đã gán rổ đặc biệt!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100441, '[-100441]: Tiểu khoản đã gán vào rổ!', '[-100441]: Tiểu khoản đã gán vào rổ!', 'SA', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100442, '[-100442]: Nhóm tiểu khoản đã gán vào rổ!', '[-100442]: Nhóm tiểu khoản đã gán vào rổ!', 'SA', null);


insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'AFEXTTYPE', 'U', 'Tiểu khoản', 0, 'Y', 'Sub account');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'AFEXTTYPE', 'G', 'Nhóm tiểu khoản', 1, 'Y', 'Sub account group');


SELECT getcurrdate FROM DUAL;

alter table  secbasketext_log add refeffid number;

-- Create table
create table SECBASKETEXT_LOG
(
  txdate             DATE,
  txtime             VARCHAR2(20),
  basketid           VARCHAR2(50) default 0,
  symbol             VARCHAR2(20) not null,
  mrratiorate        NUMBER(20,4) default 0,
  mrratioloan        NUMBER(20,4) default 0,
  mrpricerate        NUMBER(20,4) default 0,
  mrpriceloan        NUMBER(20,4) default 0,
  newmrratiorate     NUMBER(20,4) default 0,
  newmrpricerate     NUMBER(20,4) default 0,
  effdate            DATE,
  mrratiorate_old    NUMBER(20,4) default 0,
  mrratioloan_old    NUMBER(20,4) default 0,
  mrpricerate_old    NUMBER(20,4) default 0,
  mrpriceloan_old    NUMBER(20,4) default 0,
  newmrratiorate_old NUMBER(20,4) default 0,
  newmrpricerate_old NUMBER(20,4) default 0,
  effdate_old        DATE,
  makerid            VARCHAR2(4),
  checkerid          VARCHAR2(4),
  action             VARCHAR2(20),
  autoid             NUMBER
);
-- Create/Recreate indexes 
create index SECBASKETEXT_LOG_TXDATE_IDX on SECBASKETEXT_LOG (TXDATE)
  tablespace KBSV
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
