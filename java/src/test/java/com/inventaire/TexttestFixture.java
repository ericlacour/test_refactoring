package com.inventaire;

public class TexttestFixture {
    public static void main(String[] args) {
        System.out.println("OMGHAI!");

        Item[] items = new Item[] {
                new Item("Veste en laine", 10, 20), //
                new Item("Vin rouge", 2, 0), //
                new Item("Pot de confiture", 5, 7), //
                new Item("Lingot d'or", 0, 80), //
                new Item("Lingot d'or", -1, 80),
                new Item("Billet de festival", 15, 20),
                new Item("Billet de festival", 10, 49),
                new Item("Billet de festival", 5, 49),
                // this "Article fragile" item does not work properly yet
                new Item("Article fragile Vase en verre", 3, 6) };

        Inventaire app = new Inventaire(items);

        int days = 2;
        if (args.length > 0) {
            days = Integer.parseInt(args[0]) + 1;
        }

        for (int i = 0; i < days; i++) {
            System.out.println("-------- day " + i + " --------");
            System.out.println("name, sellIn, quality");
            for (Item item : items) {
                System.out.println(item);
            }
            System.out.println();
            app.updateQuality();
        }
    }

}
