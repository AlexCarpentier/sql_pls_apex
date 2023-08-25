/*
 * Fait par Alexandre Carpentier
 * 
 **/

--Définition du container par défaut en cas de connexion sur le container
ALTER SESSION SET CONTAINER = XEPDB1;

--Directory de chargement du dump

/**** ############ Remplacer les 2 chemins par des répertoires existants sur votre machine, il est conseillé de garder le nom du répertoire final ("sortie_oracle" et "dump_data") ############ ****/
create or replace directory DISPLAY_ORDERS as 'C:\app\sortie_oracle';
create or replace directory DUMP_DATA      as 'C:\app\dump_data';

--Création du tablespace

/**** ############ Remplacer le chemin par le chemin ou sont présents vos datafiles ############ ****/
create tablespace apps_ts_tx_data datafile 'C:\app\Alexandre\product\21c\oradata\XE\data_ts4.f' SIZE 4G;   --18c


--Utilisateur PO
create user po identified by po;
alter user po default tablespace apps_ts_tx_data;
GRANT UNLIMITED TABLESPACE TO po;

--Utilisateur AP
create user ap identified by ap;
alter user ap default tablespace apps_ts_tx_data;
GRANT UNLIMITED TABLESPACE TO ap;

--Utilisateur AR
create user ar identified by ar;
alter user ar default tablespace apps_ts_tx_data;
GRANT UNLIMITED TABLESPACE TO ar;

--Utilisateur APPS
create user apps identified by apps;
alter user apps default tablespace apps_ts_tx_data;
GRANT UNLIMITED TABLESPACE TO apps;

--Utilisateur HR9
create user hr9 identified by hr;
alter user hr9 default tablespace apps_ts_tx_data;
GRANT UNLIMITED TABLESPACE TO hr9;

--Droits finaux
GRANT dba to apps;
