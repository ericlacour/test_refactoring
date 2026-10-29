---
title: Écarts de règles métier entre Java et COBOL
date: 2026-10-29
compare:
  - ../specs/spec-inventaire-java/SPEC.md
  - ../specs/spec-inventaire-cobol/SPEC.md
---

# Écarts de règles métier entre Java et COBOL

Java (`java/.../Inventaire.java`) et COBOL GnuCOBOL (`cobol/Gnu/Inventaire.cbl`) partagent la même structure et donnent le même résultat sur 18 des 21 cas testés, mais divergent sur deux règles : la dégradation des articles standard après échéance et l'immuabilité du Lingot d'or. Ces deux écarts viennent d'une seule condition inversée dans le COBOL. La variante Micro Focus (`cobol/mf/src/Inventaire.cbl`) diverge en plus sur toutes les règles après échéance, car ses zones numériques sont non signées.

Le Java est conforme au kata Gilded Rose d'origine ; il est proposé comme référence (voir Décisions à prendre).

## Méthode

Les trois implémentations ont été exécutées sur les mêmes 21 articles, pour un jour de traitement :

- Java : `Inventaire.java` et `Item.java` compilés tels quels (javac).
- COBOL GnuCOBOL : `cobol/Gnu/Inventaire.cbl` compilé tel quel (`cobc --free --std=mf`, GnuCOBOL 3.1.2).
- COBOL Micro Focus : GnuCOBOL ne reconnaît pas la syntaxe `less then` / `greater then` de ce fichier ; il a été compilé après remplacement de `then` par `than`, sans autre modification. Le comportement réel sous un compilateur Micro Focus reste à confirmer.

## Synthèse des écarts

| # | Règle | Java | COBOL GnuCOBOL | COBOL Micro Focus | Cause | Gravité |
| --- | --- | --- | --- | --- | --- | --- |
| E1 | Article standard après échéance | -2 par jour | -1 par jour | Jamais en échéance | Condition inversée (COBOL Gnu l.61, MF l.57) | Haute : valeur de stock fausse dès le 1er jour après la date |
| E2 | Lingot d'or avec `sellIn` négatif | Inchangé | -1 par jour | `sellIn` stocké positif, inchangé | Même condition inversée | Moyenne : ne survient que si le Lingot est saisi avec un `sellIn` négatif |
| E3 | Passage en échéance (`sellIn` < 0) | Oui | Oui | Jamais : 0 - 1 donne 1 | `pic 9(4)` non signé (MF l.17-18) | Haute : Vin rouge, Billet et standard ne passent jamais en régime « après échéance » |
| E4 | Billet de festival après le concert | 0 | 0 | +3 par jour jusqu'à 50, `sellIn` oscillant entre 0 et 1 | Conséquence de E3 | Haute : un billet périmé prend de la valeur au lieu de la perdre |
| E5 | Valeurs saisissables | `int` (±2 milliards) | `s9(2)` : -99 à 99 | `9(4)` : 0 à 9999 | Formats de données | Faible tant que les valeurs restent dans -99..99 |
| E6 | Format d'échange | Objets en mémoire | Enregistrement de 54 octets | Enregistrement de 58 octets | Formats de données | Moyenne : fichiers non interchangeables entre les deux COBOL |
| E7 | Saisie d'un article | Constructeur `Item`, sans validation | Programme `Add`, sans validation | Pas de programme de saisie | Périmètre | Faible : aucune des deux ne valide |
| E8 | Article fragile | Absent du code, présent dans le jeu de démonstration | Absent | Absent | Évolution non implémentée | Aucune divergence, mais aucune version n'implémente la règle |

Règles identiques dans les trois versions, avant échéance : standard -1 par jour avec plancher 0 ; Vin rouge +1 par jour avec plafond 50 ; Billet +1, +2 à 10 jours ou moins, +3 à 5 jours ou moins, avec plafond 50 ; Lingot d'or inchangé ; reconnaissance par nom exact, sensible à la casse ; bornes appliquées seulement dans le sens de l'évolution.

## Résultats d'exécution, cas par cas

Valeurs `sellIn` / `quality` après un jour. En gras, les sorties qui diffèrent du Java.

