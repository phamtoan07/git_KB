-------DB HOST
expdp HOSTMSBST/HOST@FLEX_111 directory=DATA_PUMP_DIR dumpfile=HOSTMSBST_20211401.dmp logfile=expdpHOSTMSBST_20211401.log

impdp system/123456@FLEX129 schemas=HOSTMSBST remap_schema=HOSTMSBST:HOSTKBSVD remap_tablespace=USERS:KBSV,KBSV:KBSV directory=DATA_PUMP_DIR dumpfile=HOSTMSBST_20211401.dmp logfile=impHOSTMSBST_20211801D.txt
impdp system/123456@FLEX129 schemas=HOSTMSBST remap_schema=HOSTMSBST:HOSTKBSVT remap_tablespace=USERS:KBSV,KBSV:KBSV directory=DATA_PUMP_DIR dumpfile=HOSTMSBST_20211401.dmp logfile=impHOSTMSBST_20211801T.txt

impdp system/123456@FLEX129 schemas=host remap_schema=host:HOSTKBSVT remap_tablespace=USERS:USERS directory=u02_dir dumpfile=msbs_host01.dmp,msbs_host02.dmp,msbs_host03.dmp,msbs_host04.dmp logfile=impHOSTT_20210402T_01.txt

-------

-------DB BDS
expdp BDSMSBST/BDS@FLEX_111 directory=DATA_PUMP_DIR dumpfile=BDSMSBST_20211401.dmp logfile=expdpBDSMSBST_20211401.log

impdp system/123456@FLEX129 schemas=BDSMSBST remap_schema=BDSMSBST:BDSKBSVD remap_tablespace=KBSV:KBSV directory=DATA_PUMP_DIR dumpfile=BDSMSBST_20211401.dmp logfile=impBDSMSBSD_20211801D.txt
impdp system/123456@FLEX129 schemas=BDSMSBST remap_schema=BDSMSBST:BDSKBSVT remap_tablespace=KBSV:KBSV directory=DATA_PUMP_DIR dumpfile=BDSMSBST_20211401.dmp logfile=impBDSMSBST_20211801T.txt

impdp system/123456@FLEX129 schemas=bds remap_schema=bds:BDSKBSVT directory=DATA_PUMP_DIR dumpfile=msbs_bds01.dmp,msbs_bds02.dmp,msbs_bds03.dmp,msbs_bds04.dmp logfile=impBDST_20210402T.txt

-------DB FOTEST
expdp FOTEST/FOTEST@FO directory=DATA_PUMP_DIR dumpfile=FOTEST_20211401.dmp logfile=expdpFOTEST_20211401.log

impdp system/123456 schemas=FOTEST remap_schema=FOTEST:FOTEST remap_tablespace=USERS:FOTEST directory=DATA_PUMP_DIR dumpfile=FOTEST_20211401.dmp logfile=impFOTEST_20212501.txt

-------DB CACHEADM
expdp CACHEADM/cacheadm@FO directory=DATA_PUMP_DIR dumpfile=CACHEADM_20212501.dmp logfile=expdpCACHEADM_20212501.log

impdp system/123456@FO163 schemas=CACHEADM remap_schema=CACHEADM:CACHEADM remap_tablespace=TTUSERS:FOTEST directory=DATA_PUMP_DIR dumpfile=CACHEADM_20212501.dmp logfile=impCACHEADM_20212501.txt


----------------

execute dbms_metadata_util.load_stylesheets

select distinct tablespace_name from user_tables;
select * from dba_directories;
SELECT * FROM dba_data_files;

create user BDSKBSVD identified by BDS default tablespace KBSV
create user FOTEST identified by FOTEST default tablespace FOTEST;
create user CACHEADM identified by FOTEST default tablespace FOTEST;

drop user log cascade
alter user sys identified by 123456

ALTER USER BDSKBSVD quota unlimited on KBSV;
ALTER USER FOTEST quota unlimited on FOTEST;
ALTER USER CACHEADM quota unlimited on FOTEST;

grant execute on SYS.DBMS_LOCK to someuser;

shutdown immediate;
startup restrict
ALTER DATABASE CHARACTER SET INTERNAL_USE AL32UTF8;
SQL> select * from v$NLS_PARAMETERS;
shutdown immediate;
startup


