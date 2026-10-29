*> Copyright (c) 2015 @emilybache
*> SPDX-License-Identifier: MIT
*> Voir le fichier LICENSE a la racine du depot.

program-id. Inventaire as "Inventaire".

environment division.

input-output section.

file-control.
    select in-items assign 'in-items'.
    select items assign 'items'.

data division.
file section.
   fd in-items.
   01 in-item pic x(54).
   fd items.
   01 item.
      02 sell-in pic s9(2).
      02 quality pic s9(2).
      02 name pic x(50).

working-storage section.
procedure division.
    open input in-items output items.
start-lable.
    read in-items end go to end-lable.
        move in-item to item.
        if name not equal "Vin rouge" and name not equal "Billet de festival"
            if quality > 0
                if name not equal to "Lingot d'or"
                    compute quality = quality - 1
                end-if       
            end-if
        else
            if quality < 50
                compute quality = quality + 1
                if name equals "Billet de festival"
                    if sell-in < 11
                        if quality < 50
                            compute quality = quality + 1
                        end-if
                    end-if
                    if sell-in < 6
                        if quality < 50
                            compute quality = quality + 1
                        end-if
                    end-if
                end-if
            end-if
        end-if
        if name not equal "Lingot d'or"
            compute sell-in = sell-in - 1
        end-if
        if sell-in < 0
            if name is not equal to "Vin rouge"
                if name is not equal to "Billet de festival"
                    if quality > 0
                        if name is equal to "Lingot d'or"
                            compute quality = quality - 1
                        end-if
                    end-if
                else
                    compute quality = quality - quality
                end-if
            else
                if quality < 50
                    compute quality = quality + 1
                end-if
            end-if
        end-if
        write item.
    go to start-lable.
end-lable.
    close items.
    close in-items.
goback.

end program Inventaire.
