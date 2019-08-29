package org.lared.desinventar.util;

import java.net.URL;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.HashMap;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.StringTokenizer;

import javax.imageio.ImageIO;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.*;
import java.text.NumberFormat;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFName;

import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.Picture;


import org.lared.desinventar.webobject.*;
import org.lared.desinventar.system.Sys;

import com.itextpdf.text.Image;

public class GAR_country_profile_excel 

{
	static String[] iso=new String[216];
	static String[] country =new String[216];
	static String[] url=new String[216];



	ResultSet rset=null;
	Statement stmt=null;

	boolean isDesInventar=false;


	public static void getMaps()
	{

		iso[0]="ABW";	country[0]="Aruba";	url[0]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/abw_ocha_500px.png";
		iso[1]="AFG";	country[1]="Afghanistan";	url[1]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/afg_ocha_500px.png";
		iso[2]="AGO";	country[2]="Angola";	url[2]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ago_ocha_500px.png";
		iso[3]="AIA";	country[3]="Anguilla";	url[3]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/aia_ocha_500px.png";
		iso[4]="ALB";	country[4]="Albania";	url[4]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/alb_ocha_500px.png";
		iso[5]="AND";	country[5]="Andorra";	url[5]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/and_ocha_500px.png";
		iso[6]="ARE";	country[6]="United Arab Emirates";	url[6]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/are_ocha_500px.png";
		iso[7]="ARG";	country[7]="Argentina";	url[7]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/arg_ocha_500px.png";
		iso[8]="ARM";	country[8]="Armenia";	url[8]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/arm_ocha_500px.png";
		iso[9]="ATG";	country[9]="Antigua and Barbuda";	url[9]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/atg_ocha_500px.png";
		iso[10]="AUS";	country[10]="Australia";	url[10]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/aus_ocha_500px.png";
		iso[11]="AUT";	country[11]="Austria";	url[11]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/aut_ocha_500px.png";
		iso[12]="AZE";	country[12]="Azerbaijan";	url[12]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/aze_ocha_500px.png";
		iso[13]="BDI";	country[13]="Burundi";	url[13]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bdi_ocha_500px.png";
		iso[14]="BEL";	country[14]="Belgium";	url[14]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bel_ocha_500px.png";
		iso[15]="BEN";	country[15]="Benin";	url[15]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ben_ocha_500px.png";
		iso[16]="BFA";	country[16]="Burkina Faso";	url[16]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bfa_ocha_500px.png";
		iso[17]="BGD";	country[17]="Bangladesh";	url[17]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bgd_ocha_500px.png";
		iso[18]="BGR";	country[18]="Bulgaria";	url[18]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bgr_ocha_500px.png";
		iso[19]="BHR";	country[19]="Bahrain";	url[19]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bhr_ocha_500px.png";
		iso[20]="BHS";	country[20]="Bahamas";	url[20]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bhs_ocha_500px.png";
		iso[21]="BIH";	country[21]="Bosnia and Herzegovina";	url[21]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bih_ocha_500px.png";
		iso[22]="BLR";	country[22]="Belarus";	url[22]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/blr_ocha_500px.png";
		iso[23]="BLZ";	country[23]="Belize";	url[23]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/blz_ocha_500px.png";
		iso[24]="BMU";	country[24]="Bermuda";	url[24]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bmu_ocha_500px.png";
		iso[25]="BOL";	country[25]="Bolivia (Plurinational State of)";	url[25]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bol_ocha_500px.png";
		iso[26]="BRA";	country[26]="Brazil";	url[26]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bra_ocha_500px.png";
		iso[27]="BRB";	country[27]="Barbados";	url[27]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/brb_ocha_500px.png";
		iso[28]="BRN";	country[28]="Brunei Darussalam";	url[28]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/brn_ocha_500px.png";
		iso[29]="BTN";	country[29]="Bhutan";	url[29]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/btn_ocha_500px.png";
		iso[30]="BWA";	country[30]="Botswana";	url[30]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/bwa_ocha_500px.png";
		iso[31]="CAF";	country[31]="Central African Republic";	url[31]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/caf_ocha_500px.png";
		iso[32]="CAN";	country[32]="Canada";	url[32]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/can_ocha_500px.png";
		iso[33]="CHE";	country[33]="Switzerland";	url[33]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/che_ocha_500px.png";
		iso[34]="CHL";	country[34]="Chile";	url[34]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/chl_ocha_500px.png";
		iso[35]="CHN";	country[35]="China";	url[35]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/chn_ocha_500px.png";
		iso[36]="CIV";	country[36]="Cote d'Ivoire";	url[36]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/civ_ocha_500px.png";
		iso[37]="CMR";	country[37]="Cameroon";	url[37]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/cmr_ocha_500px.png";
		iso[38]="COG";	country[38]="Congo";	url[38]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/cog_ocha_500px.png";
		iso[39]="COL";	country[39]="Colombia";	url[39]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/col_ocha_500px.png";
		iso[40]="COM";	country[40]="Comoros";	url[40]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/com_ocha_500px.png";
		iso[41]="CPV";	country[41]="Cabo Verde";	url[41]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/cpv_ocha_500px.png";
		iso[42]="CRI";	country[42]="Costa Rica";	url[42]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/cri_ocha_500px.png";
		iso[43]="CUB";	country[43]="Cuba";	url[43]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/cub_ocha_500px.png";
		iso[44]="CYM";	country[44]="Cayman Islands";	url[44]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/cym_ocha_500px.png";
		iso[45]="CYP";	country[45]="Cyprus";	url[45]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/cyp_ocha_500px.png";
		iso[46]="CZE";	country[46]="Czech Republic";	url[46]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/cze_ocha_500px.png";
		iso[47]="DEU";	country[47]="Germany";	url[47]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/deu_ocha_500px.png";
		iso[48]="DJI";	country[48]="Djibouti";	url[48]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/dji_ocha_500px.png";
		iso[49]="DMA";	country[49]="Dominica";	url[49]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/dma_ocha_500px.png";
		iso[50]="DNK";	country[50]="Denmark";	url[50]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/dnk_ocha_500px.png";
		iso[51]="DOM";	country[51]="Dominican Republic";	url[51]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/dom_ocha_500px.png";
		iso[52]="DZA";	country[52]="Algeria";	url[52]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/dza_ocha_500px.png";
		iso[53]="ECU";	country[53]="Ecuador";	url[53]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ecu_ocha_500px.png";
		iso[54]="EGY";	country[54]="Egypt";	url[54]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/egy_ocha_500px.png";
		iso[55]="ERI";	country[55]="Eritrea";	url[55]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/eri_ocha_500px.png";
		iso[56]="ESH";	country[56]="Western Sahara";	url[56]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/esh_ocha_500px.png";
		iso[57]="ESP";	country[57]="Spain";	url[57]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/esp_ocha_500px.png";
		iso[58]="EST";	country[58]="Estonia";	url[58]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/est_ocha_500px.png";
		iso[59]="ETH";	country[59]="Ethiopia";	url[59]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/eth_ocha_500px.png";
		iso[60]="FIN";	country[60]="Finland";	url[60]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/fin_ocha_500px.png";
		iso[61]="FJI";	country[61]="Fiji";	url[61]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/fji_ocha_500px.png";
		iso[62]="FLK";	country[62]="Falkland Islands (Malvinas)";	url[62]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/flk_ocha_500px.png";
		iso[63]="FRA";	country[63]="France";	url[63]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/fra_ocha_500px.png";
		iso[64]="FRO";	country[64]="Faeroe Islands";	url[64]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/fro_ocha_500px.png";
		iso[65]="FSM";	country[65]="Micronesia (Federated States of)";	url[65]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/fsm_ocha_500px.png";
		iso[66]="GAB";	country[66]="Gabon";	url[66]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/gab_ocha_500px.png";
		iso[67]="GBR";	country[67]="United Kingdom of Great Britain and Northern Ireland";	url[67]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/gbr_ocha_500px.png";
		iso[68]="GEO";	country[68]="Georgia";	url[68]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/geo_ocha_500px.png";
		iso[69]="GHA";	country[69]="Ghana";	url[69]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/gha_ocha_500px.png";
		iso[70]="GIB";	country[70]="Gibraltar";	url[70]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/gib_ocha_500px.png";
		iso[71]="GIN";	country[71]="Guinea";	url[71]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/gin_ocha_500px.png";
		iso[72]="GLP";	country[72]="Guadeloupe";	url[72]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/glp_ocha_500px.png";
		iso[73]="GMB";	country[73]="Gambia";	url[73]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/gmb_ocha_500px.png";
		iso[74]="GNB";	country[74]="Guinea-Bissau";	url[74]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/gnb_ocha_500px.png";
		iso[75]="GNQ";	country[75]="Equatorial Guinea";	url[75]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/gnq_ocha_500px.png";
		iso[76]="GRC";	country[76]="Greece";	url[76]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/grc_ocha_500px.png";
		iso[77]="GRD";	country[77]="Grenada";	url[77]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/grd_ocha_500px.png";
		iso[78]="GTM";	country[78]="Guatemala";	url[78]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/gtm_ocha_500px.png";
		iso[79]="GUF";	country[79]="French Guiana";	url[79]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/guf_ocha_500px.png";
		iso[80]="GUY";	country[80]="Guyana";	url[80]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/guy_ocha_500px.png";
		iso[81]="HKG";	country[81]="China, Hong Kong Special Administrative Region";	url[81]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/hkg_ocha_500px.png";
		iso[82]="HND";	country[82]="Honduras";	url[82]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/hnd_ocha_500px.png";
		iso[83]="HRV";	country[83]="Croatia";	url[83]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/hrv_ocha_500px.png";
		iso[84]="HTI";	country[84]="Haiti";	url[84]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/hti_ocha_500px.png";
		iso[85]="HUN";	country[85]="Hungary";	url[85]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/hun_ocha_500px.png";
		iso[86]="IDN";	country[86]="Indonesia";	url[86]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/idn_ocha_500px.png";
		iso[87]="IND";	country[87]="India";	url[87]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ind_ocha_500px.png";
		iso[88]="IRL";	country[88]="Ireland";	url[88]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/irl_ocha_500px.png";
		iso[89]="IRN";	country[89]="Iran (Islamic Republic of)";	url[89]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/irn_ocha_500px.png";
		iso[90]="IRQ";	country[90]="Iraq";	url[90]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/irq_ocha_500px.png";
		iso[91]="ISL";	country[91]="Iceland";	url[91]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/isl_ocha_500px.png";
		iso[92]="ISR";	country[92]="Israel";	url[92]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/isr_ocha_500px.png";
		iso[93]="ITA";	country[93]="Italy";	url[93]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ita_ocha_500px.png";
		iso[94]="JAM";	country[94]="Jamaica";	url[94]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/jam_ocha_500px.png";
		iso[95]="JOR";	country[95]="Jordan";	url[95]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/jor_ocha_500px.png";
		iso[96]="JPN";	country[96]="Japan";	url[96]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/jpn_ocha_500px.png";
		iso[97]="KAZ";	country[97]="Kazakhstan";	url[97]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/kaz_ocha_500px.png";
		iso[98]="KEN";	country[98]="Kenya";	url[98]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ken_ocha_500px.png";
		iso[99]="KGZ";	country[99]="Kyrgyzstan";	url[99]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/kgz_ocha_500px.png";
		iso[100]="KHM";	country[100]="Cambodia";	url[100]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/khm_ocha_500px.png";
		iso[101]="KIR";	country[101]="Kiribati";	url[101]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/kir_ocha_500px.png";
		iso[102]="KNA";	country[102]="Saint Kitts and Nevis";	url[102]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/kna_ocha_500px.png";
		iso[103]="KOR";	country[103]="Democratic People's Republic of Korea";	url[103]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/kor_ocha_500px.png";
		iso[104]="KWT";	country[104]="Kuwait";	url[104]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/kwt_ocha_500px.png";
		iso[105]="LAO";	country[105]="Lao People's Democratic Republic";	url[105]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lao_ocha_500px.png";
		iso[106]="LBN";	country[106]="Lebanon";	url[106]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lbn_ocha_500px.png";
		iso[107]="LBR";	country[107]="Liberia";	url[107]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lbr_ocha_500px.png";
		iso[108]="LBY";	country[108]="Libya";	url[108]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lby_ocha_500px.png";
		iso[109]="LCA";	country[109]="Saint Lucia";	url[109]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lca_ocha_500px.png";
		iso[110]="LIE";	country[110]="Liechtenstein";	url[110]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lie_ocha_500px.png";
		iso[111]="LKA";	country[111]="Sri Lanka";	url[111]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lka_ocha_500px.png";
		iso[112]="LSO";	country[112]="Lesotho";	url[112]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lso_ocha_500px.png";
		iso[113]="LTU";	country[113]="Lithuania";	url[113]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ltu_ocha_500px.png";
		iso[114]="LUX";	country[114]="Luxembourg";	url[114]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lux_ocha_500px.png";
		iso[115]="LVA";	country[115]="Latvia";	url[115]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/lva_ocha_500px.png";
		iso[116]="MAC";	country[116]="China, Macao Special Administrative Region";	url[116]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mac_ocha_500px.png";
		iso[117]="MAR";	country[117]="Morocco";	url[117]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mar_ocha_500px.png";
		iso[118]="MCO";	country[118]="Monaco";	url[118]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mco_ocha_500px.png";
		iso[119]="MDA";	country[119]="Republic of Moldova";	url[119]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mda_ocha_500px.png";
		iso[120]="MDG";	country[120]="Madagascar";	url[120]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mdg_ocha_500px.png";
		iso[121]="MDV";	country[121]="Maldives";	url[121]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mdv_ocha_500px.png";
		iso[122]="MEX";	country[122]="Mexico";	url[122]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mex_ocha_500px.png";
		iso[123]="MHL";	country[123]="Marshall Islands";	url[123]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mhl_ocha_500px.png";
		iso[124]="MKD";	country[124]="The former Yugoslav Republic of Macedonia";	url[124]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mkd_ocha_500px.png";
		iso[125]="MLI";	country[125]="Mali";	url[125]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mli_ocha_500px.png";
		iso[126]="MLT";	country[126]="Malta";	url[126]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mlt_ocha_500px.png";
		iso[127]="MMR";	country[127]="Myanmar";	url[127]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mmr_ocha_500px.png";
		iso[128]="MNE";	country[128]="Montenegro";	url[128]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mne_ocha_500px.png";
		iso[129]="MNG";	country[129]="Mongolia";	url[129]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mng_ocha_500px.png";
		iso[130]="MOZ";	country[130]="Mozambique";	url[130]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/moz_ocha_500px.png";
		iso[131]="MRT";	country[131]="Mauritania";	url[131]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mrt_ocha_500px.png";
		iso[132]="MSR";	country[132]="Montserrat";	url[132]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/msr_ocha_500px.png";
		iso[133]="MTQ";	country[133]="Martinique";	url[133]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mtq_ocha_500px.png";
		iso[134]="MUS";	country[134]="Mauritius";	url[134]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mus_ocha_500px.png";
		iso[135]="MWI";	country[135]="Malawi";	url[135]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mwi_ocha_500px.png";
		iso[136]="MYS";	country[136]="Malaysia";	url[136]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/mys_ocha_500px.png";
		iso[137]="MYT";	country[137]="Mayotte";	url[137]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/myt_ocha_500px.png";
		iso[138]="NAM";	country[138]="Namibia";	url[138]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/nam_ocha_500px.png";
		iso[139]="NCL";	country[139]="New Caledonia";	url[139]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ncl_ocha_500px.png";
		iso[140]="NER";	country[140]="Niger";	url[140]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ner_ocha_500px.png";
		iso[141]="NGA";	country[141]="Nigeria";	url[141]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/nga_ocha_500px.png";
		iso[142]="NIC";	country[142]="Nicaragua";	url[142]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/nic_ocha_500px.png";
		iso[143]="NLD";	country[143]="Netherlands";	url[143]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/nld_ocha_500px.png";
		iso[144]="NOR";	country[144]="Norway";	url[144]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/nor_ocha_500px.png";
		iso[145]="NPL";	country[145]="Nepal";	url[145]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/npl_ocha_500px.png";
		iso[146]="NZL";	country[146]="New Zealand";	url[146]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/nzl_ocha_500px.png";
		iso[147]="OMN";	country[147]="Oman";	url[147]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/omn_ocha_500px.png";
		iso[148]="PAK";	country[148]="Pakistan";	url[148]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/pak_ocha_500px.png";
		iso[149]="PAN";	country[149]="Panama";	url[149]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/pan_ocha_500px.png";
		iso[150]="PER";	country[150]="Peru";	url[150]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/per_ocha_500px.png";
		iso[151]="PHL";	country[151]="Philippines";	url[151]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/phl_ocha_500px.png";
		iso[152]="PLW";	country[152]="Palau";	url[152]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/plw_ocha_500px.png";
		iso[153]="PNG";	country[153]="Papua New Guinea";	url[153]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/png_ocha_500px.png";
		iso[154]="POL";	country[154]="Poland";	url[154]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/pol_ocha_500px.png";
		iso[155]="PRI";	country[155]="Puerto Rico";	url[155]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/pri_ocha_500px.png";
		iso[156]="PRK";	country[156]="Republic of Korea";	url[156]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/prk_ocha_500px.png";
		iso[157]="PRT";	country[157]="Portugal";	url[157]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/prt_ocha_500px.png";
		iso[158]="PRY";	country[158]="Paraguay";	url[158]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/pry_ocha_500px.png";
		iso[159]="PSE";	country[159]="State of Palestine";	url[159]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/pse_ocha_500px.png";
		iso[160]="PYF";	country[160]="French Polynesia";	url[160]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/pyf_ocha_500px.png";
		iso[161]="QAT";	country[161]="Qatar";	url[161]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/qat_ocha_500px.png";
		iso[162]="REU";	country[162]="Réunion";	url[162]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/reu_ocha_500px.png";
		iso[163]="ROU";	country[163]="Romania";	url[163]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/rou_ocha_500px.png";
		iso[164]="RUS";	country[164]="Russian Federation";	url[164]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/rus_ocha_500px.png";
		iso[165]="RWA";	country[165]="Rwanda";	url[165]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/rwa_ocha_500px.png";
		iso[166]="SAU";	country[166]="Saudi Arabia";	url[166]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/sau_ocha_500px.png";
		iso[167]="SDN";	country[167]="Sudan";	url[167]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/sdn_ocha_500px.png";
		iso[168]="SEN";	country[168]="Senegal";	url[168]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/sen_ocha_500px.png";
		iso[169]="SGP";	country[169]="Singapore";	url[169]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/sgp_ocha_500px.png";
		iso[170]="SLB";	country[170]="Solomon Islands";	url[170]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/slb_ocha_500px.png";
		iso[171]="SLE";	country[171]="Sierra Leone";	url[171]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/sle_ocha_500px.png";
		iso[172]="SLV";	country[172]="El Salvador";	url[172]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/slv_ocha_500px.png";
		iso[173]="SMR";	country[173]="San Marino";	url[173]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/smr_ocha_500px.png";
		iso[174]="SOM";	country[174]="Somalia";	url[174]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/som_ocha_500px.png";
		iso[175]="SRB";	country[175]="Serbia";	url[175]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/srb_ocha_500px.png";
		iso[176]="SSD";	country[176]="South Sudan";	url[176]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ssd_ocha_500px.png";
		iso[177]="STP";	country[177]="Sao Tome and Principe";	url[177]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/stp_ocha_500px.png";
		iso[178]="SUR";	country[178]="Suriname";	url[178]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/sur_ocha_500px.png";
		iso[179]="SVK";	country[179]="Slovakia";	url[179]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/svk_ocha_500px.png";
		iso[180]="SVN";	country[180]="Slovenia";	url[180]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/svn_ocha_500px.png";
		iso[181]="SWE";	country[181]="Sweden";	url[181]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/swe_ocha_500px.png";
		iso[182]="SWZ";	country[182]="Swaziland";	url[182]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/swz_ocha_500px.png";
		iso[183]="SYC";	country[183]="Seychelles";	url[183]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/syc_ocha_500px.png";
		iso[184]="SYR";	country[184]="Syrian Arab Republic";	url[184]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/syr_ocha_500px.png";
		iso[185]="TCA";	country[185]="Turks and Caicos Islands";	url[185]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tca_ocha_500px.png";
		iso[186]="TCD";	country[186]="Chad";	url[186]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tcd_ocha_500px.png";
		iso[187]="TGO";	country[187]="Togo";	url[187]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tgo_ocha_500px.png";
		iso[188]="THA";	country[188]="Thailand";	url[188]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tha_ocha_500px.png";
		iso[189]="TJK";	country[189]="Tajikistan";	url[189]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tjk_ocha_500px.png";
		iso[190]="TKM";	country[190]="Turkmenistan";	url[190]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tkm_ocha_500px.png";
		iso[191]="TLS";	country[191]="Timor-Leste";	url[191]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tls_ocha_500px.png";
		iso[192]="TON";	country[192]="Tonga";	url[192]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ton_ocha_500px.png";
		iso[193]="TTO";	country[193]="Trinidad and Tobago";	url[193]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tto_ocha_500px.png";
		iso[194]="TUN";	country[194]="Tunisia";	url[194]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tun_ocha_500px.png";
		iso[195]="TUR";	country[195]="Turkey";	url[195]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tur_ocha_500px.png";
		iso[196]="TUV";	country[196]="Tuvalu";	url[196]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tuv_ocha_500px.png";
		iso[197]="TWN";	country[197]="Taiwan";	url[197]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/twn_ocha_500px.png";
		iso[198]="TZA";	country[198]="United Republic of Tanzania";	url[198]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/tza_ocha_500px.png";
		iso[199]="UGA";	country[199]="Uganda";	url[199]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/uga_ocha_500px.png";
		iso[200]="UKR";	country[200]="Ukraine";	url[200]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ukr_ocha_500px.png";
		iso[201]="URY";	country[201]="Uruguay";	url[201]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ury_ocha_500px.png";
		iso[202]="USA";	country[202]="United States of America";	url[202]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/usa_ocha_500px.png";
		iso[203]="UZB";	country[203]="Uzbekistan";	url[203]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/uzb_ocha_500px.png";
		iso[204]="VCT";	country[204]="Saint Vincent and the Grenadines";	url[204]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/vct_ocha_500px.png";
		iso[205]="VEN";	country[205]="Venezuela (Bolivarian Republic of)";	url[205]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/ven_ocha_500px.png";
		iso[206]="VGB";	country[206]="British Virgin Islands";	url[206]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/vgb_ocha_500px.png";
		iso[207]="VIR";	country[207]="United States Virgin Islands";	url[207]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/vir_ocha_500px.png";
		iso[208]="VNM";	country[208]="Viet Nam";	url[208]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/vnm_ocha_500px.png";
		iso[209]="VUT";	country[209]="Vanuatu";	url[209]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/vut_ocha_500px.png";
		iso[210]="WSM";	country[210]="American Samoa";	url[210]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/wsm_ocha_500px.png";
		iso[211]="YEM";	country[211]="Yemen";	url[211]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/yem_ocha_500px.png";
		iso[212]="ZAF";	country[212]="South Africa";	url[212]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/zaf_ocha_500px.png";
		iso[213]="ZAR";	country[213]="Democratic Republic of the Congo";	url[213]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/cod_ocha_500px.png";
		iso[214]="ZMB";	country[214]="Zambia";	url[214]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/zmb_ocha_500px.png";
		iso[215]="ZWE";	country[215]="Zimbabwe";	url[215]="http://img.static.reliefweb.int/sites/reliefweb.int/files/resources/zwe_ocha_500px.png";

		
		for (int j=0; j<216; j++)
		{
			if (url[j].length()>0)
			{
				try{
					URL imgURL=new URL(url[j]);            
					BufferedImage jpg = ImageIO.read(imgURL);      			
					File f=new File("c:/tmp/w_maps/MAP_"+iso[j]+".png");
					ImageIO.write(jpg, "png", f );
				}
				catch (Exception xd)
				{
					System.out.println("Error on image"+url[j]+" ->"+xd.toString());
				}            	 
			}

		}

	}



