select * from buf_ci_account;

alter table BUF_CI_ACCOUNT add marginratefs NUMBER(20,4);

select * from V_ADVANCESCHEDULE;
select * from V_ADVANCESCHEDULE_FS;

select * from v_getaccountavladvance ;
select * from v_getaccountavladvance_fs;

select * from V_GETSECMARGINRATIO where afacctno IN ('0001037048','0001037053');

select * from V_CIMASTCHECK where afacctno IN ('0001037048','0001037053');

select * from VW_MR0003 where acctno = '0001037053';

select * from VW_MR0003 where acctno = '0001000184';
----
select * from user_source where upper(text) like '%INSERT%INTO%BUF_CI_ACCOUNT%';

----
SELECT MST.TMPCODE VALUECD, MST.TMPCODE VALUE, MST.TMPNAME DISPLAY, MST.TMPNAME EN_DISPLAY, MST.TMPNAME DESCRIPTION, 
MST.TMPCODE, MST.TMPNAME, MST.TMPTYPE, MST.TMPPATH, MST.TMPBODY, DTL.SEARCHCODE, DTL.SENDER, DTL.FIELDNAME, DTL.MODCODE, DTL.NOTES 
FROM CONTENTTMP MST, VIEWLNK2TMP DTL WHERE MST.TMPCODE=DTL.TMPCODE AND DTL.SEARCHCODE='MR0003' AND MST.SENDVIA='E';

select * from VIEWLNK2TMP; --FORCESELL_EMAIL FORCESELL_SMS
select * from CONTENTTMP;

select * from sendmsglog order by autoid desc;
delete from sendmsglog;

select * from emaillog order by autoid desc;
select * from smslog;
----
select fn_mr0003_get_source('0001037053') source from dual ;
----
alter table BUF_CI_ACCOUNT add outstanding_fs NUMBER(20,4);
--------
SELECT MST.TMPCODE VALUECD, MST.TMPCODE VALUE, MST.TMPNAME DISPLAY, MST.TMPNAME EN_DISPLAY, MST.TMPNAME DESCRIPTION, 
MST.TMPCODE, MST.TMPNAME, MST.TMPTYPE, MST.TMPPATH, MST.TMPBODY, DTL.SEARCHCODE, DTL.SENDER, DTL.FIELDNAME, DTL.MODCODE, DTL.NOTES 
FROM CONTENTTMP MST, VIEWLNK2TMP DTL WHERE MST.TMPCODE=DTL.TMPCODE AND DTL.SEARCHCODE='MR0003' AND MST.SENDVIA='E'

select fn_mr0003_get_source('0001000184') source from dual ;

----
