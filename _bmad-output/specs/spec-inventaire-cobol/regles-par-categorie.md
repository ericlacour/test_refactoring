# Règles par catégorie d'article

Matrice de référence de CAP-2 à CAP-5, d'après `cobol/Gnu/Inventaire.cbl`. « Après échéance » = `sell-in` négatif après le décrément du jour.

| Catégorie (nom exact) | Qualité avant échéance | Qualité après échéance | `sell-in` | Bornes | Code |
| --- | --- | --- | --- | --- | --- |
| Article standard | -1 / jour | -1 / jour (pas d'accélération) | -1 / jour | Plancher 0 | l.31-36, 57-64 |
| Vin rouge | +1 / jour | +2 / jour | -1 / jour | Plafond 50 par incrément | l.37-39, 68-71 |
| Billet de festival | +1 ; +2 si `sell-in` < 11 ; +3 si `sell-in` < 6 (avant décrément) | 0 | -1 / jour | Plafond 50 par incrément | l.40-51, 65-67 |
| Lingot d'or | Inchangée | Inchangée ; -1 / jour si `sell-in` < 0 dès l'entrée et qualité > 0 | Inchangé | Aucune | l.33, 54, 61 |

## Exemples de caractérisation

Une ligne = un test. Valeurs `sell-in` / `quality`.

| Catégorie | Entrée | Sortie | CAP |
| --- | --- | --- | --- |
| Article standard | 10 / 20 | 9 / 19 | CAP-2 |
| Article standard | 0 / 20 | -1 / 19 | CAP-2 |
| Article standard | 5 / 0 | 4 / 0 | CAP-2 |
| Article standard | 3 / 60 | 2 / 59 | CAP-2 |
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
| Lingot d'or | -1 / 80 | -1 / 79 | CAP-5 |
| « vin rouge » (casse différente) | 5 / 10 | 4 / 9 | Contrainte de nommage |
