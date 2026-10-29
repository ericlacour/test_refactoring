/*
 * Copyright (c) 2015 @emilybache
 * SPDX-License-Identifier: MIT
 * Voir le fichier LICENSE a la racine du depot.
 */
package com.inventaire;

public class Item {

    public String name;

    public int sellIn;

    public int quality;

    public Item(String name, int sellIn, int quality) {
        this.name = name;
        this.sellIn = sellIn;
        this.quality = quality;
    }

   @Override
   public String toString() {
        return this.name + ", " + this.sellIn + ", " + this.quality;
    }
}
