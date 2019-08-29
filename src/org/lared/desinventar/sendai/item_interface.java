package org.lared.desinventar.sendai;

import java.util.HashMap;

/**
 * item_interface
 */
public interface item_interface {

    long getId();
    String getCountry();

    double getDamagePercentage();
    double getImpactFactor();
    String getIndicator();
    double getAverageSize();

    double getItemValue(int Year);
    HashMap<Integer, Double> getItemValues();
    boolean hasValues();

}