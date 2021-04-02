select * from grmaster where objname like '%BASKET';

alter table SECBASKET add newmrratiorate NUMBER(20,4) default 0;
alter table SECBASKET add newmrpricerate NUMBER(20,4 ) default 0;
alter table SECBASKET add effdate DATE;

alter table SECBASKETHIST add newmrratiorate NUMBER(20,4);
alter table SECBASKETHIST add newmrpricerate NUMBER(20,4);
alter table SECBASKETHIST add effdate DATE;

select * from SECBASKET;
select * from SECBASKETHIST;

select * from apprvrqd where objname = 'SECBASKET' for update;
select * from apprvrqd where objname = 'BASKET' for update;

--
select * from SECBASKETEXTEFFDT for update;

select * from SECBASKET_LOG;

alter table SECBASKETEXTEFFDT add isext varchar(1) default 'N';

alter table SECBASKET_LOG add  newmrratiorate     NUMBER(20,4) default 0;
alter table SECBASKET_LOG add  newmrpricerate     NUMBER(20,4) default 0;
alter table SECBASKET_LOG add  effdate            DATE;
alter table SECBASKET_LOG add  newmrratiorate_old NUMBER(20,4) default 0;
alter table SECBASKET_LOG add  newmrpricerate_old NUMBER(20,4) default 0;
alter table SECBASKET_LOG add  effdate_old        DATE;
alter table SECBASKET_LOG add  autoid             NUMBER;
alter table SECBASKET_LOG add  refid              NUMBER;
alter table SECBASKET_LOG add  refeffid           NUMBER;
alter table SECBASKET_LOG modify action varchar2(50);

create sequence seq_SECBASKET_LOG;
--










