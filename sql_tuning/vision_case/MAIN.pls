CREATE OR REPLACE PACKAGE main
AS

  PROCEDURE main( 
      AgenceId IN NUMBER
     ,deuxiemeparam IN DATE
     ,nom_fichier IN VARCHAR2
  );
  END;

/

CREATE OR REPLACE PACKAGE BODY main
AS

  PROCEDURE AppendFile (
     p_f_OutputFile IN UTL_FILE.file_type  --fichier dans lequel insérée le texte
    ,p_v_text IN VARCHAR2  --Texte à afficher dans la sortie
  )
  IS
  BEGIN
    UTL_FILE.PUT_LINE (p_f_OutputFile,p_v_text);
  END AppendFile;


  PROCEDURE main( 
     AgenceId IN NUMBER
    ,deuxiemeparam IN DATE
    ,nom_fichier IN VARCHAR2
  )
  IS
  
  --variable de parcours du cursor C1
  idparam PO_HEADERS_ALL.ORG_ID%TYPE;  truc UTL_FILE.file_type; nom HR_ALL_ORGANIZATION_UNITS.NAME%TYPE;
  NumeroCommande PO_HEADERS_ALL.SEGMENT1%TYPE; DateFermeture PO_HEADERS_ALL.CLOSED_DATE%TYPE;
  
  -- variable temporaire pour le statut de la commande
  sTmpStatut VARCHAR2(100);
  -- variable temporaire pour l'afficheage des contacts 
  sTmpContact VARCHAR(500);
  
  CURSOR C1 IS
    select org_id, hr_all_organization_units.name,segment1,closed_date , po_headers_all.po_header_id
    from po_headers_all,hr_all_organization_units 
    where hr_all_organization_units.organization_id = PO_HEADERS_ALL.org_id 
    and TRUNC(closed_date) = TRUNC(deuxiemeparam)
    and org_id = AgenceId; test2 NUMBER; test14 VARCHAR2(30000);
    
    l_n_hdr_id NUMBER; cpt NUMBER := 1;
    sonnom VARCHAR2(13000); bonjour NUMBER; bonjour2 NUMBER; bonjour3_pour_cpt NUMBER;
  
  BEGIN
    
    truc  := UTL_FILE.FOPEN (
                location  => 'DISPLAY_ORDERS'
               ,filename  => nom_fichier
               ,open_mode => 'W'
             );
             