	public void  processGARProfile(String sCapraFile, Connection con, DICountry countrybean, ResultSet mrset)
	{

		try {
			// get Country code and Name:



			// Original excel file
			InputStream inp = new FileInputStream(sCapraFile+"risk_profile_template.xlsm");
			// create a workbook object
			XSSFWorkbook workBook = new XSSFWorkbook(inp);

			// Gnerates the excel file from Java class
			processLossProfile(workBook, countrybean, con, mrset);
			processRiskProfile(workBook, countrybean, con, mrset);

			inp.close();

			//prepare excel and then write binary to response.
			String sOutputProfile=sCapraFile+"profiles/GAR_Profile_"+countrybean.countrycode+".xlsm";

			//*
			OutputStream excel = new FileOutputStream(sOutputProfile);
			workBook.write(excel);
			excel.close();			
			/*/
			ByteArrayOutputStream outStream =new ByteArrayOutputStream();
			workBook.write(outStream);
			OutputStream excel = new FileOutputStream(sOutputProfile);
			excel.write(outStream.toByteArray());
			excel.close();
			//*/


		} 
		catch (FileNotFoundException fne) {
			System.out.println("File not found...");
		} 
		catch (Exception ioe) {
			System.out.println("IOException..." + ioe.toString());
		}

	}


