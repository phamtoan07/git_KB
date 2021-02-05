set echo off
spool tt_start_replicate_standby.log

connect "dsn=foStandby;uid=cacheuseradmin;pwd=timesten";
call ttRepStart;
PROMPT RepStart thanh cong ...

call ttCacheStart;
PROMPT CacheStart thanh cong ...
PROMPT 


spool off
