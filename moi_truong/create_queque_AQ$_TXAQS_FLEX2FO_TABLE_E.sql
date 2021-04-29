begin
  sys.dbms_aqadm.create_queue(
    queue_name => 'AQ$_TXAQS_FLEX2FO_TABLE_E',
    queue_table => 'TXAQS_FLEX2FO_TABLE',
    queue_type => sys.dbms_aqadm.exception_queue,
    max_retries => 0,
    retry_delay => 0,
    retention_time => 0,
    comment => 'exception queue');
end;
/