	@SuppressWarnings("deprecation")
	public void processLossProfile(XSSFWorkbook workBook, DICountry countrybean, Connection con, ResultSet mrset)
	{
		// Name that will be used
		String strSheetName = "Profile";
		//obtain worksheet object				
		XSSFSheet sheet = workBook.getSheetAt(workBook.getSheetIndex(strSheetName));
		//declare a row object reference
		XSSFRow row = null;
		//declare a cell object reference
		XSSFCell cell = null;

		int nStartingRow=2;
		boolean bReportFormat=false;   
		String sSql=""; 



		isDesInventar=false;
		int rowNum = nStartingRow;
		try	{
			stmt=con.createStatement ();

			// exceptions with DesInventar wrong country codes
			String sCountryCode=countrybean.countrycode;
			String sYear="2004";


			sSql="SELECT count(*) as nrecs, sum(muertos) as killed, sum(vivafec) as Hdamaged, sum(vivdest) as Hdestroyed," +
			" sum(economic_loss_agr) as loss, sum(afectados) as affected " +
			" from fichas join extension on clave=clave_ext " +
			"where (approved is null or approved=0) and fechano>2002 and level0='"+sCountryCode+"'";
			rset=stmt.executeQuery(sSql); 
			String sSource="EMDAT where ";
			if (rset.next())
			{
				if (rset.getInt(1)>0)
				{
					isDesInventar=true;
					sSource="fichas join extension on clave=clave_ext and risktype>0 and  ";
					if ("MAR".equals(countrybean.countrycode))
						sCountryCode="MOR";
					if ("KHM".equals(countrybean.countrycode))
						sCountryCode="CAM";

					sYear="2002";
				}
				else
				{
					sSql="SELECT count(*) as nrecs, sum(muertos) as killed, sum(vivafec) as Hdamaged, sum(vivdest) as Hdestroyed," +
					" sum(valorloc) as loss, sum(afectados) as affected from EMDAT" +
					" where (approved is null or approved=0) and fechano>2004 and level0='"+sCountryCode+"'";
					rset=stmt.executeQuery(sSql); 
					rset.next();
				}
			}

			// totals area
			setNumCell(sheet,rset.getInt("nrecs"), 70,12);
			setNumCell(sheet,rset.getInt("killed"), 71,12);
			if (rset.getInt("hDamaged")>0)
				setNumCell(sheet,rset.getInt("hDamaged"), 72,12);
			else
				setStringCell(sheet,"N/A",72,12);
			if (rset.getInt("hDestroyed")>0)
				setNumCell(sheet,rset.getInt("hDestroyed"), 73,12);
			else
				setStringCell(sheet,"N/A",73,12);
			setNumCell(sheet,rset.getDouble("loss"), 74,12);
			setNumCell(sheet,rset.getInt("affected"), 75,12);

			if (!isDesInventar)
				setStringCell(sheet,"Internationally reported loss",67,2);

			// now gets data in the support sheet.
			strSheetName = "disasters";
			//obtain worksheet object				
			sheet = workBook.getSheetAt(workBook.getSheetIndex(strSheetName));

			sSource+=" (approved is null or approved=0) and level0='"+sCountryCode+"'";

			// Frequency pie chart
			sSql="SELECT evento, count(*) as nrec from " +sSource+ " group by evento order by  nrec desc";
			rset=stmt.executeQuery(sSql); 
			setLossFrequency(workBook, sheet, nStartingRow, bReportFormat,rowNum);

			// Mortality pie chart
			sSql="SELECT evento, sum(muertos) as killed from " +sSource+ " and muertos>0 group by evento order by killed desc";
			rset=stmt.executeQuery(sSql); 
			setLossMortality(workBook, sheet, nStartingRow, bReportFormat,rowNum);

			// Economic loss pie chart			
			if (sSource.indexOf("EMDAT")>=0)
				sSql="SELECT evento, sum(valorloc) as loss from " +sSource+ " and valorloc>0 group by evento order by  loss desc";
			else
				sSql="SELECT evento, sum(economic_loss_agr) as loss from " +sSource+ " and economic_loss_agr>0 group by evento order by loss desc";
			rset=stmt.executeQuery(sSql); 
			setLossEconomy(workBook, sheet, nStartingRow, bReportFormat,rowNum);

		}
		catch (Exception exst) {
			System.out.println("[DI9] Error generating GAR Excel: "+exst.toString());
		}

		try{stmt.close();} catch (Exception e){}

	}


