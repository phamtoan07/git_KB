-- Create table
begin
  sys.dbms_aqadm.create_queue_table(
    queue_table => 'TXAQS_FLEX2FO_TABLE',
    queue_payload_type => 'SYS.AQ$_JMS_TEXT_MESSAGE',
    sort_list => 'ENQ_TIME',
    compatible => '10.0.0',
    primary_instance => 0,
    secondary_instance => 0,
    storage_clause => 'tablespace USERS pctfree 10 initrans 1 maxtrans 255 storage ( initial 64K next 1M minextents 1 maxextents unlimited )');
end;
/
