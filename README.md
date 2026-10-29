# test_refactoring
Tests de refactoring avec plusieurs langages de développement

Le dépôt contient le même programme de gestion d'inventaire en deux versions :

- `java/` : version Java (Maven ou Gradle)
- `cobol/` : version COBOL, pour GnuCOBOL (`cobol/Gnu`) et pour Micro Focus (`cobol/mf`)

Les articles gérés sont : Vin rouge, Lingot d'or, Billet de festival,
Article fragile et des articles ordinaires (Veste en laine, Pot de confiture...).

## Version Java

Prérequis : un JDK 8 ou plus récent. Maven et Gradle n'ont pas besoin d'être
installés : les wrappers `mvnw` et `gradlew` les téléchargent.

Toutes les commandes se lancent depuis le dossier `java/` :

```bash
cd java
```

### Tests unitaires (JUnit 5)

Avec Maven :

```bash
./mvnw test
```

Ou avec Gradle :

```bash
./gradlew test
```

Sous Windows, utiliser `mvnw.cmd` ou `gradlew.bat`.

> Le test fourni (`InventaireTest.foo`) échoue volontairement : il attend
> `"fixme"` alors que l'article s'appelle `"foo"`. C'est un point de départ
> à remplacer par de vrais tests avant de refactorer.

### Simulation sur plusieurs jours

`TexttestFixture` affiche l'état de tous les articles jour après jour.
C'est pratique pour comparer la sortie avant et après un refactoring.

```bash
./gradlew -q texttest
```

Par défaut, la simulation couvre 30 jours. Pour un autre nombre de jours, par exemple 10 :

```bash
./gradlew -q texttest --args 10
```

Pour garder une sortie de référence et la comparer après modification :

```bash
./gradlew -q texttest > reference.txt
```

```bash
./gradlew -q texttest | diff reference.txt -
```

## Version COBOL – GnuCOBOL (`cobol/Gnu`)

Prérequis : GnuCOBOL (`cobc` et `cobcrun`), par exemple :

```bash
sudo apt-get install gnucobol
```

Les commandes se lancent depuis `cobol/Gnu` :

```bash
cd cobol/Gnu
```

1. Compiler les programmes :

   ```bash
   ./build.sh
   ```

2. Ajouter des articles dans le fichier d'entrée `in-items`. Le programme demande
   le nom, le `sell-in` puis la qualité ; relancer la commande pour chaque article :

   ```bash
   ./add.sh
   ```

3. Lancer le traitement d'une journée. Le résultat est écrit dans le fichier `items` :

   ```bash
   ./run.sh
   ```

   `./test.sh` enchaîne la compilation et l'exécution. Il faut avoir créé
   `in-items` avec `./add.sh` au préalable, sinon le programme s'arrête
   (fichier introuvable).

Pour simuler le jour suivant, utiliser la sortie comme nouvelle entrée, puis relancer :

```bash
mv items in-items
```

```bash
./run.sh
```

## Version COBOL – Micro Focus (`cobol/mf`)

Cette version nécessite Micro Focus Visual COBOL / Enterprise Developer
(Eclipse) et le framework de tests MFUnit.

1. Importer les projets `cobol/mf/src` (projet `Inventaire`) et
   `cobol/mf/test` (projet `Tests`) dans l'espace de travail Eclipse.
2. Compiler les deux projets. Le projet `Tests` dépend du projet `Inventaire`.
3. Exécuter `TestInventaire.cbl` avec le lanceur de tests MFUnit de l'IDE.

> Comme en Java, le test fourni échoue volontairement (il attend `fixme`).
