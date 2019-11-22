echo ***********************************************************************************
echo * deploying to full installer
echo ***********************************************************************************
c:
cd C:\osso\web
copy deploy.bat webapps\DesInventar\scripts
copy webapps\DesInventar\*.* ..\web-installer\Server\webapps\DesInventar /y
copy webapps\DesInventar\*.doc C:\osso\CD /y
copy webapps\DesInventar\*.ppt C:\osso\CD /y
copy webapps\DesInventar\*.pdf C:\osso\CD /y
del ..\web-installer\Server\webapps\DesInventar\desinventar*.mdb 
del ..\web-installer\setup*.exe 
xcopy webapps\DesInventar\inv\*.* ..\web-installer\Server\webapps\DesInventar\inv /y /s
xcopy webapps\DesInventar\util\*.* ..\web-installer\Server\webapps\DesInventar\util /y /s
xcopy webapps\DesInventar\html\*.* ..\web-installer\Server\webapps\DesInventar\html /y /S
xcopy webapps\DesInventar\help\*.* ..\web-installer\Server\webapps\DesInventar\help /y /S
xcopy webapps\DesInventar\images\*.* ..\web-installer\Server\webapps\DesInventar\images /y /s
xcopy webapps\DesInventar\img\*.* ..\web-installer\Server\webapps\DesInventar\img /y /s
xcopy webapps\DesInventar\wdds\*.* ..\web-installer\Server\webapps\DesInventar\wdds /y /s
xcopy webapps\DesInventar\json\*.* ..\web-installer\Server\webapps\DesInventar\json /y /s
xcopy webapps\DesInventar\download\index.jsp ..\web-installer\Server\webapps\DesInventar\download /y /s
xcopy webapps\DesInventar\download\LICENSE.* ..\web-installer\Server\webapps\DesInventar\download /y /s
dxcopy webapps\DesInventar\scripts\*.* ..\web-installer\Server\webapps\DesInventar\scripts /s /y
xcopy webapps\DesInventar\src\index.jsp ..\web-installer\Server\webapps\DesInventar\src  /s /y
xcopy webapps\DesInventar\src\org\*.* ..\web-installer\Server\webapps\DesInventar\src\org  /s /y
xcopy webapps\DesInventar\WEB-INF\classes\org\lared\*.* ..\web-installer\Server\webapps\DesInventar\WEB-INF\classes\org\lared  /s /y
xcopy webapps\DesInventar\WEB-INF\web.xml ..\web-installer\Server\webapps\DesInventar\WEB-INF\web.xml /y /s
xcopy webapps\DesInventar\WEB-INF\classes\com\*.* ..\web-installer\Server\webapps\DesInventar\WEB-INF\classes\com  /s /y

REM copy webapps\DesInventar\WEB-INF\exe\*.* ..\web-installer\Server\webapps\DesInventar\WEB-INF\exe /y

xcopy webapps\DesInventar\WEB-INF\lib\*.* ..\web-installer\Server\webapps\DesInventar\WEB-INF\lib /y /s
del ..\web-installer\Server\webapps\DesInventar\WEB-INF\lib\postgr*.jar
del ..\web-installer\Server\webapps\DesInventar\WEB-INF\lib\ojdbc14.jar
del ..\web-installer\Server\webapps\DesInventar\WEB-INF\lib\sqljdbc.jar
xcopy webapps\ROOT\*.* ..\web-installer\Server\webapps\ROOT  /s /y
del ..\web-installer\Server\webapps\ROOT\doc\*.doc
del ..\web-installer\Server\webapps\ROOT\doc\*.pdf
del ..\web-installer\Server\webapps\ROOT\doc\*.ppt

REM NEW!  Installer does not carry documents
del ..\web-installer\Server\webapps\DesInventar\*.doc
del ..\web-installer\Server\webapps\DesInventar\*.ppt
del ..\web-installer\Server\webapps\DesInventar\*.docx
del ..\web-installer\Server\webapps\DesInventar\*.pptx
del ..\web-installer\Server\webapps\DesInventar\*.pdf



