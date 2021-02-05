SET DEFINE ON
set echo off

spool build_timesten.log;

DEFINE dsnActive=FOTEST;
DEFINE dsnStandby=FOTEST;
DEFINE hostnameActive=tcbs-hft-dev;
DEFINE hostnameStandby=tcbs-hft-dev;
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

create user &&db_user_name identified by &&db_user_pwd;
grant xla, create session to &&db_user_name;
grant create table, create sequence, create procedure to &&db_user_name;
grant create synonym to &&db_user_name;
grant create public synonym to &&db_user_name;
grant cache_manager, create any table to &&db_user_name;

PROMPT
PROMPT Set the cache administration user .....
PROMPT

connect adding "uid=&&adminname;pwd=&&adminpassword;oraclepwd=&&oraclepwd" as cacheadm;
call ttcacheuidpwdset ('&&adminname','&&adminpassword');
call ttcacheuidget;

PROMPT
PROMPT Create cache grid and start cachegroup for cacheadm .....
PROMPT

call ttGridDestroy('&&gridname', 1);
call ttgridcreate ('&&gridname');
call ttgridnameset('&&gridname');
call ttgridinfo; 
call ttCacheStart;

PROMPT
PROMPT Create cache groups .....
PROMPT

@tt_create_group.sql
cachegroups;

PROMPT Start the replication agent for the Asynchronous writethrough cache group .....
PROMPT

-- call ttrepstart;

-- PROMPT Attach Cache Grid
-- call ttgridattach (1, '&&gridname', '&&hostname', 9991);
-- call ttgridnodestatus;

-- PROMPT LOAD CACHE GROUP ..... 
-- @tt_load_cache_data.sql

PROMPT
PROMPT CREATE PACKAGES, SEQUENCE, TABLE TEMPORARY  .....
PROMPT 

connect adding "uid=&&db_user_name;pwd=&&db_user_pwd" as back;

PROMPT CREATE SEQUENCE ....
@tt_create_sequence.sql
PROMPT CREATE TABLE TEMPORARY ....
@tt_table_temporary.sql

PROMPT CREATE PACKAGES .....
@scripts/install.sql
PROMPT CREATE INDEX .....
@tt_create_group_idx.sql

PROMPT
PROMPT CONFIG ACTIVE STANDBY MODE  .....
PROMPT

connect adding "uid=&&adminname;pwd=&&adminpassword;oraclepwd=&&oraclepwd" as cacheuseradmin_2;



REM
REM Create active standby 
REM


create active standby pair
    &&dsnActive on "&&hostnameActive", &&dsnStandby on "&&hostnameStandby" 
    store &&dsnActive on "&&hostnameActive"
        port 21000
        timeout 30
    store &&dsnStandby on "&&hostnameStandby"
        port 20000
        timeout 30
    
;

REM View schemes
REM		
repschemes;

call ttrepstart;

PROMPT The status of replicate on &&dsnActive

call ttrepstateset ('active');

call ttrepstateget;

PROMPT |---------------------------------------------------------------------|
PROMPT
PROMPT Please run file "duplicate_to_standby.sh" on your standby machine to duplicate from master.
PROMPT then accept complete on your active machine
PROMPT |---------------------------------------------------------------------|

REM prompt Please run this command on your standby machine to duplicate from master.
REM PROMPT |-----------------------------Standby---------------------------------|
REM PROMPT |	% ttRepAdmin -duplicate -from &&hostnameActive -host "&&hostnameActive" -uid cacheuseradmin -pwd timesten -keepcg -cacheuid cacheuseradmin -cachepwd oracle "dsn=&&hostnameStandby"	
REM PROMPT |---------------------------------------------------------------------|

ACCEPT completed char prompt 'Complete.[yes/no]: ' hide 

call ttGridAttach(1,'fssalone','&&hostnameActive',50120,'fssalone2','front-active',50121);

call ttgridnodestatus;

PROMPT
PROMPT Please run file "ttstart_replicate_standby.sh" 
PROMPT then run file "ttattach_grid_standby.sh" on your standby machine to start replicate and grid attach.
PROMPT then accept complete on your active machine

REM PROMPT Please run this command on your standby machine to start replicate and grid attach.
REM PROMPT |-----------------------------Standby---------------------------------|
REM PROMPT |	% ttisql "DSN=foStandby;UID=cacheuseradmin;PWD=timesten;OraclePWD=oracle"
REM PROMPT |	call ttRepStart;
REM PROMPT |	call ttCacheStart;
REM PROMPT |	call ttGridAttach(2,'fssalone','front-active',50220,'fssalone3','front-standby',50221);
REM PROMPT |	call ttRepStateGet;
REM PROMPT |	call ttCachePolicySet('always');
REM PROMPT |	call ttRepPolicySet('always');
REM PROMPT |---------------------------------------------------------------------|
ACCEPT completed char prompt 'Complete.[yes/no]: ' hide 


REM call ttCachePolicySet('always');

REM call ttRepPolicySet('always');



PROMPT
PROMPT build timesten sucessfull.
PROMPT 

spool off

