package org.lared.desinventar.util;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

public class EncriptionManager
{

  public String decript(String pass)
  {
    return pass;
  }

  public String encript(String pass)
  {
    return pass;
  }

  public String fdecript(String pass)
  {
    char[] cArray;
    String encr;
    char j;
    int ant;

    cArray = new char[pass.length()];
    pass.getChars(0, pass.length(), cArray, 0);
    if (pass.length() > 0)
    {
      cArray[0] = (char) (cArray[0] / 2);
      for (j = 1; j < pass.length(); j++)
      {
        ant = (int) (cArray[j] - cArray[j - 1] + (j % 8) * 3);
        cArray[j] = (char) (cArray[j] - cArray[j - 1] + (j % 8) * 3);
      }
    }
    encr = new String(cArray);
    return encr;
  }

  public String fencript(String pass)
  {
    char[] cArray, pArray;
    String encr;
    char j;
    int ant;

    cArray = new char[pass.length()];
    pass.getChars(0, pass.length(), cArray, 0);
    pArray = new char[pass.length()];
    pass.getChars(0, pass.length(), pArray, 0);
    if (pass.length() > 0)
    {
      cArray[0] = (char) (cArray[0] * 2);
      for (j = 1; j < pass.length(); j++)
      {
        ant = (char) (cArray[j] + pArray[j - 1] - (j % 8) * 3);
        cArray[j] = (char) (cArray[j] + pArray[j - 1] - (j % 8) * 3);
      }
    }
    encr = new String(cArray);
    return encr;
  }

}