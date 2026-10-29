---
id: SPEC-inventaire-cobol
companions:
  - regles-par-categorie.md
  - flux-traitement.md
  - brownfield.md
sources:
  - ../../../cobol/Gnu/Inventaire.cbl
  - ../../../cobol/Gnu/Add.cbl
  - ../../../cobol/mf/src/Inventaire.cbl
  - ../../../cobol/mf/test/TestInventaire.cbl
---

> **Contrat canonique.** Cette SPEC et les fichiers listés dans `companions:` forment le contrat complet, validé en préservation, de ce qu'il faut construire, tester et valider. Les sources du frontmatter servent à la traçabilité.

# Règles métier du traitement quotidien d'inventaire (COBOL)

## Why

Le répertoire `cobol/` contient un traitement d'inventaire hérité, adaptation française du kata Gilded Rose (Emily Bache, MIT 2015), destiné à être refactoré. Ses règles ne sont écrites nulle part ailleurs que dans des `if` imbriqués. Avant tout refactoring, il faut figer le comportement actuel, anomalies comprises, pour pouvoir le tester et décider explicitement de ce qui doit changer. Version de référence : `cobol/Gnu/Inventaire.cbl`.

## Capabilities

- **CAP-1**
  - **intent:** Chaque exécution d'`Inventaire` fait vieillir d'un jour tous les articles du stock : elle lit `in-items` et écrit dans `items` un article mis à jour par article lu, dans le même ordre.
  - **success:** Pour un fichier de N articles, `items` contient exactement N enregistrements dans l'ordre d'entrée ; un `in-items` vide produit un `items` vide.
- **CAP-2**
  - **intent:** Un article standard (tout nom autre que les trois libellés spéciaux) perd 1 point de qualité par jour, sans descendre sous 0, et son `sell-in` baisse de 1 par jour, avant comme après la date de vente.
  - **success:** Standard 10/20 → 9/19 ; 0/20 → -1/19 ; 5/0 → 4/0 (`sell-in`/`quality`).
- **CAP-3**
  - **intent:** Le Vin rouge gagne 1 point de qualité par jour, 2 points une fois la date de vente dépassée, sans dépasser 50 ; son `sell-in` baisse de 1 par jour.
  - **success:** Vin rouge 2/0 → 1/1 ; 0/10 → -1/12 ; 0/49 → -1/50.
- **CAP-4**
  - **intent:** Le Billet de festival gagne 1 point par jour, 2 points à 10 jours ou moins, 3 points à 5 jours ou moins, sans dépasser 50, et tombe à 0 une fois le festival passé ; son `sell-in` baisse de 1 par jour.
  - **success:** Billet 15/20 → 14/21 ; 10/20 → 9/22 ; 5/20 → 4/23 ; 5/49 → 4/50 ; 0/20 → -1/0.
- **CAP-5**
  - **intent:** Le Lingot d'or ne vieillit pas : son `sell-in` et sa qualité restent inchangés, sauf s'il arrive avec un `sell-in` déjà négatif, auquel cas sa qualité baisse de 1 par jour tant qu'elle est positive.
  - **success:** Lingot 0/80 → 0/80 ; -1/80 → -1/79.
- **CAP-6**
  - **intent:** Un opérateur peut ajouter un article au stock en saisissant son nom, son `sell-in` et sa qualité.
  - **success:** Après `add.sh` avec « Vin rouge », 5, 10, le dernier enregistrement de `in-items` vaut `sell-in` 5, `quality` 10, `name` « Vin rouge » ; les articles existants sont conservés.

## Constraints

- La catégorie d'un article se déduit d'une comparaison exacte de `name` (casse et espaces compris) avec « Vin rouge », « Billet de festival » et « Lingot d'or » ; tout autre nom, même proche, est standard.
- Ordre de traitement d'un article : ajustement de qualité du jour, puis décrément du `sell-in`, puis ajustement « après échéance » si le nouveau `sell-in` est négatif, puis écriture. Les seuils du billet (10 et 5 jours) portent sur le `sell-in` d'avant décrément.
- Les bornes ne jouent que dans le sens de l'évolution : plancher 0 sur les baisses, plafond 50 sur les hausses. Une qualité saisie au-delà de 50 n'est jamais ramenée à 50.
- Format d'enregistrement (GnuCOBOL) : 54 octets, `sell-in` `s9(2)`, `quality` `s9(2)`, `name` `x(50)` ; fichiers séquentiels `in-items` (entrée) et `items` (sortie, recréé à chaque exécution).
- Aucune gestion d'erreur : ni `file status`, ni code retour, ni `on size error`. `Add` ne valide aucune saisie.

## Non-goals

- Corriger les anomalies relevées : la spec décrit le comportement existant ; tout changement de règle est une décision métier (voir Open Questions).
- Réconcilier les versions GnuCOBOL et Micro Focus : leurs écarts sont consignés dans `brownfield.md`, pas arbitrés ici.
- Gérer d'autres catégories d'articles (par exemple les articles « Conjured » de certaines variantes du kata).

## Success signal

- Un jeu de tests de caractérisation reprenant chaque exemple de CAP-1 à CAP-6 passe sur `cobol/Gnu/Inventaire.cbl` tel qu'il est, et continue de passer après refactoring tant qu'aucune question ouverte n'a été tranchée dans un autre sens.

## Assumptions

- La condition `if name is equal to "Lingot d'or"` de la phase après échéance (`Gnu/Inventaire.cbl` l.61, `mf/src/Inventaire.cbl` l.57) est probablement une inversion involontaire du `not equal` du kata ; elle est documentée telle qu'elle s'exécute (CAP-2, CAP-5).
- Les valeurs des critères de succès ont été confirmées en exécutant `cobol/Gnu/Inventaire.cbl` sous GnuCOBOL 3.1.2.

## Open Questions

- Un article standard doit-il perdre 2 points par jour après la date de vente, comme dans le kata d'origine (CAP-2) ?
- Le Lingot d'or doit-il rester totalement immuable, même avec un `sell-in` négatif en entrée (CAP-5) ?
- Quelle version fait référence : GnuCOBOL (54 octets, signé) ou Micro Focus (58 octets, non signé) ?
- `Add` doit-il valider la qualité (0 à 50, alors que le Lingot d'or vaut 80 dans le kata) et le nom (CAP-6) ?
