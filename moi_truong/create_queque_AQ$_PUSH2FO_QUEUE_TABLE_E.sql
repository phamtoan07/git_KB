begin
  sys.dbms_aqadm.create_queue(
    queue_name => 'AQ$_PUSH2FO_QUEUE_TABLE_E',
    queue_table => 'PUSH2FO_QUEUE_TABLE',
    queue_type => sys.dbms_aqadm.exception_queue,
    max_retries => 0,
    retry_delay => 0,
    retention_time => 0,
    comment => 'exception queue');
end;
/
