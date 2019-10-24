package org.lared.desinventar.sendai;

import org.lared.desinventar.util.DICountry;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class economic_loss {

    public void calculate_economic_loss(Connection con, String sCountryCodes) 
    {

        //NOTE: Fix the no Country metadata_element
        System.out.println("[DI9] Remove @@@ - sendai.item_abstract");

        //get list of custom fields
        ArrayList<Long> ids = getDictionaryIds(con);

        //Get list of countries
        ArrayList<String> countries = getLevel0(con,sCountryCodes);
        
        for (String country: countries) {
            System.out.println(country);
            //-----------------------------------------------------------------
            //process default items

            //DesInventar: Cultivos
            process(con, item_factory.getItem(con, country, 2), "LOSS_CROPS", "nhectareas", "HA_DMGD", "HA_DSTR");
            //Desinventar: Ganado
            process(con, item_factory.getItem(con, country, 174), "LOSS_LIVESTOCK_TOTAL", "LIVESTOCK_TOTAL", "LIVESTOCK_DMGD", "cabezas");
            //DesInventar: Viviendas
            item_interface itm = item_factory.getItem(con, country, 351);
            process(con, itm, "LOSS_DWELLINGS_DMGD", null, "vivafec", null);
            process(con, itm, "LOSS__DWELLINGSDSTR", null, null, "vivdest");
            process(con, itm, "LOSS_DWELLINGS", "HOUSES_TOTAL", "vivafec", "vivdest");

            //DesInventar: roads
            //Kmvias
            process(con, item_factory.getItem(con, country, 357), "LOSS_357", "Kmvias", "DAMAGED_357", "DESTRYD_357");

            //DesInventar : Centros de salud
            process(con, item_factory.getItem(con, country, 432), "LOSS_HEALTH_FACILITIES", "nhospitales", "HEALTH_FACILITIES_DMGD", "HEALTH_FACILITIES_DSTR");
            //DesInventar: Escuelas
            process(con, item_factory.getItem(con, country, 434), "LOSS_EDUCATION", "nescuelas", "EDUCATION_DMGD", "EDUCATION_DSTR");

            //Agricultural assets
            process(con, item_factory.getItem(con, country, 212), "AGRI_ASSETS_LOSS_AFCTD", "AGRI_ASSETS_AFCTD", "AGRI_ASSETS_DMGD", "AGRI_ASSETS_DSTR");
            //Agricultural stock
            process(con, item_factory.getItem(con, country, 214), "STOCK_LOSS_AFCTD", "STOCK_FACILITIES_AFCTD", "STOCK_FACILITIES_DMGD", "STOCK_FACILITIES_DSTR");
            //Fisheries
            process(con, item_factory.getItem(con, country, 204), "LOSS_VESSELS_TOTAL", "VESSELS_TOTAL", "VESSELS_DMGD", "VESSELS_DSTR");
            //Aquaculture
            process(con, item_factory.getItem(con, country, 208), "LOSS_AQUACULTURE_TOTAL", "HA_AQUACULTURE_TOTAL", "HA_AQUACULTURE_DMGD", "HA_AQUACULTURE_DSTR");

            //Other : ???
            //LOSS_FOREST_TOTAL/HA_FOREST_TOTAL/HA_FOREST_DMGD/HA_FOREST_DSTR
            //PRODUCTIVE_ASSETS_LOSS_AFCTD/PRODUCTIVE_ASSETS_AFCTD/PRODUCTIVE_ASSETS_DMGD/PRODUCTIVE_ASSETS_DSTR
            //LOSS_INFRASTRUCTURES/NUMBER_INFRASTRUCTURES, NUMBER_DMGD_INFRASTRUCTURES, NUMBER_DSTR_INFRASTRUCTURES

            //-----------------------------------------------------------------
            //TODO: Add variables to get the individual value of FAO items and then test against the generic.
            for (long id: ids) {
                process(con, item_factory.getItem(con, country, id), "LOSS_"+id, "TOTAL_"+id, "DAMAGED_"+id, "DESTRYD_"+id);
            }
        }

        System.out.println("[DI9] Finished processing losses");
    }

    public void calculate_temp_economic_loss(Connection con, String sCountryCodes) 
    {

        //NOTE: Fix the no Country metadata_element
        System.out.println("[DI9] Remove @@@ - sendai.item_abstract");

        //get list of custom fields
        ArrayList<Long> ids = getDictionaryIds(con);
        System.out.println("[DI9] Got field list");

        //Get list of countries
        ArrayList<String> countries = getLevel0(con, sCountryCodes);
        System.out.println("[DI9] Got country list");
        
        // cleans up previous temporary loss assessments
        Statement stmt = null;
        try {
        	
            stmt = con.createStatement();
            int nrecs=stmt.executeUpdate("update extension set T_LOSS_CROPS=0,T_LOSS_LIVESTOCK=0," +
            		" ECONOMIC_LOSS_C4DM=0, ECONOMIC_LOSS_C4DY=0, ECONOMIC_LOSS_C4=0, T_LOSS_357=0," +
            		"ECONOMIC_LOSS_HEALTH=0, ECONOMIC_LOSS_EDU=0, T_LOSS_AGRI_ASSETS=0, " +
            		"T_LOSS_STOCK=0, T_LOSS_VESSELS=0, T_LOSS_AQUACULTURE=0"
            		);
            
        } catch (Exception ignored) {

        } finally {
            util.closeStatement(stmt);
        }
        System.out.println("[DI9] cleared previous assessments ");


        for (String country: countries) {
            System.out.println("[DI9] Starting assessment... "+country);
            //-----------------------------------------------------------------
            //process default items

            //DesInventar: Cultivos
            process(con, item_factory.getItem(con, country, 2), "T_LOSS_CROPS", "nhectareas", "HA_DMGD", "HA_DSTR");
            //System.out.println("[DI9] Crops OK ");
            //Desinventar: Ganado
            process(con, item_factory.getItem(con, country, 174), "T_LOSS_LIVESTOCK", "LIVESTOCK_TOTAL", "LIVESTOCK_DMGD", "cabezas");
            //System.out.println("[DI9] Livestock OK ");
            //DesInventar: Viviendas
            item_interface itm = item_factory.getItem(con, country, 351);
            //System.out.println("[DI9] Housing item 351 OK ");
            
            process(con, itm, "ECONOMIC_LOSS_C4DM", null, "vivafec", null);
            process(con, itm, "ECONOMIC_LOSS_C4DY", null, null, "vivdest");
            process(con, itm, "ECONOMIC_LOSS_C4", "HOUSES_TOTAL", "vivafec", "vivdest");
            //System.out.println("[DI9] Housing assessment 351 OK ");

            //DesInventar: roads
            //Kmvias
            process(con, item_factory.getItem(con, country, 357), "T_LOSS_357", "Kmvias", "DAMAGED_357", "DESTRYD_357");
            // System.out.println("[DI9] Roads 357 OK ");

            //DesInventar : Centros de salud
            process(con, item_factory.getItem(con, country, 432), "ECONOMIC_LOSS_HEALTH", "nhospitales", "HEALTH_FACILITIES_DMGD", "HEALTH_FACILITIES_DSTR");
            // System.out.println("[DI9] Health OK ");
            //DesInventar: Escuelas
            process(con, item_factory.getItem(con, country, 434), "ECONOMIC_LOSS_EDU", "nescuelas", "EDUCATION_DMGD", "EDUCATION_DSTR");
            // System.out.println("[DI9] Education OK ");

            //Agricultural assets
            process(con, item_factory.getItem(con, country, 212), "T_LOSS_AGRI_ASSETS", "AGRI_ASSETS_AFCTD", "AGRI_ASSETS_DMGD", "AGRI_ASSETS_DSTR");
            // System.out.println("[DI9] Agricultural assets OK ");
            //Agricultural stock
            process(con, item_factory.getItem(con, country, 214), "T_LOSS_STOCK", "STOCK_FACILITIES_AFCTD", "STOCK_FACILITIES_DMGD", "STOCK_FACILITIES_DSTR");
            // System.out.println("[DI9] Agricultural Stock OK ");
            //Fisheries
            process(con, item_factory.getItem(con, country, 204), "T_LOSS_VESSELS", "VESSELS_TOTAL", "VESSELS_DMGD", "VESSELS_DSTR");
            // System.out.println("[DI9] Fisheries OK ");
            //Aquaculture
            process(con, item_factory.getItem(con, country, 208), "T_LOSS_AQUACULTURE", "HA_AQUACULTURE_TOTAL", "HA_AQUACULTURE_DMGD", "HA_AQUACULTURE_DSTR");
            // System.out.println("[DI9] Aquaculture OK ");

            //Other : ???
            //LOSS_FOREST_TOTAL/HA_FOREST_TOTAL/HA_FOREST_DMGD/HA_FOREST_DSTR
            //PRODUCTIVE_ASSETS_LOSS_AFCTD/PRODUCTIVE_ASSETS_AFCTD/PRODUCTIVE_ASSETS_DMGD/PRODUCTIVE_ASSETS_DSTR
            //LOSS_INFRASTRUCTURES/NUMBER_INFRASTRUCTURES, NUMBER_DMGD_INFRASTRUCTURES, NUMBER_DSTR_INFRASTRUCTURES

            //-----------------------------------------------------------------
            //TODO: Add variables to get the individual value of FAO items and then test against the generic.
            for (long id: ids) 
            {
                try{
                	process(con, item_factory.getItem(con, country, id), "T_LOSS_"+id, "TOTAL_"+id, "DAMAGED_"+id, "DESTRYD_"+id);
                    // System.out.println("[DI9] disaggregated item "+id+" OK ");	
                }
                catch (Exception e)
                {
                    System.out.println("[DI9] ERROR processing disaggregated item "+id+" OK ");
                	
                }
            }
        }

        System.out.println("[DI9] Finished processing losses");
    }

    private ArrayList<String> getLevel0(Connection con, String sCountryCodes) {
        ArrayList<String> al = new ArrayList<String>();

        Statement stmt = null;
        ResultSet rset = null;

        try {
            stmt = con.createStatement();
            rset = stmt.executeQuery("SELECT level0 FROM fichas WHERE (level0 IS NOT NULL)"+(sCountryCodes==null?"":"and level0 in ("+sCountryCodes+")")+" GROUP BY level0 ORDER BY level0");
            while (rset.next()){
                String str = rset.getString("level0");
                if (! util.isNullOrEmpty(str))
                    al.add(str);
            }
        } catch (Exception ignored) {

        } finally {
            util.closeResultSet(rset);
            util.closeStatement(stmt);
        }

        return al;
    }

    private ArrayList<Long> getDictionaryIds(Connection con) {
        ArrayList<Long> al = new ArrayList<Long>();

        Statement stmt = null;
        ResultSet rset = null;

        try {
            stmt = con.createStatement();
            rset = stmt.executeQuery("SELECT * FROM DICTIONARY WHERE field_name LIKE 'TOTAL_%'");
            /*
            For the cases where the id doesn't exists for a particular country, the query in process
            only takes records where Total>0 OR Dmgd>0 OR DSTR>0
             */
            while (rset.next()){
                String str = rset.getString("FIELD_NAME").substring(6);
                try {
                    Long id = Long.parseLong(str);
                    al.add(id);
                } catch (Exception ignored) {}
            }
        } catch (Exception ignored) {

        } finally {
            util.closeResultSet(rset);
            util.closeStatement(stmt);
        }

        return al;
    }

    private void process(Connection con, item_interface item, String sLoss, String sTotal, String sDamaged, String sDestroyed) {

        //item doesn't exist on the metadata_element table
        if (item.getId()==-1 || ! item.hasValues()) {
            System.out.println(String.format("[Sendai EL] Invalid item (%d) for Country [%s]", item.getId(), item.getCountry()));
            return;
        }

        //Is there a field where to write the calculated loss?
        if (util.isNullOrEmpty(sLoss))
            return;

        //Is there any impact field available?
        if (util.isNullOrEmpty(sTotal) && util.isNullOrEmpty(sDamaged) && util.isNullOrEmpty(sDestroyed))
            return;

        String sSql;
        PreparedStatement stmt = null;
        ResultSet rset = null;

        String sSql2;
        PreparedStatement stmt2 = null;

        long clave;
        boolean bTotal = util.isNullOrEmpty(sTotal);
        boolean bDamgd = util.isNullOrEmpty(sDamaged);
        boolean bDstry = util.isNullOrEmpty(sDestroyed);

        String filter = "";
        if (!bTotal) filter += String.format("%s>0", sTotal);
        if (!bDamgd) {
            if (!filter.isEmpty()) filter += " OR ";
            filter += String.format("%s>0", sDamaged);
        }
        if (!bDstry) {
            if (!filter.isEmpty()) filter += " OR ";
            filter += String.format("%s>0", sDestroyed);
        }
        if (!filter.isEmpty())
            filter = String.format("AND (%s)", filter);

        try {
            sSql = String.format(
                    "SELECT * FROM fichas AS f INNER JOIN extension AS e " +
                            "ON f.clave=e.clave_ext " +
                            "WHERE (f.level0=?)" +  // AND (f.fechano>=2005) " +
                            " AND (%1$s=0 OR %1$s IS NULL) %2$s"
                    , sLoss, filter);

            stmt = con.prepareStatement(sSql);
            stmt.setString(1, item.getCountry());
            rset = stmt.executeQuery();

            while (rset.next()) {
                clave = rset.getLong("clave");

                if (rset.getDouble(sLoss)==0) {

                    double dTotal = 0;
                    double dDamaged = 0;
                    double dDestryd = 0;

                    if (!bTotal) dTotal = rset.getDouble(sTotal);
                    if (!bDamgd) dDamaged = rset.getDouble(sDamaged);
                    if (!bDstry) dDestryd = rset.getDouble(sDestroyed);

                    double dLoss = getLoss(
                            dTotal,
                            dDamaged,
                            dDestryd,
                            rset.getInt("fechano"),
                            item
                    );

                    if (dLoss>0) {
                        try {
                            sSql2 = "UPDATE extension SET " + sLoss + "=? WHERE clave_ext=?";
                            stmt2 = con.prepareStatement(sSql2);
                            stmt2.setDouble(1, dLoss);
                            stmt2.setLong(2, clave);
                            stmt2.executeUpdate();
                        } catch (Exception e) {
                            System.out.println(e.getMessage());
                        } finally {
                            util.closeStatement(stmt2);
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            util.closeResultSet(rset);
            util.closeStatement(stmt);
        }

    }

    private double getLoss(double total, double damaged, double destroyed, int Year, item_interface item) {
        if (total==0 && damaged==0 && destroyed==0)
            return 0;

        double f = item.getImpactFactor();
        double p = item.getDamagePercentage();
        double v = item.getItemValue(Year);

        if (v<0)
            return 0;

        double dm = 0;
        double dt = 0;

        if (total==(damaged+destroyed)) {
            dm = damaged;
            dt = destroyed;
        } else if (total==0 && damaged+destroyed>0) {
            dm = damaged;
            dt = destroyed;
        } else if (total>0 && damaged+destroyed==0) {
            dm = 0.8 * total;
            dt = total - dm;
        } else if (total>damaged && destroyed==0) {
            dm = damaged;
            dt = total-damaged;
        } else if (total>destroyed && damaged==0) {
            dm=total-destroyed;
            dt=destroyed;
        } else if (total>damaged+destroyed) {
            dm = total - destroyed;
            dt = destroyed;
        } else if (total < damaged+destroyed) {
            dm = damaged * total/(damaged+destroyed);
            dt = destroyed * total/(damaged+destroyed);
        }

        return dm*f*v*p + dt*f*v;
    }



//TEST functions - TODO:REMOVE
    public String listValues(Connection con, String sCountry, int id) {
        item_interface item = item_factory.getItem(con, sCountry, id);

        HashMap<Integer, Double> hm = item.getItemValues();

        if (hm==null || hm.isEmpty())
            return "Null OR Empty";

        String str = "";
        for (int i: hm.keySet()) {
            str += i + "=" + hm.get(i) + "</br>";
        }

        return str;
    }

    public String getItemDesc(Connection con, String sCountry, int id) {
        item_interface item = item_factory.getItem(con, sCountry, id);

        if (item==null)
            return "no item";

        String str = "";
        str += "id: " + item.getId() + "</br>";
        str += "dm: " + item.getDamagePercentage() + "</br>";
        str += "fc: " + item.getImpactFactor() + "</br>";
        str += "Sz: " + item.getAverageSize() + "</br>";


        item_abstract g = new item_abstract(con, sCountry, id);

        str += ": " + g.getImpactFactor() + "</br>";

        return str;
    }

    public String getCount(Connection con, DICountry countrybean) {
        String sSql = "SELECT COUNT(*) FROM fichas";

        Statement stmt = null;
        ResultSet rset = null;

        try {
            stmt=con.createStatement();
            rset=stmt.executeQuery(sSql);
            if (rset.next()) {
                return rset.getString(1);
            }
        } catch (Exception ignored) {

        } finally {
            util.closeResultSet(rset);
            util.closeStatement(stmt);
        }

        return "NO OK";
    }

}
