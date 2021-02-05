set echo off

spool build_timesten.log;

DEFINE hostname=tcbs-hft-dev;
DEFINE gridname=fotestgrid;
DEFINE adminname=cacheadm;
DEFINE adminpassword=cacheadm;
DEFINE oraclepwd=cacheadm;
DEFINE db_user_name=FOTEST;
DEFINE db_user_pwd=FOTEST;

PROMPT
PROMPT Create a Cache Manager User .....
PROMPT

create user &&adminname identified by &&adminpassword;
grant admin TO &&adminname;

PROMPT
PROMPT Create a TimesTen User .....
PROMPT

REM
REM Connect as user &&adminname to create the other FSS database users
REM

create user &&db_user_name identified by &&db_user_pwd;
grant xla, create session to &&db_user_name;
grant create table, create sequence, create procedure to &&db_user_name;
grant create synonym to &&db_user_name;
grant create public synonym to &&db_user_name;
grant cache_manager, create any table to &&db_user_name;

connect adding "uid=&&adminname;pwd=&&cache_password" as cacheuseradmin;

REM
REM Connect as user cacheuseradmin with OraclePWD and create readonly cache groups
REM
connect adding "UID=cacheuseradmin;PWD=&&cache_password;OraclePWD=oracle" as cacheuseradmin_oracle;
@config_cache_group.sql
@create_cachegroup_ro.sql

PROMPT Exit create cache groups


REM
REM Connect as user BACK and create schema objects
REM

connect adding "uid=fopro;pwd=fopro;OraclePWD=oracle" as back;
PROMPT
PROMPT Creating schema objects and indexes
PROMPT 


@create_obj_others.sql
@package_timesten/install.sql


connect adding "UID=cacheuseradmin;PWD=&&cache_password;OraclePWD=oracle" as cacheuseradmin_2;
@config_active_standby.sql

@tt_reset_sequence.sql


spool off
