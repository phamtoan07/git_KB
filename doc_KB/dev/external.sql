select * from securities_risk;
select * from allcode where cdname = 'EXECTYPE' and cdtype = 'OD';
select * from securities_info where codeid = '000430';

select to_number(nvl(max(sy_HOSTATUS.varvalue),0)) hosts from sysvar sy_HOSTATUS where sy_HOSTATUS.grname='SYSTEM' and sy_HOSTATUS.varname='HOSTATUS';

select * from odtype;

select * from tltx where tltxcd like '18%' order by tltxcd;
----
select * from user_source where upper(text) like '%MRCRLIMIT =%';
select * from user_source where upper(text) like '%MRCRLIMIT=%';
select * from tltx where tltxcd in ('1610','1631');
----
select * from user_source where upper(text) like '%MRCRLIMITMAX =%';
select * from user_source where upper(text) like '%MRCRLIMITMAX=%';
select * from user_source where upper(text) like '%MRCRLIMITMAX%';

select * from tltx where tltxcd in ('1815','1813');

select * from fldmaster where objname = '1813';
select * from fldval where objname = '1813';

select * from search where searchcode = 'USERAFLIMIT';

select * from useraflimit;

---

select * from tltx where tltxcd in ('1158','1186','1805','1810','1811','1812','1816','1818');
