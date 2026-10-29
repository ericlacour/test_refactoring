/*
 * Copyright (c) 2015 @emilybache
 * SPDX-License-Identifier: MIT
 * Voir le fichier LICENSE a la racine du depot.
 */
package com.inventaire;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class InventaireTest {

    @Test
    void foo() {
        Item[] items = new Item[] { new Item("foo", 0, 0) };
        Inventaire app = new Inventaire(items);
        app.updateQuality();
        assertEquals("fixme", app.items[0].name);
    }

}
