CREATE TABLE business_messages (
   message_id         NUMBER generated always as identity PRIMARY KEY using index (CREATE UNIQUE INDEX bus_msg_u1 ON business_messages (message_id))
  ,message_name       VARCHAR2(1000)
  ,language           VARCHAR2(2)
  ,message_text       VARCHAR2(1000)
  ,gravity            VARCHAR2(1) CHECK (gravity IN ('I','W','E', 'U'))  --Info, warning, error, unexcepted
); 


CREATE UNIQUE INDEX bus_msg_u2 ON business_messages (message_name,language);

insert into business_messages (
   message_name
  ,language
  ,message_text
  ,gravity
)
values (
   'GENERIC_MESSAGE'
  ,'FR'
  ,'|MESSAGE|'  --Un texte entouré de | permet de définir une variable dans votre message
  ,'I'
);

/* Pour exemple du CM 3, partie les must have du developpeur */
insert into business_messages (
   message_name
  ,language
  ,message_text
  ,gravity
)
values (
   'EMP_NULL_LAST_NAME'
  ,'FR'
  ,'Le nom de famille doit être renseigné.'  --Un texte entouré de | permet de définir une variable dans votre message
  ,'E'
);

Commit;