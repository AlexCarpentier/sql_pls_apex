CREATE TABLE log_messages (
   log_id         NUMBER generated always as identity
  ,log_message    VARCHAR2(1000)
  ,log_level      VARCHAR2(1)
  ,log_timestamp   TIMESTAMP
  ,log_user VARCHAR2(30)
  ,log_procedure  VARCHAR2(30)
  ,log_call_stack VARCHAR2(4000)
);

CREATE UNIQUE INDEX log_msg_pk ON log_messages (log_id);

CREATE INDEX log_msg_i1 ON log_messages (log_timestamp);
