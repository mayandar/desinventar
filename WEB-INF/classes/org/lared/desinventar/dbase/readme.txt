This is a general release of the simple DBASE SQL API.

It's simple.  It can't do anything complicated.  DBASE is also simple and it 
can't do anything complicated. It's everywhere you want a real database to be. 
So I offer this as a means to at least get at legacy data in a semi-civilized 
way and hopefully convert it to something more modern.

There is an example, Test.java, which uses the example databases in the 
'example' directory. There are small representative databases of DBaseIII, DBase 
IV, .and FoxPro 2. Test.java contains a number of SQL statements over each 
database and uses a few DBase methods. The original databases are in the 
directory example/save so the pristine originals may be copied over those in the 
example directory that have been altered.

Documentation is found in docs/index.htm with further documentation found in the OverView section
of the API reference (under the link to 'Description').

This requires the Java Compiler Compiler version 2.1 or greater (it was 
developed on 2.0 and compiles under 2.1).

All the necessary files for compiling are included. Some files are created by
JavaCC, but the core files are:

Where.java
SQLStatement.java
FieldValue.java
Intel.java
LongList.java
Pair.java
PairList.java
MemoHandler.java
DBASEIVMemoHandler.java
DBASEIIIMemoHandler.java

If you version of the JavaCC compiler complains get rid of these files and their
class files.  These are regenerated from the SQL.jj file.

JavaCharStream.java
ParseException.java
SQL.java
SQLConstants.java
SQLTokenManager.java
Token.java
TokenMgrError.java

If there are problems installing, compiling, or in the operation of the server please contact
Michael Lecuyer at mjl@theorem.com for help.

Copyright 2001 - 2003 Michael Lecuyer. This code may be used under the Gnu
General Public License [http://www.gnu.org/copyleft/gpl.html].