echo ******************************
echo * copying web server software
echo ******************************
del  /Q /S ..\web-installer\Server\bin\*.*
xcopy bin\*.* ..\web-installer\Server\bin /Y /S
xcopy conf\*.* ..\web-installer\Server\conf /Y /S
copy conf\server8081.xml ..\web-installer\Server\conf\server.xml /Y 
del  /Q /S ..\web-installer\Server\server\*.*
xcopy server\*.* ..\web-installer\Server\server /Y /S
del  /Q /S ..\web-installer\Server\shared\*.*
xcopy shared\*.* ..\web-installer\Server\shared /Y /S
del  /Q /S ..\web-installer\Server\common\*.*
xcopy common\*.* ..\web-installer\Server\common /Y /S


attrib -r  ..\web-installer\*.* /s

echo ***********************************************************************************
echo * deploying to updater
echo ***********************************************************************************

copy webapps\DesInventar\*.* ..\web-update\Server\webapps\DesInventar /y
del ..\web-update\Server\webapps\DesInventar\desinventar*.mdb 
del ..\web-update\Server\webapps\DesInventar\*.doc 
del ..\web-update\Server\webapps\DesInventar\*.pdf 
del ..\web-update\Server\webapps\DesInventar\*.ppt 
del ..\web-update\Server\webapps\DesInventar\WEB-INF\lib\*.jar
del ..\web-update\Server\webapps\DesInventar\WEB-INF\exe\*.* /Y
del ..\web-update\setup*.exe 
del ..\web-update\update*.exe 
xcopy webapps\DesInventar\inv\*.* ..\web-update\Server\webapps\DesInventar\inv /y /s
xcopy webapps\DesInventar\util\*.* ..\web-update\Server\webapps\DesInventar\util /y /s
xcopy webapps\DesInventar\html\*.* ..\web-update\Server\webapps\DesInventar\html /y /S
xcopy webapps\DesInventar\help\*.* ..\web-update\Server\webapps\DesInventar\help /y /s
xcopy webapps\DesInventar\images\*.* ..\web-update\Server\webapps\DesInventar\images /y /s
xcopy webapps\DesInventar\img\*.* ..\web-update\Server\webapps\DesInventar\img /y /s
xcopy webapps\DesInventar\download\index.jsp ..\web-update\Server\webapps\DesInventar\download /y /s
xcopy webapps\DesInventar\download\LICENSE.* ..\web-update\Server\webapps\DesInventar\download /y /s
xcopy webapps\DesInventar\wdds\*.* ..\web-update\Server\webapps\DesInventar\wdds /y /s
xcopy webapps\DesInventar\json\*.* ..\web-update\Server\webapps\DesInventar\json /y /s
xcopy webapps\DesInventar\scripts\*.* ..\web-update\Server\webapps\DesInventar\scripts /s /y
xcopy webapps\DesInventar\src\index.jsp ..\web-update\Server\webapps\DesInventar\src  /s /y
xcopy webapps\DesInventar\src\org\*.* ..\web-update\Server\webapps\DesInventar\src\org  /s /y
xcopy webapps\DesInventar\WEB-INF\classes\org\lared\*.* ..\web-update\Server\webapps\DesInventar\WEB-INF\classes\org\lared  /s /y
xcopy webapps\DesInventar\WEB-INF\web.xml ..\web-update\Server\webapps\DesInventar\WEB-INF\web.xml /y /s
xcopy webapps\DesInventar\WEB-INF\classes\com\*.* ..\web-update\Server\webapps\DesInventar\WEB-INF\classes\com  /s /y

REM copy webapps\DesInventar\WEB-INF\exe\*.* ..\web-update\Server\webapps\DesInventar\WEB-INF\exe /y

copy webapps\DesInventar\WEB-INF\lib\*.* ..\web-update\Server\webapps\DesInventar\WEB-INF\lib /y
del ..\web-update\Server\webapps\DesInventar\WEB-INF\lib\postgr*.jar
del ..\web-update\Server\webapps\DesInventar\WEB-INF\lib\ojdbc14.jar
del ..\web-update\Server\webapps\DesInventar\WEB-INF\lib\sqljdbc.jar

xcopy webapps\ROOT\*.* ..\web-update\Server\webapps\ROOT  /s /y
del ..\web-update\Server\webapps\ROOT\doc\*.doc
del ..\web-update\Server\webapps\ROOT\doc\*.pdf
del ..\web-update\Server\webapps\ROOT\doc\*.ppt


attrib -r  ..\web-update\*.* /s



pause
