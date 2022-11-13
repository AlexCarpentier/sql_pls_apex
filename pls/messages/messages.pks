CREATE OR REPLACE PACKAGE messages 
AS
  
  /* Ajoute le message indiqué à la pile
   *   N.B. : Le message provient de la table business_messages
   */
  PROCEDURE Add (
     p_v_message_name IN VARCHAR2
  );
  
  /* Remet à zéro la pile de messages
   */
  PROCEDURE Reset;
  
  /* Renvoie le texte du message du message demandé dans la langue demandée
   */
  FUNCTION Get (
     p_n_message_index IN NUMBER
  ) RETURN VARCHAR2;
  
  /* Renvoie le texte du dernier message de la pile
   */
  FUNCTION Get_last RETURN VARCHAR2;
  
  /* Renvoie le nombre de message de la pile
   */
  FUNCTION Count RETURN NUMBER;
  
END messages;