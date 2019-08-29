package org.lared.desinventar.util;

import java.io.*;
import java.net.InetAddress;
import java.util.Properties;
import java.util.Date;

import javax.mail.*;
import javax.mail.internet.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

/**
 * Constructs and send an RFC822
 * (singlepart) message.
 *
 */
public class msgsend
{
  public String from = "desinventar@desinventar.org";
  public String subject = "Message from DesInventar";
  public String to = "jserje@canada.com";
  public String body = "A message from DesInventar";
  public String cc = null, bcc = null, url = null;
  public String mailhost = "localhost";
  public String mailer = "DesInventar mailer";
  public String protocol = "SMTP";

  public String user = "username";
  public String password = "password";
  public String comment = "";
  public String name = "You";
  public String guest = "He/She";
  public String id = "0";
  public java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd, HH:mm");
  public String datesent = formatter.format(new Date());

  String record = null; // name of folder in which to record mail
  boolean debug = false;

  public static void main(String[] argv)
  {
    msgsend mailer = new msgsend();
    // mailer.debug = true;
    mailer.from="julio.serje@undp.org";
    mailer.to="julio.serje@undp.org";
    mailer.body="A new message from the system...";


//   for (int j=0; j<1000; j++)
    mailer.send();
  }

  public msgsend()
  {
  }

  public void send()
  {
    int optind;

    try
    {
      Sys.getProperties();
      Properties props = System.getProperties();

      // XXX - could use Session.getTransport() and Transport.connect()
      // XXX - assume we're using SMTP
      if (Sys.sMailOutServerIp != null)
          props.put("mail.smtp.host", Sys.sMailOutServerIp);
      else
    	  props.put("mail.smtp.host", "localhost");
      if (debug)
        System.out.println("\nMail host:" + Sys.sMailOutServerIp);
        // Get a Session object
      Session session = Session.getDefaultInstance(props, null);
      if (debug)
         session.setDebug(true);
      // construct the message
      Message msg = new MimeMessage(session);
      msg.setFrom(new InternetAddress(from));
      msg.setRecipients(Message.RecipientType.TO,
                        InternetAddress.parse(to, false));
      if (cc != null)
        msg.setRecipients(Message.RecipientType.CC,
                          InternetAddress.parse(cc, false));
      if (bcc != null)
        msg.setRecipients(Message.RecipientType.BCC,
                          InternetAddress.parse(bcc, false));

      msg.setSubject(htmlServer.removeAccents(subject));
      msg.setText(htmlServer.removeAccents(body));
      msg.setHeader("Mime-Version", "1.0");
      msg.setHeader("Content-Transfer-Encoding", "quoted-printable");
      msg.setHeader("Content-Type", "text/html;charset=iso-8859-1"); // charset=UTF-8");
      msg.setHeader("X-Mailer", mailer);
      msg.setSentDate(new Date());

      // send the thing off
      Transport.send(msg);

      if (debug)
        System.out.println("\nMail was sent successfully.");
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
  }

  void strReplace(String sPattern, String sReplaceWith)
  {
    int pos = body.indexOf(sPattern);
    while (pos >= 0)
    {
      if (pos == 0)
        body = sReplaceWith + body.substring(sPattern.length());
      else
        body = body.substring(0, pos) + sReplaceWith + body.substring(pos + sPattern.length());
      pos = body.indexOf(sPattern);
    }
  }

  public String send(String sTemplate)
  {
    body = new String(sTemplate);
    // fills the template with the corresponding values
    strReplace("@name", name);
    strReplace("@user", user);
    strReplace("@password", password);
    strReplace("@comment", comment);
    strReplace("@guest", guest);
    strReplace("@id", id);
    strReplace("@date", datesent);
    send();
    return body;
  }

  public String preview(String sTemplate)
  {
    body = new String(sTemplate);
    // fills the template with the corresponding values
    strReplace("@name", name);
    strReplace("@user", user);
    strReplace("@password", password);
    strReplace("@comment", comment);
    strReplace("@guest", guest);
    strReplace("@id", id);
    strReplace("@date", datesent);
    return body;
  }

}