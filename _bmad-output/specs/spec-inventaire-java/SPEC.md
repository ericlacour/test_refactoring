---
id: SPEC-inventaire-java
companions:
  - regles-par-categorie.md
  - flux-traitement.md
  - brownfield.md
sources:
  - ../../../java/src/main/java/com/inventaire/Inventaire.java
  - ../../../java/src/main/java/com/inventaire/Item.java
  - ../../../java/src/test/java/com/inventaire/InventaireTest.java
  - ../../../java/src/test/java/com/inventaire/TexttestFixture.java
---

> **Contrat canonique.** Cette SPEC et les fichiers listés dans `companions:` forment le contrat complet, validé en préservation, de ce qu'il faut construire, tester et valider. Les sources du frontmatter servent à la traçabilité.

# Règles métier de la mise à jour quotidienne d'inventaire (Java)

## Why

Le module `java/` est une adaptation française du kata Gilded Rose (Emily Bache, MIT 2015), destinée à être refactorée. Toutes ses règles tiennent dans une seule méthode, `Inventaire.updateQuality()`, faite de `if` imbriqués, et aucun test ne les couvre. Il faut figer le comportement actuel avant de restructurer le code ou d'ajouter la catégorie « Article fragile », annoncée mais non implémentée.

## Capabilities

- **CAP-1**
  - **intent:** Un appel à `updateQuality()` fait vieillir d'un jour chaque article de l'inventaire, en modifiant les objets `Item` en place, dans l'ordre du tableau.
  - **success:** Après un appel sur un tableau de N articles, le tableau contient les mêmes N objets, chacun mis à jour selon sa catégorie (CAP-2 à CAP-5) ; un tableau vide reste vide.
- **CAP-2**
  - **intent:** Un article standard perd 1 point de qualité par jour, 2 points une fois la date de vente dépassée, sans descendre sous 0 ; son `sellIn` baisse de 1 par jour.
  - **success:** Standard 10/20 → 9/19 ; 0/20 → -1/18 ; 0/1 → -1/0 ; 5/0 → 4/0 (`sellIn`/`quality`).
- **CAP-3**
  - **intent:** Le Vin rouge gagne 1 point de qualité par jour, 2 points une fois la date de vente dépassée, sans dépasser 50 ; son `sellIn` baisse de 1 par jour.
  - **success:** Vin rouge 2/0 → 1/1 ; 0/10 → -1/12 ; 0/49 → -1/50.
- **CAP-4**
  - **intent:** Le Billet de festival gagne 1 point par jour, 2 points à 10 jours ou moins, 3 points à 5 jours ou moins, sans dépasser 50, et tombe à 0 une fois le festival passé ; son `sellIn` baisse de 1 par jour.
  - **success:** Billet 15/20 → 14/21 ; 10/20 → 9/22 ; 5/20 → 4/23 ; 5/49 → 4/50 ; 0/20 → -1/0.
- **CAP-5**
  - **intent:** Le Lingot d'or est un article légendaire : ni son `sellIn` ni sa qualité ne changent jamais.
  - **success:** Lingot 0/80 → 0/80 ; -1/80 → -1/80.
- **CAP-6**
  - **intent:** `TexttestFixture` imprime l'état de l'inventaire de démonstration jour après jour, pour servir de référence à un test d'approbation textuel.
  - **success:** Sans argument, la sortie montre les jours 0 et 1 des 9 articles au format `name, sellIn, quality` ; avec l'argument `n`, elle montre les jours 0 à n.

## Constraints

- La catégorie d'un article se déduit d'un `String.equals` exact sur `name` avec « Vin rouge », « Billet de festival » et « Lingot d'or » ; tout autre nom, y compris « Article fragile … », est standard.
- Ordre de traitement d'un article : ajustement de qualité du jour, puis décrément du `sellIn`, puis ajustement « après échéance » si le nouveau `sellIn` est négatif. Les seuils du billet (10 et 5 jours) portent sur le `sellIn` d'avant décrément.
- Les bornes ne jouent que dans le sens de l'évolution : plancher 0 sur les baisses, plafond 50 sur les hausses. Une qualité supérieure à 50 en entrée est conservée telle quelle par le Vin rouge et le Billet.
- `Item` expose `name`, `sellIn` et `quality` en champs publics mutables, sans validation ; Java 1.8, JUnit 5.8.2.

## Non-goals

- Corriger ou faire évoluer les règles : la spec décrit le comportement existant ; tout changement est une décision métier (voir Open Questions).
- Implémenter la catégorie « Article fragile » : elle est seulement signalée comme non fonctionnelle dans `TexttestFixture`.
- Aligner les implémentations COBOL et Java : l'écart est consigné dans `brownfield.md`.

## Success signal

- Un jeu de tests de caractérisation JUnit reprenant chaque ligne de `regles-par-categorie.md` passe sur `Inventaire.java` tel qu'il est, et continue de passer après refactoring de `updateQuality()`.

## Assumptions

- « Article fragile » correspond aux articles « Conjured » du kata, censés se dégrader deux fois plus vite, d'après le commentaire de `TexttestFixture.java` l.21.

## Open Questions

- « Article fragile » doit-il perdre 2 points par jour avant la date et 4 après, et se reconnaît-il au préfixe du nom ?
- La qualité doit-elle être bornée entre 0 et 50 dès la création d'un article (sauf le Lingot d'or à 80) ?
- Faut-il aligner le COBOL sur le Java ? En COBOL, l'article standard ne perd pas 2 points après la date et le Lingot d'or peut perdre 1 point.