| Article | Entrée | Java | COBOL GnuCOBOL | COBOL Micro Focus | Écart |
| --- | --- | --- | --- | --- | --- |
| Veste en laine | 10 / 20 | 9 / 19 | 9 / 19 | 9 / 19 | — |
| Veste en laine | 0 / 20 | -1 / 18 | **-1 / 19** | **1 / 19** | E1, E3 |
| Veste en laine | 0 / 1 | -1 / 0 | -1 / 0 | **1 / 0** | E3 |
| Veste en laine | 5 / 0 | 4 / 0 | 4 / 0 | 4 / 0 | — |
| Veste en laine | 3 / 60 | 2 / 59 | 2 / 59 | 2 / 59 | — |
| Vin rouge | 2 / 0 | 1 / 1 | 1 / 1 | 1 / 1 | — |
| Vin rouge | 0 / 10 | -1 / 12 | -1 / 12 | **1 / 11** | E3 |
| Vin rouge | 0 / 49 | -1 / 50 | -1 / 50 | **1 / 50** | E3 |
| Vin rouge | 5 / 60 | 4 / 60 | 4 / 60 | 4 / 60 | — |
| Billet de festival | 15 / 20 | 14 / 21 | 14 / 21 | 14 / 21 | — |
| Billet de festival | 11 / 20 | 10 / 21 | 10 / 21 | 10 / 21 | — |
| Billet de festival | 10 / 20 | 9 / 22 | 9 / 22 | 9 / 22 | — |
| Billet de festival | 6 / 20 | 5 / 22 | 5 / 22 | 5 / 22 | — |
| Billet de festival | 5 / 20 | 4 / 23 | 4 / 23 | 4 / 23 | — |
| Billet de festival | 5 / 49 | 4 / 50 | 4 / 50 | 4 / 50 | — |
| Billet de festival | 0 / 20 | -1 / 0 | -1 / 0 | **1 / 23** | E3, E4 |
| Lingot d'or | 0 / 80 | 0 / 80 | 0 / 80 | 0 / 80 | — |
| Lingot d'or | -1 / 80 | -1 / 80 | **-1 / 79** | **1 / 80** (`sellIn` saisi -1, stocké 1) | E2, E3 |
| Article fragile Vase en verre | 3 / 6 | 2 / 5 | 2 / 5 | 2 / 5 | — |
| Article fragile Vase en verre | 0 / 6 | -1 / 4 | **-1 / 5** | **1 / 5** | E1, E3 |
| vin rouge (casse différente) | 5 / 10 | 4 / 9 | 4 / 9 | 4 / 9 | — |

Bilan : GnuCOBOL diffère du Java sur 3 cas sur 21, Micro Focus sur 7 sur 21.

## Origine de l'écart E1 / E2

Le même bloc, phase « après échéance », pour un article qui n'est ni Vin rouge ni Billet :

```java
// java/src/main/java/com/inventaire/Inventaire.java, l.51-55
if (items[i].quality > 0) {
    if (!items[i].name.equals("Lingot d'or")) {   // tout sauf le Lingot perd 1 point
        items[i].quality = items[i].quality - 1;
    }
}
```

```cobol
*> cobol/Gnu/Inventaire.cbl, l.60-64 (identique dans mf/src l.56-60)
if quality > 0
    if name is equal to "Lingot d'or"             *> seul le Lingot perd 1 point
        compute quality = quality - 1
    end-if
end-if
```

Remplacer `is equal to` par `is not equal to` aligne les deux COBOL sur le Java pour E1 et E2.

## Décisions à prendre

- [ ] Retenir le Java (conforme au kata) comme référence des règles métier ?
- [ ] Corriger la condition inversée du COBOL (E1, E2), ou la conserver si elle reflète une vraie règle métier ?
- [ ] Passer les zones `sell-in` et `quality` de la version Micro Focus en signé (`s9(4)`) pour rétablir les règles après échéance (E3, E4) ?
- [ ] Unifier le format d'enregistrement des deux COBOL dans un copybook commun (E5, E6) ?
- [ ] Spécifier « Article fragile » une seule fois, puis l'implémenter dans toutes les versions conservées (E8) ?
