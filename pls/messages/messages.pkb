CREATE OR REPLACE PACKAGE BODY messages 
AS
  
  
  
  
  
  --Type tableau pour création de la pile de messages
  TYPE T_TAB_MESSAGES IS TABLE OF VARCHAR2(1000) INDEX BY PLS_INTEGER;
  
  -- Pile de messages, commence à 0
  G_TAB_MESSAGES T_TAB_MESSAGES;
  
  
  
  
  
  PROCEDURE Add (
     p_v_message_name IN VARCHAR2
  )
  AS
    
    l_v_message_text business_messages.message_text%TYPE;
    
  BEGIN
    
    --On récupère le texte du message demandé
    BEGIN
      
      SELECT bm.message_text
        INTO l_v_message_text
        FROM business_messages bm
       WHERE bm.message_name = p_v_message_name;
      
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
        l_v_message_text := p_v_message_name;  --Si le message demandée n'existe pas, on met le nom du message recherché dans le texte
    END;
    
    --On l'ajoute à la pile
    G_TAB_MESSAGES(G_TAB_MESSAGES.Count) := l_v_message_text;
    
  END Add;
  
  
  
  
  
  PROCEDURE Reset
  AS
  BEGIN
    
    G_TAB_MESSAGES.Delete;
    
  END Reset;
  
  
  
  
  
  FUNCTION Get (
     p_n_message_index IN NUMBER
  ) RETURN VARCHAR2
  AS
    l_v_output_message VARCHAR2(1000);
  BEGIN
    
    --Si le message demandé existe, on le renvoie
    IF G_TAB_MESSAGES.Exists(p_n_message_index) THEN
      
      l_v_output_message := G_TAB_MESSAGES(p_n_message_index);
      
    ELSE  --Sinon, on renvoie Null
      
      l_v_output_message := Null;
      
    END IF;
    
    RETURN l_v_output_message;
    
  END Get;
  
  
  
  
  
  FUNCTION Get_last RETURN VARCHAR2
  AS
    l_v_output_message VARCHAR2(1000);
  BEGIN
    
    --Si la pile contient des messages, on renvoie le dernier
    IF G_TAB_MESSAGES.Count > 0 THEN
      
      l_v_output_message := G_TAB_MESSAGES(G_TAB_MESSAGES.Last);
      
    ELSE  --Sinon, on renvoie Null
      
      l_v_output_message := Null;
      
    END IF;
    
    RETURN l_v_output_message;
    
  END Get_last;
  
  
  
  
  
  FUNCTION Count RETURN NUMBER
  AS
  BEGIN
    
    RETURN G_TAB_MESSAGES.Count;
    
  END Count;
  
  
  
  
  
END messages;