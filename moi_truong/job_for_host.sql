/
BEGIN 
dbms_scheduler.create_job('"AUTO_SYNDATA"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN PCK_SYN2FO.PRC_PROCESSEVENT; END;  '
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('15-DEC-2020 03.39.31.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY; INTERVAL=2'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
end;
/
---
/
begin
dbms_scheduler.create_job('"FO_PORTFOLIOS_SEPITLOG"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN PR_FO_PORTFOLIOS_SEPITLOG(); END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('22-DEC-2020 03.01.53.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY;INTERVAL=2;'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
end;
---
/
begin
dbms_scheduler.create_job('"JBPKS_AUTO#GEN_CI_BUFFER"',
job_type=>'STORED_PROCEDURE', job_action=>
'jbpks_auto.pr_gen_ci_buffer'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('09-MAR-2020 05.33.16.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY;INTERVAL=3'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
end;
---
/
BEGIN 
dbms_scheduler.create_job('"JBPKS_AUTO#GEN_OD_BUFFER"',
job_type=>'STORED_PROCEDURE', job_action=>
'jbpks_auto.pr_gen_od_buffer'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('09-MAR-2020 05.33.32.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY;INTERVAL=3'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN 
dbms_scheduler.create_job('"JBPKS_AUTO#GEN_SE_BUFFER"',
job_type=>'STORED_PROCEDURE', job_action=>
'jbpks_auto.pr_gen_se_buffer'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('09-MAR-2020 05.33.47.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY;INTERVAL=3'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN 
dbms_scheduler.create_job('"PCK_HAGW#PRC_PROCESSMSG_EX"',
job_type=>'STORED_PROCEDURE', job_action=>
'PCK_HAGW.PRC_PROCESSMSG_EX'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('07-JUL-2020 10.23.32.000000000 AM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY;INTERVAL=30'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN
dbms_scheduler.create_job('"PCK_SYN2FO#PRC_PROCESSEVENT"',
job_type=>'STORED_PROCEDURE', job_action=>
'PCK_SYN2FO.PRC_PROCESSEVENT'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('10-MAR-2020 12.56.12.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY;INTERVAL=3'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN 
dbms_scheduler.create_job('"PRC_PROCESS_HA_8_SCHEDULER"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN PRC_PROCESS_HA_8(); END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('07-JUL-2020 10.23.05.000000000 AM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'freq=SECONDLY;interval=20'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN
dbms_scheduler.create_job('"PRC_PROCESS_HA_SCHEDULER"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN PRC_PROCESS_HA(); END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('07-JUL-2020 10.23.32.000000000 AM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'freq=SECONDLY;interval=20'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN 
dbms_scheduler.create_job('"PRC_PROCESS_HO_CTCI_SCHEDULER"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN PRC_PROCESS_HO_CTCI(); END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('07-JUL-2020 10.23.32.000000000 AM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'freq=SECONDLY;interval=20'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN 
dbms_scheduler.create_job('"PRC_PROCESS_HO_PRS_SCHEDULER"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN PRC_PROCESS_HO_PRS(); END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('07-JUL-2020 10.23.32.000000000 AM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'freq=SECONDLY;interval=20'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN 
dbms_scheduler.create_job('"PROCESS_FOMSG"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN newfo_api.prc_Process_exec; END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('10-AUG-2020 01.44.20.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'freq=secondly; interval=2;'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN
dbms_scheduler.create_job('"SP_AUTO_GEN_VSD_REQ"',
job_type=>'STORED_PROCEDURE', job_action=>
'CSPKS_VSD.SP_AUTO_GEN_VSD_REQ'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('31-MAY-2016 08.06.56.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'Freq=SECONDLY;Interval=10'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN 
dbms_scheduler.create_job('"SP_AUTO_PROCESS_MESSAGE_VSD"',
job_type=>'STORED_PROCEDURE', job_action=>
'CSPKS_VSD.pr_auto_process_message'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('31-MAY-2016 10.21.24.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'Freq=SECONDLY;Interval=10'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN 
dbms_scheduler.create_job('"TXPKS_AUTO#FO2ODSYNC"',
job_type=>'STORED_PROCEDURE', job_action=>
'txpks_auto.pr_fo2od'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('09-MAR-2020 05.32.23.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY;INTERVAL=3'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
BEGIN 
dbms_scheduler.create_job('"TXPKS_AUTO#FOBANKSYNC"',
job_type=>'STORED_PROCEDURE', job_action=>
'txpks_auto.pr_fobanksyn'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('09-MAR-2020 05.32.41.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY;INTERVAL=3'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
begin
dbms_scheduler.create_job('"TXPKS_AUTO#GTC2OD_HA"',
job_type=>'PLSQL_BLOCK', job_action=>
'begin    TXPKS_AUTO.pr_gtc2od(''GTC-HA''); end;  '
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('09-MAR-2020 05.32.55.000000000 PM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=SECONDLY; INTERVAL=5'
, end_date=>NULL,
job_class=>'"FSS_DEFAULT_JOB_CLASS"');
END;
---
/
