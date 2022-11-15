CREATE OR REPLACE PROCEDURE update_employee (
   p_n_employee_id IN NUMBER
  ,p_v_first_name IN VARCHAR2 default API_COMMON.G_MISSING_VARCHAR
  ,p_v_last_name IN VARCHAR2 default API_COMMON.G_MISSING_VARCHAR
  ,x_v_return_status OUT VARCHAR2
)
IS
  l_v_return_status VARCHAR2(1);
BEGIN
  
  logger.log('Début update_employee', logger.G_V_LVL_PROCEDURE);
  
  IF p_v_last_name IS NULL THEN
    MESSAGES.Add('EMP_NULL_LAST_NAME');
    RAISE API_COMMON.G_ERR_BUSINESS_ERROR;
  END IF;
  
  logger.log('Lancement de l UPDATE', logger.G_V_LVL_PRC_STEP);
  
  UPDATE employees e
     SET e.first_name = CASE p_v_first_name
                          WHEN API_COMMON.G_MISSING_VARCHAR THEN e.first_name
                          ELSE p_v_first_name
                        END
        ,e.last_name = CASE p_v_last_name
                          WHEN API_COMMON.G_MISSING_VARCHAR THEN e.last_name
                          ELSE p_v_last_name
                        END
   WHERE e.employee_id = p_n_employee_id;
  
  x_v_return_status := API_COMMON.G_STS_SUCCESS;
  
  logger.log('Fin update_employee', logger.G_V_LVL_PROCEDURE);
  
EXCEPTION

  WHEN API_COMMON.G_ERR_BUSINESS_ERROR THEN
    logger.log('Business error', logger.G_V_LVL_ERROR);
    x_v_return_status := API_COMMON.G_STS_ERROR;
    
  WHEN API_COMMON.G_ERR_UNEXPECTED_ERROR THEN
    logger.log('Erreur inattendue', logger.G_V_LVL_UNEXPECTED);
    x_v_return_status := API_COMMON.G_STS_UNEXPECTED;
    
  WHEN OTHERS THEN
    logger.log('When others', logger.G_V_LVL_UNEXPECTED);
    --Ajout message
    MESSAGES.Add('GENERIC_MESSAGE');
    MESSAGES.Set_Parameter('MESSAGE', SUBSTR ( SQLCODE ||' - '|| SQLERRM || ' - Backtrace : '||DBMS_Utility.Format_Error_Backtrace , 1, 1000) ) ;
    x_v_return_status := API_COMMON.G_STS_UNEXPECTED;
    
END update_employee;