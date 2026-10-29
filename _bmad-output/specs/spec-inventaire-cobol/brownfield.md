# Notes brownfield

État du code existant à connaître avant refactoring. Aucun de ces points n'est corrigé par la spec.

## Inventaire des fichiers

| Fichier | Rôle |
| --- | --- |
| `cobol/Gnu/Inventaire.cbl` | Traitement quotidien, version de référence (GnuCOBOL, `cobc --free --std=mf`) |
| `cobol/Gnu/Add.cbl` | Saisie interactive d'un article, ajout en fin de `in-items` (`open extend`) |
| `cobol/Gnu/*.sh` | `build.sh` compile, `run.sh` lance `Inventaire`, `add.sh` crée `in-items` puis lance `Add`, `test.sh` = build + run |
| `cobol/mf/src/Inventaire.cbl` | Même traitement pour Micro Focus |
| `cobol/mf/test/TestInventaire.cbl` | Squelette de test MFUnit |

## Anomalies et écarts

| Point | Où | Effet |
| --- | --- | --- |
| Condition probablement inversée | Gnu l.61, MF l.57 : `if name is equal to "Lingot d'or"` | Après échéance, l'article standard ne perd pas 2 points ; le Lingot d'or perd 1 point si son `sell-in` est négatif |
| Zones non signées (MF) | MF l.17-18 : `pic 9(4)` | `sell-in` ne devient jamais négatif (0 - 1 stocke 1) : aucune règle après échéance ne s'exécute ; un Billet périmé oscille entre 0 et 1 jour et gagne 3 points par jour jusqu'à 50 (premier jour constaté à l'exécution, suite déduite du code) |
| Formats incompatibles | Gnu : 54 octets `s9(2)` ; MF : 58 octets `9(4)` | Un fichier d'une version est illisible par l'autre |
| `in-items` non fermé (MF) | MF l.73 | Seul `items` est fermé |
| Test factice (MF) | `TestInventaire.cbl` l.48 | Attend le nom « fixme » pour « foo » : échoue toujours, ne teste aucune règle |
| Débordement silencieux | `sell-in` `s9(2)` | Un `sell-in` à -100 serait tronqué sans alerte |
| Libellés et seuils en dur | Tout le programme | 3 libellés et les valeurs 50, 11, 6, 0 répétés dans des `if` imbriqués ; contrôle par `go to` |

## Cas d'erreur

- `in-items` absent : `Inventaire` s'arrête sur l'erreur d'ouverture du runtime.
- Nom mal orthographié ou casse différente : article traité comme standard.
- `Add` : aucune validation du nom, des bornes ni des doublons.
