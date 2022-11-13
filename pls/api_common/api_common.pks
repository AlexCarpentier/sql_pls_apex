CREATE OR REPLACE PACKAGE api_common 
AS
  
  --Niveaux de messages d'erreurs
  G_STS_SUCCESS         CONSTANT VARCHAR2(1) := 'S';  --Gravité maximale : erreur inattendue
  G_STS_ERROR           CONSTANT VARCHAR2(1) := 'E';  --Gravité : erreur prévue
  G_STS_UNEXPECTED      CONSTANT VARCHAR2(1) := 'U';  --Gravité : Exception gérée n’entrainant pas d’erreur
  G_STS_WARNING         CONSTANT VARCHAR2(1) := 'W';  --Gravité : Exception gérée n’entrainant pas d’erreur
  
  G_ERR_BUSINESS_ERROR           EXCEPTION;
  G_ERR_UNEXPECTED_ERROR         EXCEPTION;
  
  G_MISSING_NUMBER      CONSTANT NUMBER      default 9.99E125;
  G_MISSING_VARCHAR     CONSTANT VARCHAR2(1) default CHR(0);
  G_MISSING_DATE        CONSTANT DATE        default TO_DATE('1','j');
  
END api_common;