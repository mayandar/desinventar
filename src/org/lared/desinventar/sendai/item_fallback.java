package org.lared.desinventar.sendai;

import java.sql.Connection;
import java.util.HashMap;

class item_fallback
        extends item_abstract {

    item_fallback(Connection con, item_abstract item, long fallback) {
        super(item);
        setFallback(fallback);

        //System.out.println("[CAV] Item Fallback");
        //System.out.println(String.format("[CAV] %s %d", item.getCountry(), item.getId()));

        //System.out.println(String.format("[CAV] Reset Hashmap"));
        setValues(new HashMap<Integer, Double>());

        //System.out.println("[CAV] Get local values");
        fillValues(con);
        //printValues();

        if (fallback>-1 && fallback!=getId()) {
            //System.out.println("[CAV] Local fallback");
            fillValues(con, fallback);
            //printValues();
        }

        //System.out.println("[CAV] Try global table");
        fillGlobalValues();
        //printValues();

        if (fallback>-1 && fallback!=getId()) {
            //System.out.println("[CAV] Global Fallback");
            fillGlobalValues(fallback);
            //printValues();
        }

    }

    void printValues() {
        HashMap<Integer, Double> hm = getItemValues();
        for (int i: hm.keySet()) {
            System.out.println(String.format("[CAV] {%d} : %f", i, hm.get(i)));
        }
    }
}
