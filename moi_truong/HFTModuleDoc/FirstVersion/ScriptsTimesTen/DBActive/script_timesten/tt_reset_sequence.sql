set echo off
spool tt_reset_sequence.log

PROMPT
PROMPT =========================================================================
PROMPT 

REM
REM reset sequence timesten database... 
REM

connect adding "uid=fopro;pwd=fopro" as fopro11;

PROMPT call PROCEDURE .....

BEGIN
   CSPKS_FO_RESET_SEQUENCE.sp_reset_seq_all;
   
END;
/

PROMPT
PROMPT tt_reset_sequence sucessfull.
PROMPT 

PROMPT
PROMPT package complie sucessfull.
PROMPT

alter package CSPKS_FO_COMMON compile;
alter package CSPKS_FO_VALIDATION compile;
alter package CSPKS_FO_RESET_SEQUENCE compile;
alter package CSPKS_FO_POOLROOM compile;
alter package CSPKS_FO_ORDER compile;
alter package CSPKS_FO_ORDER_ADV compile;
alter package CSPKS_FO_ORDER_NEW compile;
alter package CSPKS_FO_ORDER_AMEND compile;
alter package CSPKS_FO_ORDER_CROSS compile;
alter package CSPKS_FO_ORDER_RESPONE compile;
alter package CSPKS_FO_ORDER_CANCEL compile;
alter package CSPKS_FO_GW_HNX compile;
alter package CSPKS_FO_GW_HSX compile;
alter package CSPKS_FO_TRANS compile;

spool off
