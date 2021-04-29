-- Create table
create table FSS_QO_PROCESS_TABLE
(
  q_name            VARCHAR2(30),
  msgid             RAW(16) not null,
  corrid            VARCHAR2(128),
  priority          NUMBER,
  state             NUMBER,
  delay             TIMESTAMP(6),
  expiration        NUMBER,
  time_manager_info TIMESTAMP(6),
  local_order_no    NUMBER,
  chain_no          NUMBER,
  cscn              NUMBER,
  dscn              NUMBER,
  enq_time          TIMESTAMP(6),
  enq_uid           VARCHAR2(30),
  enq_tid           VARCHAR2(30),
  deq_time          TIMESTAMP(6),
  deq_uid           VARCHAR2(30),
  deq_tid           VARCHAR2(30),
  retry_count       NUMBER,
  exception_qschema VARCHAR2(30),
  exception_queue   VARCHAR2(30),
  step_no           NUMBER,
  recipient_key     NUMBER,
  dequeue_msgid     RAW(16),
  sender_name       VARCHAR2(30),
  sender_address    VARCHAR2(1024),
  sender_protocol   NUMBER,
  user_data         FSS_OBJLOG_QUEUE_PAYLOAD_TYPE,
  user_prop         SYS.ANYDATA
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table FSS_QO_PROCESS_TABLE
  add primary key (MSGID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