	/**
	 * @param workBook
	 * @param sheet
	 * @param nStartingRow
	 * @param bReportFormat
	 * @param rowNum
	 * @throws SQLException
	 */
	private void setLossFrequency(XSSFWorkbook workBook, XSSFSheet sheet,int nStartingRow, boolean bReportFormat, int rowNum)
	throws SQLException {
		XSSFRow row=null;
		XSSFCell cell;
		double nVal=0;
		double dAcumm=0;
		while (rset.next())
		{
			//USE OR CREATE ROW FOR RESULT SET
			row = sheet.getRow(rowNum);
			if (row==null)
				row = sheet.createRow(rowNum);
			// hazard name
			String sCell=htmlServer.not_null(rset.getString(1)).trim();
			cell = row.createCell(0);
			cell.setCellValue(sCell);
			// value
			nVal=rset.getDouble(2);
			cell = row.getCell(1); 
			cell.setCellValue(nVal+cell.getNumericCellValue());
			dAcumm+=nVal;
			if (rowNum<14)
				rowNum++; //prepare for next row, group all minors
		}

		if (rowNum>=14)
		{
			cell = row.getCell(0);
			cell.setCellValue("Other hazards");
		}

		// row with totals...	
		row = sheet.getRow(27);
		if (row==null)
			row = sheet.createRow(27);
		String sCell="TOTAL";
		cell = row.createCell(0);
		cell.setCellValue(sCell);
		//Add cell for result row
		cell = row.createCell(1); 
		cell.setCellValue(dAcumm);
		// Now, puts the number of rows in B3
		row = sheet.getRow(0);
		if (row==null)
			row = sheet.createRow(0);

		cell = row.createCell(1); 
		cell.setCellValue(rowNum-nStartingRow+1);

		rowNum++;
		// sets the right sizes for the named ranges -->>  TODO:   change for piecharts!!
		XSSFName range1=workBook.getNameAt(workBook.getNameIndex("DI_hazards_freq"));			
		range1.setRefersToFormula("disasters!$A$3:$A$"+rowNum);  // this will change to  .setRefersToFormula(...
		XSSFName range2=workBook.getNameAt(workBook.getNameIndex("DI_Frequency"));
		range2.setRefersToFormula("disasters!$B$3:$B$"+rowNum);  // this will change to  .setRefersToFormula(...

		rset.close();
	}


