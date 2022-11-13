CREATE OR REPLACE PACKAGE logger 
AS


  --Niveaux de messages d'erreurs
  G_V_LVL_UNEXPECTED  CONSTANT NUMBER := 7;  --Gravité maximale : erreur inattendue
  G_V_LVL_ERROR       CONSTANT NUMBER := 6;  --Gravité : erreur prévue
  G_V_LVL_EXCEPTION   CONSTANT NUMBER := 5;  --Gravité : Exception gérée n’entrainant pas d’erreur
  G_V_LVL_EVENT       CONSTANT NUMBER := 4;  --Gravité : Evénement
  G_V_LVL_PROCEDURE   CONSTANT NUMBER := 3;  --Gravité : Début et fin d’une procédure
  G_V_LVL_PRC_STEP    CONSTANT NUMBER := 2;  --Gravité : grande étape d’une procédure
  G_V_LVL_STATEMENT   CONSTANT NUMBER := 1;  --Gravité minimale : commentaire
  
  PROCEDURE log (
     p_v_log_message IN VARCHAR2
    ,p_v_gravity IN VARCHAR2 default G_V_LVL_STATEMENT
    ,p_v_log_procedure IN VARCHAR2 default null --$$PLSQL_UNIT
    ,p_v_log_call_stack IN VARCHAR2 default dbms_utility.format_call_stack
  );
  
  
END logger;