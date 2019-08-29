package org.lared.desinventar.sendai;

import java.sql.Connection;
import java.util.HashMap;

class item_generic
        extends item_abstract {

    item_generic(Connection con, item_abstract item) {
        super(item);

        //reset map
        setValues(new HashMap<Integer, Double>());


        fillValues(con);
        fillGlobalValues();
    }
}
