program-id. Inventaire as "Inventaire".

file-control.
    select in-items assign 'in-items'.
    select items assign 'items'.

data division.
file section.
   fd in-items.
   01 in-item pic x(58).
   fd items.
   01 item.
      02 sell-in pic 9(4).
      02 quality pic 9(4).
      02 name pic x(50).

working-storage section.
procedure division.
    open input in-items output items.
start-lable.
    read in-items end go to end-lable.
        move in-item to item.
        if name not equal "Vin rouge" and name not equal "Billet de festival"
            if quality greater then 0
                if name not equal to "Lingot d'or"
                    compute quality = quality - 1
                end-if       
            end-if
        else
            if quality is less then 50
                compute quality = quality + 1
                if name equals "Billet de festival"
                    if sell-in less then 11
                        if quality less then 50
                            compute quality = quality + 1
                        end-if
                    end-if
                    if sell-in less then 6
                        if quality  less then 50
                            compute quality = quality + 1
                        end-if
                    end-if
                end-if
            end-if
        end-if
        if name not equal "Lingot d'or"
            compute sell-in = sell-in - 1
        end-if
        if sell-in is less then 0
            if name is not equal to "Vin rouge"
                if name is not equal to "Billet de festival"
                    if quality is greater then 0
                        if name is equal to "Lingot d'or"
                            compute quality = quality - 1
                        end-if
                    end-if
                else
                    compute quality = quality - quality
                end-if
            else
                if quality is less then 50
                    compute quality = quality + 1
                end-if
            end-if
        end-if
        write item.
    go to start-lable.
end-lable.
    close items.
goback.

end program Inventaire.
