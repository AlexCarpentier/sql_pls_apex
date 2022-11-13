CREATE OR REPLACE PACKAGE BODY logger 
AS

  PROCEDURE log (
     p_v_log_message IN VARCHAR2
    ,p_v_gravity IN VARCHAR2 default G_V_LVL_STATEMENT
    ,p_v_log_procedure IN VARCHAR2 default null --$$PLSQL_UNIT
    ,p_v_log_call_stack IN VARCHAR2 default dbms_utility.format_call_stack
  )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    
    INSERT INTO log_messages (
       log_message
      ,log_level
      ,log_timestamp
      ,log_user
      ,log_procedure
      ,log_call_stack
    ) VALUES (
       p_v_log_message
      ,p_v_gravity
      ,SYSTIMESTAMP
      ,USER
      ,p_v_log_procedure
      ,SUBSTR(p_v_log_call_stack,1,4000)
    );
    
    Commit;
    
  END log;
  
  
END logger;