	/**
	 * @param workBook
	 * @param sheet
	 * @param nStartingRow
	 * @param bReportFormat
	 * @param rowNum
	 * @throws SQLException
	 */
	private void setLossMortality(XSSFWorkbook workBook, XSSFSheet sheet, int nStartingRow, boolean bReportFormat, int rowNum)
	throws SQLException {
		XSSFRow row=null;
		XSSFCell cell;
		NumberFormat f = NumberFormat.getInstance();
		f.setMaximumFractionDigits(0);
		f.setGroupingUsed(bReportFormat);
		double nVal=0;
		double dAcumm=0;
		while (rset.next())
		{
			//USE OR CREATE ROW FOR RESULT SET
			row = sheet.getRow(rowNum);
			if (row==null)
				row = sheet.createRow(rowNum);
			// hazard name
			String sCell=htmlServer.not_null(rset.getString(1)).trim();
			cell = row.createCell(3);
			cell.setCellValue(sCell);
			// value
			nVal=rset.getDouble(2);
			cell = row.getCell(4); 
			cell.setCellValue(nVal+cell.getNumericCellValue());
			dAcumm+=nVal;
			if (rowNum<14)
				rowNum++; //prepare for next row, group all minors
		}

		if (rowNum>=14)
		{
			cell = row.getCell(0);
			cell.setCellValue("Other hazards");
		}

		// row with totals...	
		row = sheet.getRow(27);
		if (row==null)
			row = sheet.createRow(27);
		String sCell="TOTAL";
		cell = row.createCell(3);
		cell.setCellValue(sCell);
		//Add cell for result row
		cell = row.createCell(4); 
		cell.setCellValue(dAcumm);
		// Now, puts the number of rows in B3
		row = sheet.getRow(0);
		if (row==null)
			row = sheet.createRow(0);

		cell = row.createCell(4); 
		cell.setCellValue(rowNum-nStartingRow+1);

		rowNum++;
		// sets the right sizes for the named ranges -->>  TODO:   change for piecharts!!
		XSSFName range1=workBook.getNameAt(workBook.getNameIndex("DI_hazard_mort"));			
		range1.setRefersToFormula("disasters!$D$3:$D$"+rowNum);  // this will change to  .setRefersToFormula(...
		XSSFName range2=workBook.getNameAt(workBook.getNameIndex("DI_Mortality"));
		range2.setRefersToFormula("disasters!$E$3:$E$"+rowNum);  // this will change to  .setRefersToFormula(...

		try{rset.close();} catch (Exception e){}
	}

