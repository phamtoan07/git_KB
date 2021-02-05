REM
REM Create grid and start cachegroup for cacheuseradmin
REM
PROMPT
call ttCacheUidPwdSet('cacheuseradmin','oracle');
call ttcacheuidget;
call ttGridDestroy('backgrid',1);
call ttgridcreate ('backgrid');
call ttgridnameset('backgrid');
call ttgridinfo; 
call ttCacheStart;
