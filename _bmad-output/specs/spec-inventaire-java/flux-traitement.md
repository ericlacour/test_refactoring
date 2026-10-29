# Flux de traitement d'un article

Déroulé de `Inventaire.updateQuality()` pour un élément du tableau `items`. Chaque `+1` n'est appliqué que si la qualité est inférieure à 50 ; chaque `-1` que si elle est supérieure à 0.

```mermaid
flowchart TD
    R[Article suivant du tableau] -->|plus d'article| F[Fin]
    R --> C{Catégorie ?}
    C -->|Standard| S1[qualité -1]
    C -->|Lingot d'or| L1[aucun changement]
    C -->|Vin rouge| V1[qualité +1]
    C -->|Billet de festival| B1[qualité +1]
    B1 --> B2{sellIn < 11 ?}
    B2 -->|oui| B3[qualité +1]
    B2 -->|non| B4
    B3 --> B4{sellIn < 6 ?}
    B4 -->|oui| B5[qualité +1]
    B4 -->|non| D
    B5 --> D
    S1 --> D
    V1 --> D
    L1 --> D
    D[sellIn -1, sauf Lingot d'or] --> E{sellIn < 0 ?}
    E -->|non| R
    E -->|oui, Standard| E0[qualité -1]
    E -->|oui, Vin rouge| E1[qualité +1]
    E -->|oui, Billet| E2[qualité = 0]
    E -->|oui, Lingot d'or| R
    E0 --> R
    E1 --> R
    E2 --> R
```
