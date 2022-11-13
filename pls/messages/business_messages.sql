CREATE TABLE business_messages (
   message_id         NUMBER generated always as identity PRIMARY KEY using index (CREATE UNIQUE INDEX bus_msg_u1 ON business_messages (message_id))
  ,message_name       VARCHAR2(1000)
  ,language           VARCHAR2(2)
  ,message_text       VARCHAR2(1000)
  ,gravity            VARCHAR2(1)
); 

CREATE UNIQUE INDEX bus_msg_u2 ON business_messages (message_name,language);
