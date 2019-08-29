package org.lared.desinventar.sendai;

import java.sql.Connection;

public class item_factory {

    /*
    * 1	C-2C	Agricultural Crops
    * 2	C-2L	Livestock
    3	C-2FO	Forestry
    * 4	C-2FI	Fisheries
    * 5	C-2A	Aquaculture
    * 6	C-2LA	Agricultural Assets
    * 7	C-2LB	Agricultural Stock
    8	C-3	    Productive Assets
    9	C-5	    Critical Infrastructure
    * 10	D-2	    Health Facilities
    * 11	D-3	    Education Facilities
    * 12	C-4	    Housing Sector
    13	D-4	    Basic Services
     */

    public static item_interface getItem(Connection con, String sCountry, long id) {
        item_abstract item = new item_abstract(con, sCountry, id);


        if (item.getIndicator().equalsIgnoreCase("C-2C"))
            return new item_average(con, item,2);
        if (item.getIndicator().equalsIgnoreCase("C-2L"))
            return new item_average(con, item, 174);

        if (item.getIndicator().equalsIgnoreCase("C-4"))
            return new item_fallback(con, item, 351);
        if (item.getIndicator().equalsIgnoreCase("D-2"))
            return new item_fallback(con, item, 432);
        if (item.getIndicator().equalsIgnoreCase("D-3"))
            return new item_fallback(con, item, 434);

        if (item.getIndicator().equalsIgnoreCase("C-2LA"))
            return new item_fallback(con, item, 212);
        if (item.getIndicator().equalsIgnoreCase("C-2LB"))
            return new item_fallback(con, item, 214);
        if (item.getIndicator().equalsIgnoreCase("C-2FI"))
            return new item_fallback(con, item, 204);
        if (item.getIndicator().equalsIgnoreCase("C-2A"))
            return new item_fallback(con, item, 208);

        //C-2FO
        //C-3
        //C-5
        //D-4

        return new item_generic(con, item);
    }
}