	/**
	 * @param workBook
	 * @param sheet
	 * @param nStartingRow
	 * @param bReportFormat
	 * @param rowNum
	 * @throws SQLException
	 */
	private void setLossEconomy(XSSFWorkbook workBook, XSSFSheet sheet,	int nStartingRow, boolean bReportFormat, int rowNum)
	throws SQLException 
	{
		XSSFRow row=null;
		XSSFCell cell;
		double nVal=0;
		double dAcumm=0;
		while (rset.next())
		{
			//USE OR CREATE ROW FOR RESULT SET
			row = sheet.getRow(rowNum);
			if (row==null)
				row = sheet.createRow(rowNum);
			// hazard name
			String sCell=htmlServer.not_null(rset.getString(1)).trim();
			cell = row.createCell(6);
			cell.setCellValue(sCell);
			// value
			nVal=rset.getDouble(2);
			cell = row.getCell(7); 
			cell.setCellValue(nVal+cell.getNumericCellValue());
			dAcumm+=nVal;
			if (rowNum<14)
				rowNum++; //prepare for next row, group all minors
		}

		if (rowNum>=14)
		{
			cell = row.getCell(0);
			cell.setCellValue("Other hazards");
		}

		// row with totals...	
		row = sheet.getRow(21);
		if (row==null)
			row = sheet.createRow(27);
		String sCell="TOTAL";
		cell = row.createCell(6);
		cell.setCellValue(sCell);
		//Add cell for result row
		cell = row.createCell(7); 
		cell.setCellValue(dAcumm);
		// Now, puts the number of rows in B3
		row = sheet.getRow(0);
		if (row==null)
			row = sheet.createRow(0);

		cell = row.createCell(7); 
		cell.setCellValue(rowNum-nStartingRow+1);

		rowNum++;

		// sets the right sizes for the named ranges -->>  TODO:   change for piecharts!!
		XSSFName range1=workBook.getNameAt(workBook.getNameIndex("DI_Hazard_Econ"));			
		range1.setRefersToFormula("disasters!$G$3:$G$"+rowNum);  // this will change to  .setRefersToFormula(...
		XSSFName range2=workBook.getNameAt(workBook.getNameIndex("DI_Economic"));
		range2.setRefersToFormula("disasters!$H$3:$H$"+rowNum);  // this will change to  .setRefersToFormula(...

		try{rset.close();} catch (Exception e){}
	}


