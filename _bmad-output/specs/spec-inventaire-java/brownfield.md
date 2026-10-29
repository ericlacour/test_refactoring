# Notes brownfield

État du code existant à connaître avant refactoring. Aucun de ces points n'est corrigé par la spec.

## Inventaire des fichiers

| Fichier | Rôle |
| --- | --- |
| `java/src/main/java/com/inventaire/Inventaire.java` | Toutes les règles, dans `updateQuality()` |
| `java/src/main/java/com/inventaire/Item.java` | Article : `name`, `sellIn`, `quality` publics ; `toString()` = `name, sellIn, quality` |
| `java/src/test/java/com/inventaire/InventaireTest.java` | Test JUnit unique, factice |
| `java/src/test/java/com/inventaire/TexttestFixture.java` | Jeu de démonstration de 9 articles, imprimé jour par jour |
| `java/pom.xml`, `java/build.gradle` | Build Maven ou Gradle ; Java 1.8, JUnit 5.8.2 |

## Anomalies et dettes

| Point | Où | Effet |
| --- | --- | --- |
| Test factice | `InventaireTest.java` l.19 | Attend le nom « fixme » pour « foo » : échoue toujours, ne teste aucune règle |
| « Article fragile » non implémenté | `TexttestFixture.java` l.21-22 | « Article fragile Vase en verre » vieillit comme un article standard |
| Pas de validation | `Item.java` | Champs publics mutables ; `name` null provoque une `NullPointerException` dans `updateQuality()` |
| Libellés et seuils en dur | `Inventaire.java` | 3 libellés comparés 8 fois, valeurs 50, 11, 6, 0 en dur, `if` imbriqués sur 4 niveaux |
| Remise à zéro obscure | `Inventaire.java` l.57 | `quality - quality` au lieu de `0` |

## Écart avec l'implémentation COBOL

| Règle | Java | COBOL (`cobol/Gnu/Inventaire.cbl`) |
| --- | --- | --- |
| Article standard après échéance | -2 par jour (l.52 : `!equals("Lingot d'or")`) | -1 par jour (l.61 : `is equal to "Lingot d'or"`) |
| Lingot d'or avec `sellIn` négatif | Inchangé | -1 par jour |

Le Java est conforme au kata d'origine ; le COBOL inverse la condition. Voir `_bmad-output/specs/spec-inventaire-cobol/`.