select COUNT(closed_date) into bonjour
    from po_headers_all,hr_all_organization_units 
    where hr_all_organization_units.organization_id = PO_HEADERS_ALL.org_id 
    and TRUNC(closed_date) = TRUNC(deuxiemeparam)
    and org_id = AgenceId;
    
    AppendFile(truc,'Affichage des commandes de l''organisation n°'||AgenceId||' fermées le '||TO_CHAR(deuxiemeparam,'DD/MM/YYYY'));
    AppendFile(truc,'Nombre de commande trouvées : '||TO_CHAR(bonjour));
  
    --parcours des commandes
    --les commandes sont filtré avec leur date de fermeture (passé en paramètre) et l'agence (passé aussi en paramètre)
    OPEN C1;
    LOOP
    FETCH C1 INTO idparam, nom, NumeroCommande, DateFermeture, l_n_hdr_id; 
    EXIT WHEN C1%NOTFOUND;
      -- affichage du numero de commande
        AppendFile(truc,'**************************************');
        --AppendFile(truc,'**************************************');
        select COUNT(closed_date) into bonjour2
    from po_headers_all,hr_all_organization_units 
    where hr_all_organization_units.organization_id = PO_HEADERS_ALL.org_id 
    and TRUNC(closed_date) = TRUNC(deuxiemeparam)
    and org_id = AgenceId;
        AppendFile(truc,'Commande n° '||TO_CHAR(cpt)||' / '||TO_CHAR(bonjour2));
        cpt := cpt + 1;
        select name into sonnom from hr_all_organization_units where organization_id = AgenceId;
        AppendFile(truc,'Agence : '||sonnom);
        
        AppendFile(truc,'Commande n°'||NumeroCommande);
      
      --recherche du nom de l'acheteur
        AppendFile(truc,'Liste des acheteurs');
        for NomVendeur in (  select distinct full_name  
                              from po_headers_all, po_agents,per_all_people_f 
                              where po_agents.agent_id = per_all_people_f.person_id and po_agents.agent_id = po_headers_all.agent_id  and segment1 = NumeroCommande and po_headers_all.org_id = AgenceId)
        loop
          -- affichage des acheteurs
          AppendFile(truc, '   '||NomVendeur.full_name);  
        end loop;
      --fin recherche du nom de l'acheteur
      
      --recherche de fournisseurs
        AppendFile(truc,'Liste des fournisseurs');
        for LeFournisseur in (select distinct PO_VENDORS.vendor_name as NomFournisseur, PO_VENDOR_CONTACTS.prefix  as LePrefix,PO_VENDOR_CONTACTS.Last_name as LeNom,PO_VENDOR_CONTACTS.first_name as prenom,PO_VENDOR_CONTACTS.phone as telephone from PO_VENDORS, PO_VENDOR_CONTACTS, po_headers_all  where po_vendor_contacts.vendor_contact_id = po_headers_all.vendor_contact_id and po_vendor_contacts.vendor_id = PO_VENDORS.vendor_id and po_headers_all.segment1 = NumeroCommande and po_headers_all.org_id = AgenceId)loop
          --affichage des fournisseurs
            sTmpContact := '  Fournisseur : ' || LeFournisseur.NomFournisseur;
            AppendFile(truc,sTmpContact);
            sTmpContact :='    Nom du contact : ' ||LeFournisseur.LePrefix||' '||LeFournisseur.LeNom||' '||LeFournisseur.prenom;
            AppendFile(truc,sTmpContact);
            sTmpContact :='      Numéro de téléphone : '||LeFournisseur.telephone;
            AppendFile(truc,sTmpContact);
        end loop;
      --fin de recherche de fournisseurs
      
      select SUM(PO_VENDOR_CONTACTS.vendor_contact_id) into bonjour3_pour_cpt from PO_VENDORS, PO_VENDOR_CONTACTS, po_headers_all 
                              where po_vendor_contacts.vendor_contact_id = po_headers_all.vendor_contact_id
                              and po_vendor_contacts.vendor_id = PO_VENDORS.vendor_id
                              and po_headers_all.segment1 = NumeroCommande and po_headers_all.org_id = AgenceId;
      
      --statut de la commande
        sTmpStatut := '';
        select  closed_code into sTmpStatut from po_headers_all where segment1 = NumeroCommande and org_id = AgenceId;
        --affichage du statut
        AppendFile(truc,'statut de la commande : '||sTmpStatut);
      --fin statut de la commande
      
      --recherche articles
        AppendFile(truc,'Liste des articles : ');
        
        for ListeArticles in (select PO_HEADERS_ALL.segment1 as numcommande,item_description , (((po_lines_all.unit_price) * (quantity))) test
                                from po_lines_all,po_headers_all 
                                WHERE po_lines_all.po_header_id = po_headers_all.po_header_id and segment1 = NumeroCommande and po_headers_all.org_id = AgenceId)
        loop
          --affichage de l'article
          SELECT currency_code INTO test14 FROM po_headers_all WHERE org_id=AgenceId AND segment1=NumeroCommande;
           AppendFile(truc,ListeArticles.item_description||' - Prix : '||ListeArticles.test||' '||test14);
        end loop;
        
        select SUM(po_lines_all.unit_price * quantity) into test2
                                from po_lines_all,po_headers_all 
                                WHERE po_lines_all.po_header_id = po_headers_all.po_header_id and segment1 = NumeroCommande and po_headers_all.org_id = AgenceId;
                                
                                SELECT currency_code INTO test14 FROM po_headers_all WHERE org_id=AgenceId AND segment1=NumeroCommande;  AppendFile(truc,'Montant total : '||TO_CHAR(ROUND(test2,2))||' '||test14);
        
      --fin recherche articles
      
      --recherche factures ap
      for ListeFactures in (select invoice_num as Facture, po_headers_all.segment1 as NumCommande,ap_invoices_all.invoice_id from ap_invoice_distributions_all,ap_invoices_all,po_distributions_all,po_headers_all where ap_invoices_all.invoice_id = ap_invoice_distributions_all.invoice_id
                              AND  ap_invoice_distributions_all.po_distribution_id =  po_distributions_all.po_distribution_id AND po_distributions_all.po_header_id = po_headers_all.po_header_id
                              and  po_headers_all.segment1 = NumeroCommande and po_headers_all.org_id = AgenceId)
      loop
        --affichage du numéro de facture
        AppendFile(truc,'Facture : '||ListeFactures.Facture);
      end loop;
      --fin recherche factures ap
      
    END LOOP;
    CLOSE C1;
    --fin parcours des commandes
    
    --UTL_FILE.FCLOSE(truc);
    
  end;END;