DECLARE
  l_v_return_status VARCHAR2(1);
BEGIN
  
  messages.Reset;
  
  update_employee(
     p_n_employee_id => 207
    ,p_v_first_name => 'Thomas'
    ,p_v_last_name => Null
    ,x_v_return_status => l_v_return_status
  );
  
  dbms_output.put_line('Retour : '||l_v_return_status);
  
  IF l_v_return_status IN (API_COMMON.G_STS_ERROR,API_COMMON.G_STS_UNEXPECTED) THEN
    IF messages.Count > 0 THEN
      FOR i IN 0 .. messages.Count - 1 LOOP
         dbms_output.put_line(messages.Get(i));
      END LOOP;
    END IF;
  END IF;
  
END;