set echo off
spool tt_attach_grid_standby.log

connect "dsn=foStandby;uid=cacheuseradmin;pwd=timesten";

PROMPT 
PROMPT bat dau attach grid ...
call ttGridAttach(2,'fssalone','front-active',50220,'fssalone3','front-standby',50221);
PROMPT  attach grid thanh cong ...

call ttRepStateGet;
call ttCachePolicySet('always');
call ttRepPolicySet('always');


spool off
