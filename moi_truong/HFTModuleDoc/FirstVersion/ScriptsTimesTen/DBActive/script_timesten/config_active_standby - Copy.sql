

REM
REM Create active standby 
REM


create active standby pair
    foActive on "front-active", foStandby on "front-standby" 
   
    store foActive on "front-active"
        port 21000
        timeout 30
    store foStandby on "front-standby"
        port 20000
        timeout 30
    
;

REM View schemes
REM		
repschemes;

call ttrepstart;

PROMPT The status of replicate on foActive

call ttrepstateset ('active');

call ttrepstateget;

PROMPT |---------------------------------------------------------------------|
PROMPT
PROMPT Please run file "duplicate_to_standby.sh" on your standby machine to duplicate from master.
PROMPT then accept complete on your active machine
PROMPT |---------------------------------------------------------------------|

REM prompt Please run this command on your standby machine to duplicate from master.
REM PROMPT |-----------------------------Standby---------------------------------|
REM PROMPT |	% ttRepAdmin -duplicate -from foActive -host "front-active" -uid cacheuseradmin -pwd timesten -keepcg -cacheuid cacheuseradmin -cachepwd oracle "dsn=foStandby"	
REM PROMPT |---------------------------------------------------------------------|

ACCEPT completed char prompt 'Complete.[yes/no]: ' hide 

call ttGridAttach(1,'fssalone','front-active',50120,'fssalone2','front-active',50121);

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



