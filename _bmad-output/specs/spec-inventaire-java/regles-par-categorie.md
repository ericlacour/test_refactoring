# Règles par catégorie d'article

Matrice de référence de CAP-2 à CAP-5, d'après `java/src/main/java/com/inventaire/Inventaire.java`. « Après échéance » = `sellIn` négatif après le décrément du jour.

| Catégorie (nom exact) | Qualité avant échéance | Qualité après échéance | `sellIn` | Bornes | Code |
| --- | --- | --- | --- | --- | --- |
| Article standard | -1 / jour | -2 / jour | -1 / jour | Plancher 0 | l.17-23, 48-55 |
| Vin rouge | +1 / jour | +2 / jour | -1 / jour | Plafond 50 par incrément | l.24-26, 59-62 |
| Billet de festival | +1 ; +2 si `sellIn` < 11 ; +3 si `sellIn` < 6 (avant décrément) | 0 | -1 / jour | Plafond 50 par incrément | l.28-40, 56-58 |
| Lingot d'or | Inchangée | Inchangée | Inchangé | Aucune | l.20, 44, 52 |

## Exemples de caractérisation

Une ligne = un test. Valeurs `sellIn` / `quality`. Toutes les sorties ont été obtenues en exécutant le code.

| Article | Entrée | Sortie | CAP |
| --- | --- | --- | --- |
| Veste en laine | 10 / 20 | 9 / 19 | CAP-2 |
| Veste en laine | 0 / 20 | -1 / 18 | CAP-2 |
| Veste en laine | 0 / 1 | -1 / 0 | CAP-2 |
| Veste en laine | 5 / 0 | 4 / 0 | CAP-2 |
| Veste en laine | 3 / 60 | 2 / 59 | CAP-2 |
| Vin rouge | 2 / 0 | 1 / 1 | CAP-3 |
| Vin rouge | 0 / 10 | -1 / 12 | CAP-3 |
| Vin rouge | 0 / 49 | -1 / 50 | CAP-3 |
| Vin rouge | 5 / 60 | 4 / 60 | CAP-3 |
| Billet de festival | 15 / 20 | 14 / 21 | CAP-4 |
| Billet de festival | 11 / 20 | 10 / 21 | CAP-4 |
| Billet de festival | 10 / 20 | 9 / 22 | CAP-4 |
| Billet de festival | 6 / 20 | 5 / 22 | CAP-4 |
| Billet de festival | 5 / 20 | 4 / 23 | CAP-4 |
| Billet de festival | 5 / 49 | 4 / 50 | CAP-4 |
| Billet de festival | 0 / 20 | -1 / 0 | CAP-4 |
| Lingot d'or | 0 / 80 | 0 / 80 | CAP-5 |
| Lingot d'or | -1 / 80 | -1 / 80 | CAP-5 |
| Article fragile Vase en verre | 3 / 6 | 2 / 5 | Traité comme standard |
| Article fragile Vase en verre | 0 / 6 | -1 / 4 | Traité comme standard |
| vin rouge (casse différente) | 5 / 10 | 4 / 9 | Traité comme standard |
