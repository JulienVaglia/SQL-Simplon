-- ******************
-- Exercices Imbrication
-- ******************
-- 1. Afficher le prénom des abonnés ayant emprunté un livre le 2011-12-19
SELECT prenom FROM abonne WHERE id_abonne IN ( SELECT id_abonne FROM emprunt WHERE date_sortie='2011-12-19' );

-- 2. Afficher le prénom des abonnés ayant emprunté un livre d'Alphonse Daudet
SELECT prenom FROM abonne WHERE id_abonne IN ( SELECT id_livre FROM emprunt WHERE id_livre IN(SELECT id_livre from livre WHERE auteur='ALPHONSE DAUDET'));

-- 3. Afficher le titre des livres que Chloé a empruntés
SELECT titre FROM livre WHERE id_livre IN ( SELECT id_livre from emprunt WHERE id_abonne IN ( SELECT id_abonne FROM abonne WHERE prenom='Chloé' ) )

-- 4. Afficher le titre des livres que Chloé n'a pas encore empruntés
SELECT titre FROM livre WHERE id_livre NOT IN ( SELECT id_livre FROM emprunt WHERE id_abonne IN ( SELECT id_abonne FROM abonne WHERE prenom='Chloé' ) )

-- 5. Afficher le titre des livres que Chloé n'a pas encore rendus
SELECT titre FROM livre WHERE id_livre IN ( SELECT id_livre FROM emprunt WHERE date_rendu IS NULL AND id_abonne IN( SELECT id_abonne from abonne WHERE prenom='Chloé') );

-- 6. Combien de livres Benoît a empruntés ?
SELECT count(*) FROM livre WHERE id_livre IN ( SELECT id_livre FROM emprunt WHERE id_abonne IN ( SELECT id_abonne FROM abonne WHERE prenom='Benoît'));


-- *********************
-- Exercices Jointure internes
-- *********************
-- 1. Afficher le titre, date de sortie et date de rendu des livres écrits par Alphonse Daudet.
SELECT li.titre, em.date_sortie, em.date_rendu
FROM livre li
INNER JOIN emprunt em
ON li.id_livre=em.id_livre
WHERE li.auteur = 'Alphonse Daudet';

-- 2. Afficher qui (prénom) a emprunté "Une vie" sur 2011.
SELECT ab.prenom
from abonne ab
INNER JOIN emprunt em
ON ab.id_abonne= em.id_abonne
INNER JOIN livre li
ON em.id_livre=li.id_livre
WHERE li.titre='Une vie' AND em.date_sortie LIKE '2011%';


-- 3. Afficher le nombre de livres empruntés par chaque abonné (prénom).


-- 4. Afficher qui (prénom) a emprunté quels livres (titre) et à quelles dates (date de sortie).



-- *********************
-- Exercices Jointure Externe
-- *********************
-- Voici un exemple avec un livre supprimé de la bibliothèque (Une vie) :
DELETE FROM livre WHERE id_livre = 100;

-- Exercice :
-- 1° Afficher la liste des emprunts (id_emprunt) avec le titre des livres qui existent encore.



-- 2° Afficher la liste de TOUS les emprunts avec le titre des livres, y compris les emprunts pour lesquels il n'y a plus de livre en bibliothèque.



-- *********************
-- Exercices Jointure + Union
-- *********************
-- ******

-- 1. Qui (prenom) conduit la voiture d'id 503 en requête imbriquée ?
SELECT prenom FROM conducteur WHERE id_conducteur IN ( SELECT id_conducteur FROM association_vehicule_conducteur WHERE id_vehicule='503' );

-- 2. Qui conduit quel modèle (prenom, modele) ?
SELECT cond.prenom, vh.modele
FROM conducteur cond
INNER JOIN association_vehicule_conducteur asso
ON cond.id_conducteur=asso.id_conducteur
INNER JOIN vehicule vh
ON vh.id_vehicule=asso.id_vehicule;

-- 3. Ajoutez vous dans la table conducteur.
INSERT INTO conducteur (prenom, nom) VALUES ('John', 'Wayne');
--    Afficher TOUS les conducteurs (prenom) ainsi que les modèles de véhicules.
SELECT cond.prenom, vh.modele
FROM conducteur cond
LEFT JOIN association_vehicule_conducteur asso
ON cond.id_conducteur=asso.id_conducteur
LEFT JOIN vehicule vh
ON vh.id_vehicule=asso.id_vehicule;

-- 4. Ajoutez un véhicule dans la table correspondante.
INSERT INTO vehicule (modele, marque, couleur, immatriculation) VALUES('Mustang', 'Ford', 'Black', 'AZ-123-ER');
--    Afficher TOUS les modèles de véhicules, y compris ceux qui n'ont pas de chauffeur, et le prénom des conducteurs.
SELECT vh.modele, cond.prenom
FROM vehicule vh
LEFT JOIN association_vehicule_conducteur asso
ON vh.id_vehicule=asso.id_vehicule
LEFT JOIN conducteur cond
ON cond.id_conducteur=asso.id_conducteur
;

-- 5. Afficher TOUS les conducteurs (prenom) et TOUS les modèles de véhicules.
(SELECT vh.modele, cond.prenom
FROM vehicule vh
LEFT JOIN association_vehicule_conducteur asso
ON vh.id_vehicule=asso.id_vehicule
LEFT JOIN conducteur cond
ON cond.id_conducteur=asso.id_conducteur
)
UNION
(SELECT cond.prenom, vh.modele
FROM conducteur cond
LEFT JOIN association_vehicule_conducteur asso
ON cond.id_conducteur=asso.id_conducteur
LEFT JOIN vehicule vh
ON vh.id_vehicule=asso.id_vehicule);