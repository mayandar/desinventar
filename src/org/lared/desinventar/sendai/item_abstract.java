package org.lared.desinventar.sendai;

import org.lared.desinventar.util.dbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;

class item_abstract
        implements item_interface {

    private long id = -1;
    private long fallback_id = -1;

    private String sCountry = null;

    private double damage;
    private double equipment;
    private double infrastructure;

    private double avgSize;
    private String indicator = null;

    private HashMap<Integer, Double> values = new HashMap<Integer, Double>();

    public item_abstract(Connection con, String sCountry, long id) {

        String sCountryQuery = "@@@";

        if (testId(con, sCountry, id)) { //Check if item has been defined/edited for country
            sCountryQuery = sCountry;
        } else if (!testId(con, sCountryQuery, id)) { //Check if item exist on default list
            return; //doesn't exists, get out
        }

        //System.out.println(String.format("[CAV] Item found %s %d", sCountryQuery, id));

        this.id = id;
        this.sCountry = sCountry;

        String sSql;
        PreparedStatement stmt = null;
        ResultSet rset = null;

        try {
            try {

                sSql = "SELECT * FROM metadata_element " +
                        "WHERE metadata_element_key=? AND metadata_country=?";
                stmt = con.prepareStatement (sSql);
                stmt.setLong(1, id);
                stmt.setString(2, sCountryQuery);
                rset = stmt.executeQuery();

                if (rset.next())
                {

                    damage = rset.getDouble("metadata_element_damage_r");
                    equipment = rset.getDouble("metadata_element_equipment");
                    infrastructure = rset.getDouble("metadata_element_infrastr");
                    avgSize = rset.getDouble("metadata_element_average_size");

                    if (equipment>1)
                        equipment*=0.01;
                    if (equipment<0)
                        equipment=0;

                    if (infrastructure>1)
                        infrastructure*=0.01;
                    if (infrastructure<0)
                        infrastructure=0;

                    //metadata_element_unit
                    //metadata_element_measurement
                }

                sSql = "SELECT INDICATOR_CODE FROM metadata_element_indicator AS e " +
                        "INNER JOIN metadata_indicator AS i " +
                        "ON i.INDICATOR_KEY=e.INDICATOR_KEY " +
                        "WHERE METADATA_ELEMENT_KEY=?";

                stmt = con.prepareStatement (sSql);
                stmt.setLong(1, id);
                rset = stmt.executeQuery();
                if (rset.next()) {
                    indicator = rset.getString(1);
                }

                //Get local values
                //fillValues(con);
                //Get global values
                //fillGlobalValues();

            } catch (Exception e) {
                System.out.println(e.getMessage());
            } finally {
                util.closeResultSet(rset);
                util.closeStatement(stmt);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    item_abstract(item_abstract gen) {
        if (gen.id==-1)
            return;

        this.id = gen.id;
        this.sCountry = gen.sCountry;

        this.damage = gen.damage;
        this.equipment = gen.equipment;
        this.infrastructure = gen.infrastructure;

        this.avgSize = gen.avgSize;
        this.indicator = gen.indicator;

        if (! (gen.values == null || gen.values.isEmpty()))
            this.values = gen.values;

        this.fallback_id = gen.getFallback();
    }

    private boolean testId(Connection con, String sCountry, long id) {

        String sSql;
        PreparedStatement stmt = null;
        ResultSet rset = null;

        try {
            try {
                sSql = "SELECT * FROM metadata_element AS e " +
                        "INNER JOIN metadata_element_indicator AS i " +
                        "ON e.metadata_element_key=i.metadata_element_key " +
                        "AND e.metadata_country=i.metadata_country " +
                        "WHERE e.metadata_element_key=? AND e.metadata_country=?";

                stmt = con.prepareStatement (sSql);
                stmt.setLong(1, id);
                stmt.setString(2, sCountry);
                rset = stmt.executeQuery();

                if (rset.next()) {
                    return true;
                }

            } catch (Exception e) {
                //return e.getMessage();
            } finally {
                util.closeResultSet(rset);
                util.closeStatement(stmt);
            }
        } catch (Exception e) {
            //return e.getMessage();
        }
        return false;
    }

    double getInfastructureFactor() {
        return infrastructure;
    }

    double getEquipmentFactor() {
        return equipment;
    }

    @Override
    public long getId() {
        return id;
    }

    @Override
    public String getCountry() {
        return sCountry;
    }

    @Override
    public double getDamagePercentage() {
        return damage;
    }

    @Override
    public double getImpactFactor() {
        return 1+getInfastructureFactor()+getEquipmentFactor();
    }

    @Override
    public String getIndicator() {
        return indicator;
    }

    @Override
    public double getAverageSize() {
        return avgSize;
    }

    void fillValues(Connection con) {
        fillValues(con, getId());
    }
    void fillValues(Connection con, long id) {

        String sSql;
        PreparedStatement stmt = null;
        ResultSet rset = null;

        try {
            try {

                sSql = "SELECT * FROM metadata_element_costs " +
                        "WHERE metadata_element_key=? AND metadata_country=? " +
                        "ORDER BY metadata_element_year";

                stmt = con.prepareStatement (sSql);
                stmt.setLong(1, id);
                stmt.setString(2, this.sCountry);
                rset = stmt.executeQuery();

                while (rset.next())
                {
                    int year = rset.getInt("metadata_element_year");
                    double value = rset.getDouble("metadata_element_unit_cost_us");

                    //System.out.println(String.format("[CAV] %d : %f", year, value));

                    //priority to existing values
                    if (! values.containsKey(year) && value>0)
                        values.put(year,value);
                }

            } catch (Exception e) {
                System.out.println(e.getMessage());
            } finally {
                util.closeResultSet(rset);
                util.closeStatement(stmt);
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    void fillGlobalValues() {
        fillGlobalValues(getId());
    }
    void fillGlobalValues(Long id) {
        dbConnection dbcDatabase = null;
        Connection m_connection = null;

        try {
            dbcDatabase = new dbConnection();
            if (dbcDatabase.dbGetConnectionStatus()) {
                m_connection = dbcDatabase.dbGetConnection();
                fillValues(m_connection, id);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            if (dbcDatabase!=null)
                dbcDatabase.close();
        }
    }

/*
    void retrieveValues() {
        fillGlobalValues(this.id);

        long fallback = getFallback();
        if (! hasValues() && fallback>-1)
            fillGlobalValues(fallback);
    }
*/

    @Override
    public double getItemValue(int Year) {
        //if (values == null) retrieveValues();
        if (values.isEmpty() || !values.containsKey(Year)) 
        {
        	Year=Year<2005?2005:Year>2018?2018:Year; 
    	    if (values.isEmpty() || !values.containsKey(Year)) 
        		return -1;
        }
        return values.get(Year);
    }
    @Override
    public HashMap<Integer, Double> getItemValues() {
        // if (values==null) retrieveValues();
        return values;
    }
    void setValues(HashMap<Integer, Double> hm) {
        if (hm!=null)
            values = hm;
    }
    @Override
    public boolean hasValues() {
        //return !(values==null || values.isEmpty());
        return !(getItemValues().isEmpty());
    }

    void setFallback(long fallback) {
        fallback_id = fallback;
    }
    long getFallback() {
        return fallback_id;
    }

}