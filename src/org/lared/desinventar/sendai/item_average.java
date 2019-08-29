package org.lared.desinventar.sendai;

import org.lared.desinventar.util.dbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;

class item_average
        extends item_abstract {

    item_average(Connection con, item_abstract item, long fallback) {
        super(item);
        setFallback(fallback);

        setValues(new HashMap<Integer, Double>());


        fillValues(con);
        fillGlobalValues();

        //fallback values
        if (fallback>-1 && fallback!=getId()) fillValues(con, fallback);
        if (fallback>-1 && fallback!=getId()) fillGlobalValues(fallback);

        //average values, only for known ids (master ids)
        worldAverage();
        if (fallback>-1 && fallback!=getId()) worldAverage(fallback);
    }

    @Override
    double getEquipmentFactor() {
        return 0;
    }

/*
    @Override
    void retrieveValues() {
        //try to get values from table for the specific id
        // avoid the fallback in the first step
        fillGlobalValues(this.getId());
        //try to get values from world average
        if (! hasValues())
            worldAverage();

        long fallback = getFallback();
        if (! hasValues() && fallback>-1) {
            //try to get values from fallback item
            fillGlobalValues(fallback);
            //try to get the values from the World AVG of fallback
            if (! hasValues())
                worldAverage(fallback);
        }
    }
*/

    private void worldAverage() {
        worldAverage(getId());
    }
    private void worldAverage(long id) {
        //ONLY VALID FOR THE INITIAL_METADATA !!!
        // after that ID is not possible to relate items from different countries.
        if (id > 496)
            return;

        HashMap<Integer, Double> hm = getItemValues();

        dbConnection dbcDatabase = null;
        Connection m_connection = null;

        String sSql;
        PreparedStatement stmt = null;
        ResultSet rset = null;

        try {
            dbcDatabase = new dbConnection();
            if (dbcDatabase.dbGetConnectionStatus()) {
                m_connection = dbcDatabase.dbGetConnection();

                try {
                    sSql = "SELECT metadata_element_year, avg(metadata_element_unit_cost_us) FROM metadata_element_costs " +
                            "WHERE (metadata_element_key=?) AND (NOT metadata_country='@@@') " +
                            "GROUP BY metadata_element_year ORDER BY metadata_element_year";
                    stmt = m_connection.prepareStatement (sSql);
                    stmt.setLong(1, id);
                    rset = stmt.executeQuery();

                    while (rset.next()) {
                        int year = rset.getInt("metadata_element_year");
                        double value = rset.getDouble(2);

                        //priority to existing values
                        if (! hm.containsKey(year) && value>0)
                            hm.put(year,value);
                    }

                    setValues(hm);
                } catch (Exception e) {
                    //return e.getMessage();
                } finally {
                    util.closeResultSet(rset);
                    util.closeStatement(stmt);
                }
            }
        } catch (Exception e) {
            //return e.getMessage();
        } finally {
            if (dbcDatabase!=null)
                dbcDatabase.close();
        }
    }

}