	@SuppressWarnings("deprecation")
	public void processRiskProfile(XSSFWorkbook workBook, DICountry countrybean, Connection con, ResultSet mrset)
	{
		// Name that will be used
		String strSheetName = "Profile";
		//obtain worksheet object		
		XSSFSheet sheet = workBook.getSheetAt(workBook.getSheetIndex(strSheetName));
		//declare a row object reference
		XSSFRow row = null;
		//declare a cell object reference
		XSSFCell cell = null;
		//create stype and create Bold font style
		try{

			double nVal=0;
			String sCell="";
			// prototypes:



			sCell=htmlServer.not_null(countrybean.countryname).toUpperCase();			 
			setStringCell(sheet, sCell, 2, 2);

			setStringCell(sheet,htmlServer.not_null(mrset.getString("region")),3,2);


			// nVal=mrset.getDouble(2);
			// setNumCell(sheet, nVal, rowNum, colNum);

			// here we go:
			// setNumCell(sheet, nVal, rowNum, colNum);
			setNumCell(sheet,mrset.getDouble("POPULATION")/1000000, 4,7);
			setNumCell(sheet,mrset.getDouble("POP_DENS"), 5,7);
			setNumCell(sheet,mrset.getDouble("GDP"), 6,7);
			setNumCell(sheet,mrset.getDouble("GDP_PC"), 7,7);
			setNumCell(sheet,mrset.getDouble("TOT_STOCK"), 8,7);
			setNumCell(sheet,mrset.getDouble("POP_GROWTH"), 13,7);
			setNumCell(sheet,mrset.getDouble("GFCF_GPD"), 14,7);     //  note typo GDP
			setNumCell(sheet,mrset.getDouble("GINI"), 16,7);
			setNumCell(sheet,mrset.getDouble("LIFE_EXP"), 17,7);
			setNumCell(sheet,mrset.getDouble("POV_GAP"),19,7);
			setNumCell(sheet,mrset.getDouble("RULE"), 21,7);
			setNumCell(sheet,mrset.getDouble("G_EFFECT"), 22,7);
			setNumCell(sheet,mrset.getDouble("VOICE"), 23,7);
			setNumCell(sheet,mrset.getDouble("CORRUPT"), 24,7);


			setNumCell(sheet,mrset.getDouble("GFCF"), 4,12);
			setNumCell(sheet,mrset.getDouble("SOC_EXPEND"), 5,12);
			setNumCell(sheet,mrset.getDouble("GROSS_SAV"), 6,12);
			setNumCell(sheet,mrset.getDouble("RESERVES"), 7,12);
			setNumCell(sheet,mrset.getDouble("URBAN_GR"), 13,12);
			setNumCell(sheet,mrset.getDouble("SLUMS"), 14,12);
			setNumCell(sheet,mrset.getDouble("URBAN_R"), 15,12);
			setNumCell(sheet,mrset.getDouble("ECO_FOOT"), 17,12);
			setNumCell(sheet,mrset.getDouble("ENV_PERF"), 18,12);
			setNumCell(sheet,mrset.getDouble("FORCH"),19,12);
			setNumCell(sheet,mrset.getDouble("FRESH_WTR"), 20,12);
			setNumCell(sheet,mrset.getDouble("GREEN_ELEC"), 23,12);
			setNumCell(sheet,mrset.getDouble("CO2"), 24,12);


			// BLOCK OF AAL'S (Just these, the rest are formulas
			setNumCell(sheet,mrset.getDouble("EQ_AAL"), 30,5);
			setNumCell(sheet,mrset.getDouble("WD_AAL"), 31,5);
			setNumCell(sheet,mrset.getDouble("SS_AAL"), 32,5);
			setNumCell(sheet,mrset.getDouble("TS_AAL"), 33,5);
			setNumCell(sheet,mrset.getDouble("VO_AAL"), 34,5);
			setNumCell(sheet,mrset.getDouble("FL_AAL"), 35,5);
			setNumCell(sheet,mrset.getDouble("AAL"), 36,5);


			// implications index
			setNumCell(sheet,mrset.getDouble("IDX_STOCK"), 41,2);
			setNumCell(sheet,mrset.getDouble("IDX_GFCF"), 43,2);
			setNumCell(sheet,mrset.getDouble("IDX_SOCEX"), 45,2);
			setNumCell(sheet,mrset.getDouble("IDX"), 48,2);
			setNumCell(sheet,mrset.getDouble("IDX_RANK"), 50,2);
			setStringCell(sheet,"--", 50,2);

			
			
			setNumCell(sheet,mrset.getDouble("priority1_2011"), 5,23);
			setNumCell(sheet,mrset.getDouble("priority2_2011"), 5,24);
			setNumCell(sheet,mrset.getDouble("priority3_2011"), 5,25);
			setNumCell(sheet,mrset.getDouble("priority4_2011"), 5,26);
			setNumCell(sheet,mrset.getDouble("priority5_2011"), 5,27);
			setNumCell(sheet,mrset.getDouble("total_2011"), 5,28);
			
			setNumCell(sheet,mrset.getDouble("priority1_2009"), 5,29);
			setNumCell(sheet,mrset.getDouble("priority2_2009"), 5,30);
			setNumCell(sheet,mrset.getDouble("priority3_2009"), 5,31);
			setNumCell(sheet,mrset.getDouble("priority4_2009"), 5,32);
			setNumCell(sheet,mrset.getDouble("priority5_2009"), 5,33);
			setNumCell(sheet,mrset.getDouble("total_2009"), 5,34);

			setNumCell(sheet,mrset.getDouble("priority1_2007"), 5,35);
			setNumCell(sheet,mrset.getDouble("priority2_2007"), 5,36);
			setNumCell(sheet,mrset.getDouble("priority3_2007"), 5,37);
			setNumCell(sheet,mrset.getDouble("priority4_2007"), 5,38);
			setNumCell(sheet,mrset.getDouble("priority5_2007"), 5,39);
			setNumCell(sheet,mrset.getDouble("total_2007"), 5,40);

			// AAL PER SECTOR
			setNumCell(sheet,mrset.getDouble("RES_LOW"), 41,6);
			setNumCell(sheet,mrset.getDouble("RES_MIDLOW"), 42,6);
			setNumCell(sheet,mrset.getDouble("RES_MIDHIGH"), 43,6);
			setNumCell(sheet,mrset.getDouble("RES_HIGH"), 44,6);
			setNumCell(sheet,mrset.getDouble("COMMERCIAL"), 45,6);
			setNumCell(sheet,mrset.getDouble("INDUSTRIAL"), 46,6);
			setNumCell(sheet,mrset.getDouble("ED_PRIVATE"), 47,6);
			setNumCell(sheet,mrset.getDouble("ED_PUBLIC"), 48,6);
			setNumCell(sheet,mrset.getDouble("GOVERNMENT"), 49,6);
			setNumCell(sheet,mrset.getDouble("FISCAL"), 50,6);
			setNumCell(sheet,mrset.getDouble("NATIONAL"), 51,6);

			setNumCell(sheet,mrset.getDouble("RES_LOW_AAL"), 41,7);
			setNumCell(sheet,mrset.getDouble("RES_MIDLOW_AAL"), 42,7);
			setNumCell(sheet,mrset.getDouble("RES_MIDHIGH_AAL"), 43,7);
			setNumCell(sheet,mrset.getDouble("RES_HIGH_AAL"), 44,7);
			setNumCell(sheet,mrset.getDouble("COMMERCIAL_AAL"), 45,7);
			setNumCell(sheet,mrset.getDouble("INDUSTRIAL_AAL"), 46,7);
			setNumCell(sheet,mrset.getDouble("ED_PRIVATE_AAL"), 47,7);
			setNumCell(sheet,mrset.getDouble("ED_PUBLIC_AAL"), 48,7);
			setNumCell(sheet,mrset.getDouble("GOVERNMENT_AAL"), 49,7);
			setNumCell(sheet,mrset.getDouble("FISCAL_AAL"), 50,7);
			setNumCell(sheet,mrset.getDouble("NATIONAL_AAL"), 51,7);


			// PML SECTION
			setNumCell(sheet,mrset.getDouble("EQPML100"), 59,7);
			setNumCell(sheet,mrset.getDouble("EQPML250"), 59,9);
			setNumCell(sheet,mrset.getDouble("EQPML500"), 59,10);
			setNumCell(sheet,mrset.getDouble("EQPML1000"), 59,11);
			setNumCell(sheet,mrset.getDouble("EQPML1500"), 59,12);

			setNumCell(sheet,mrset.getDouble("WDPML100"), 60,7);
			setNumCell(sheet,mrset.getDouble("WDPML250"), 60,9);
			setNumCell(sheet,mrset.getDouble("WDPML500"), 60,10);
			setNumCell(sheet,mrset.getDouble("WDPML1000"), 60,11);
			setNumCell(sheet,mrset.getDouble("WDPML1500"), 60,12);

			setNumCell(sheet,mrset.getDouble("SSPML100"), 61,7);
			setNumCell(sheet,mrset.getDouble("SSPML250"), 61,9);
			setNumCell(sheet,mrset.getDouble("SSPML500"), 61,10);
			setNumCell(sheet,mrset.getDouble("SSPML1000"), 61,11);
			setNumCell(sheet,mrset.getDouble("SSPML1500"), 61,12);


			setNumCell(sheet,mrset.getDouble("TSPML100"), 62,7);
			setNumCell(sheet,mrset.getDouble("TSPML250"), 62,9);
			setNumCell(sheet,mrset.getDouble("TSPML500"), 62,10);
			setNumCell(sheet,mrset.getDouble("TSPML1000"), 62,11);
			setNumCell(sheet,mrset.getDouble("TSPML1500"), 62,12);



			// PML SECTION
			// Name that will be used
			strSheetName = "PML";
			//obtain worksheet object		
			sheet = workBook.getSheetAt(workBook.getSheetIndex(strSheetName));

			setNumCell(sheet,mrset.getDouble("EQPML20"), 3,16);
			setNumCell(sheet,mrset.getDouble("EQPML50"), 3,17);
			setNumCell(sheet,mrset.getDouble("EQPML100"), 3,18);
			setNumCell(sheet,mrset.getDouble("EQPML250"), 3,19);
			setNumCell(sheet,mrset.getDouble("EQPML500"), 3,20);
			setNumCell(sheet,mrset.getDouble("EQPML1000"), 3,21);
			setNumCell(sheet,mrset.getDouble("EQPML1500"), 3,22);

			setNumCell(sheet,mrset.getDouble("WDPML20"), 4,16);
			setNumCell(sheet,mrset.getDouble("WDPML50"), 4,17);
			setNumCell(sheet,mrset.getDouble("WDPML100"), 4,18);
			setNumCell(sheet,mrset.getDouble("WDPML250"), 4,19);
			setNumCell(sheet,mrset.getDouble("WDPML500"), 4,20);
			setNumCell(sheet,mrset.getDouble("WDPML1000"), 4,21);
			setNumCell(sheet,mrset.getDouble("WDPML1500"), 4,22);

			setNumCell(sheet,mrset.getDouble("SSPML20"), 5,16);
			setNumCell(sheet,mrset.getDouble("SSPML50"), 5,17);
			setNumCell(sheet,mrset.getDouble("SSPML100"), 5,18);
			setNumCell(sheet,mrset.getDouble("SSPML250"), 5,19);
			setNumCell(sheet,mrset.getDouble("SSPML500"), 5,20);
			setNumCell(sheet,mrset.getDouble("SSPML1000"), 5,21);
			setNumCell(sheet,mrset.getDouble("SSPML1500"), 5,22);


			setNumCell(sheet,mrset.getDouble("TSPML20"), 6,16);
			setNumCell(sheet,mrset.getDouble("TSPML50"), 6,17);
			setNumCell(sheet,mrset.getDouble("TSPML100"), 6,18);
			setNumCell(sheet,mrset.getDouble("TSPML250"), 6,19);
			setNumCell(sheet,mrset.getDouble("TSPML500"), 6,20);
			setNumCell(sheet,mrset.getDouble("TSPML1000"), 6,21);
			setNumCell(sheet,mrset.getDouble("TSPML1500"), 6,22);



			// http://localhost/DesInventar/thematic_def.jsp?bookmark=1&countrycode=wo3&maxhits=100&lang=EN&logic=AND&sortby=0&frompage=/thematic_def.jsp&_range=,1.0,10.0,100.0,1000.0,10000.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0&_color=@23d5ffff,@238fffff,@2379e4e4,@2368c3c3,@237aafaf,@23769292,,,,,,,,&_legend=,,,,,,,,,,,,&chartColor=1&chartX=1000&chartY=600&chartTitle=&chartSubTitle=&showValues=0&legendType=0&level_rep=0&level_map=0&dissagregate_map=0&_variables=1
			
			strSheetName = "Profile";
			sheet = workBook.getSheetAt(workBook.getSheetIndex(strSheetName));	

			
			String sMapFile="c:/tmp/w_maps/MAP_"+countrybean.countrycode+".png";
			File fmap=new File(sMapFile);
			if (fmap.exists())
			{
				// this will convert the image to PNG in order to make it scalable
	            BufferedImage jpg_src = ImageIO.read(fmap);
	            BufferedImage jpg=jpg_src;

	            if (jpg.getWidth()==500)
	            {
		            jpg=new BufferedImage(492, 492, BufferedImage.TYPE_INT_ARGB); 
		            Graphics g=jpg.getGraphics();
		            g.drawImage(jpg_src,0,0,492,492,4,4,496,496,null);
	            }
	            else if (jpg.getWidth()==250)
	            {
		            jpg=new BufferedImage(250, 250, BufferedImage.TYPE_INT_ARGB); 
		            Graphics g=jpg.getGraphics();
		            g.drawImage(jpg_src,0,0,250,250,0,0,250,250,null);		          
	            }
	            ByteArrayOutputStream baos = new ByteArrayOutputStream();
	        	ImageIO.write( jpg, "png", baos );
	        	baos.flush();
	        	byte[] imageInByte = baos.toByteArray();
	        	baos.close();

    		    //add picture data to this workbook.		    
	            int pictureIdx = workBook.addPicture(imageInByte, workBook.PICTURE_TYPE_PNG); //.PICTURE_TYPE_JPEG);
	            CreationHelper helper = workBook.getCreationHelper();
	            // Create the drawing patriarch.  This is the top level container for all shapes. 
	            Drawing drawing = sheet.createDrawingPatriarch();
	            //add a picture shape
	            ClientAnchor anchor = helper.createClientAnchor();
	            //set top-left corner of the picture,
	            //subsequent call of Picture#resize() will operate relative to it
	            anchor.setCol1(2);
	            anchor.setRow1(4);
	            Picture pict = drawing.createPicture(anchor, pictureIdx);
	            //auto-size picture relative to its top-left corner
	            if (jpg.getWidth()>600)
	            	pict.resize(0.3);
	            else
	            	if (jpg.getHeight()>300)
		            	pict.resize(0.5);
	            	else
	            		pict.resize();
			}

			
			// recalculates the profiles!!!
			sheet.setForceFormulaRecalculation(true);


		}
		catch (Exception exst) {
			System.out.println("[DI9] Error generating GAR Excel: "+exst.toString());
		}


	}