create bigfile tablespace FOTEST datafile '/u01/app/oracle/oradata/orcl/FOTEST01.dbf' 
size 10G autoextend on next 1G maxsize 400G extent management local AUTOALLOCATE;


begin
  for rec in (select * from all_scheduler_jobs where owner = 'HOSTSIT') loop
    begin
      dbms_scheduler.stop_job(job_name         =>  rec.owner||'.' ||rec.job_name,
                              force            => true);
      dbms_scheduler.disable(name             => rec.owner||'.' ||rec.job_name,
                             force            => true);
    exception
      when others then
        null;
    end;
  end loop;
end;
---------
select distinct tablespace_name from user_tables;
SELECT *
  FROM sys.dba_sys_privs
 WHERE grantee = 'HOSTKBSVD'
---------
/
begin
  sys.dbms_scheduler.create_job_class(job_class_name          => 'SYS.FSS_DEFAULT_JOB_CLASS',
                                      resource_consumer_group => 'SYS_GROUP',
                                      logging_level           => sys.dbms_scheduler.logging_failed_runs,
                                      log_history             => to_number(null),
                                      comments                => '');
end;
/
----------
/
begin
  for rec in (
      select * from all_tab_privs_recd where grantee = 'CACHEADM' and owner = 'FOTEST'
      )
  loop
    dbms_output.put_line('GRANT ' || rec.privilege || ' ON FOTEST.' || rec.table_name || ' TO CACHEADM;');
  end loop;
end; 
/
----------
begin
for rec in (
select distinct * from (
SELECT PRIVILEGE
  FROM sys.dba_sys_privs
 WHERE grantee = 'CACHEADM'
UNION
SELECT PRIVILEGE
  FROM dba_role_privs rp JOIN role_sys_privs rsp ON (rp.granted_role = rsp.role)
 WHERE rp.grantee = 'CACHEADM'
 ORDER BY 1)
 )
 loop
   dbms_output.put_line('GRANT ' || rec.privilege || ' to CACHEADM;');
 end loop;
 end;
----------Database link cho FO
create database link DBL_BO.FSS.COM.VN
  connect to HOSTKBSVT
  identified by HOST
  using '(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.129)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = orcl.fss.com.vn)
    )
  )';
----------Job for FO
begin
  sys.dbms_scheduler.create_job(job_name            => 'FOTEST.SYNROOM2BO',
                                job_type            => 'PLSQL_BLOCK',
                                job_action          => 'BEGIN pr_syn_room2bo; END;',
                                start_date          => to_date('14-12-2020 17:19:27', 'dd-mm-yyyy hh24:mi:ss'),
                                repeat_interval     => 'Freq=SECONDLY;Interval=2',
                                end_date            => to_date(null),
                                job_class           => 'DEFAULT_JOB_CLASS',
                                enabled             => true,
                                auto_drop           => false,
                                comments            => 'Dong bo du lieu Room xuong BO');
end;
/
begin
  sys.dbms_scheduler.create_job(job_name            => 'FOTEST.SYN_ORDERS_LASTCHANGE',
                                job_type            => 'PLSQL_BLOCK',
                                job_action          => 'BEGIN pr_update_lastchange; END;',
                                start_date          => to_date('29-12-2016 15:51:53', 'dd-mm-yyyy hh24:mi:ss'),
                                repeat_interval     => 'Freq=secondly;Interval=2',
                                end_date            => to_date(null),
                                job_class           => 'DEFAULT_JOB_CLASS',
                                enabled             => true,
                                auto_drop           => false,
                                comments            => 'Cap nhat laschange lenh adv');
end;
/
----------dblink for host
D:\FSS_KB\moi_truong\job_for_host.sql;
----------
install HTTP activation

---------

select
   fs.tablespace_name                          "Tablespace",
   (df.totalspace - fs.freespace)              "Used MB",
   fs.freespace                                "Free MB",
   df.totalspace                               "Total MB",
   round(100 * (fs.freespace / df.totalspace)) "Pct. Free"
from
   (select
      tablespace_name,
      round(sum(bytes) / 1048576) TotalSpace
   from
      dba_data_files
   group by
      tablespace_name
   ) df,
   (select
      tablespace_name,
      round(sum(bytes) / 1048576) FreeSpace
   from
      dba_free_space
   group by
      tablespace_name
   ) fs
where
   df.tablespace_name = fs.tablespace_name;