	/**
	 * @param sheet
	 * @param nVal
	 * @param rowNum
	 */
	private void setNumCell(XSSFSheet sheet, double nVal, int rowNum,	int colNum) 
	{
		XSSFRow row;
		XSSFCell cell;
		row = sheet.getRow(rowNum);
		if (row==null)
			row = sheet.createRow(rowNum);
		cell =  row.getCell(colNum); 
		if (cell==null)
			cell =  row.createCell(colNum); 
		cell.setCellValue(nVal);
	}


	/**
	 * @param sheet
	 * @param sCell
	 * @param rowNum
	 * @param colNum
	 */
	private void setStringCell(XSSFSheet sheet, String sCell, int rowNum,	int colNum) 
	{
		XSSFRow row;
		XSSFCell cell;
		row = sheet.getRow(rowNum);
		if (row==null)
			row = sheet.createRow(rowNum);
		cell =  row.getCell(colNum); 
		if (cell==null)
			cell =  row.createCell(colNum); 
		cell.setCellValue(sCell);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{

		//GAR_country_profile_excel.getMaps();
		

		Sys.getProperties();
		DICountry countrybean= new DICountry();

	
		try{

			dbConnection dbDefaultCon=new dbConnection();
			boolean bdConnectionOK = dbDefaultCon.dbGetConnectionStatus();
			Connection pc_connection=null;
			if (bdConnectionOK)
			{
				pc_connection=dbDefaultCon.dbGetConnection();
			}  // opening dB!!
			else
			{
				System.out.println ("Exception DI Import. opening main database...");
			}



			// GAR 2013 settings in country bean...
			countrybean.country.scountryid="g15";
			countrybean.country.getWebObject(pc_connection);
			countrybean.countrycode=countrybean.country.scountryid;
			countrybean.countryname=countrybean.country.scountryname;
			countrybean.dbType=countrybean.country.ndbtype;
			pooledConnection univ=new pooledConnection(countrybean.country.sdriver,countrybean.country.sdatabasename , countrybean.country.susername,countrybean.country.spassword);
			univ.getConnection();
			Connection con=univ.connection;

			pc_connection.close();

			ResultSet mrset=null;
			Statement mstmt=null;

			mstmt=con.createStatement();
			mrset=mstmt.executeQuery("Select * from risk_results JOIN hfa on iso=iso_hfa join soc_variables on iso=iso_soc join sector on iso=iso_sec order by iso");
			// File fCapraFolder=new File("/data/riskdataviewer/data2015/results/original");
			String sCapraFolder="/data/riskdataviewer/data2015/results/";

			// debug:  advance to agfganistan. comment:			mrset.next();  
			while (mrset.next()) 
			{
				GAR_country_profile_excel  gprofile=new GAR_country_profile_excel();

				try 
				{
					String sCode=mrset.getString("iso").trim();
					countrybean.countrycode=sCode;
					countrybean.countryname=countrybean.country.scountryname=mrset.getString("country");
					System.out.println("[DI9] GENERATING PROFILE : "+sCode+" - "+countrybean.countryname);		    	
					gprofile.processGARProfile(sCapraFolder, con, countrybean, mrset);
					// for now, just one file... break;
				}
				catch (Exception eImp)
				{
					System.out.println("[DI9] Error importing DesInventar Universe:  "+countrybean.countrycode+" - "+countrybean.countryname +" ; "+eImp.toString());
				}


			}

			con.close();
		}
		catch (Exception eImp)
		{
			System.out.println("[DI9] Error importing DesInventar UNIVERSE: "+eImp.toString());
		}

	}

}
