rem ************BEGIN_SCRIPT 
rem *****SCRIPT NAME:  startup.bat 
@echo off 
setlocal 


rem ********************************************************************************* 
rem * This script allows to start Tomcat 5 with debugging, from the command line    * 
rem *********************************************************************************

set PLATFORM_DIR=%CD%\..
set BIN_DIR=%PLATFORM_DIR%\bin


set DO_DEBUG=NO
set DEBUG_PORT=7070
set DO_DELETE_LOGS=NO
set SUSP_OPT=n

:: ---------------------------------------------------------------------------
:: Read in command line options

:Option_Parse
if (%1)==(-h) (
	goto ShowUsage
)

if (%1)==(-d) (
	set DO_DEBUG=YES
	shift
	goto Option_parse
)
if (%1)==(-p) (
	set DEBUG_PORT=%2
	shift
	shift
	goto Option_parse
)

if (%1)==(-logs) (
	set DO_DELETE_LOGS=YES
	shift
	goto Option_parse
)

:Option_Finished

goto ShowUsage_end

:ShowUsage
echo ***
echo *** Usage: startup [opt*]
echo ***   options:
echo ***     -d             startup for remote debugging
echo ***     -p [port]      port to use for remote debugging (default: 7070)  
echo ***     -susp          suspend JRE until debugger is connected (default)
echo ***     -run           run without waiting for debugger connection 
echo ***     -logs          delete win32/logs before starting  
echo ***
echo ***     -h             show this usage note
echo ***
goto Exit
:ShowUsage_end


rem This is the path to Tomcat home directory 
rem 
set CATALINA_HOME=%PLATFORM_DIR%

rem (Optional) Path to the Catalina base directory 
rem Leave this field empty to default to the working directory 
set CATALINA_BASE= 


rem This is the path to the Java home directory 
rem 
set JAVA_HOME=%PLATFORM_DIR%\jdk1.5
set JAVA_HOME=%PLATFORM_DIR%\jdk1.5

if not exist %JAVA_HOME% goto ErrNoJavaHome

set CATALINA_TMPDIR=%PLATFORM_DIR%\temp

IF NOT EXIST %CATALINA_TMPDIR% md %CATALINA_TMPDIR%

set CURR_DIR=%CD%
cd %BIN_DIR%


set DEBUG_OPTS=
if (%DO_DEBUG%)==(YES) set DEBUG_OPTS=-Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=%DEBUG_PORT%,server=y,suspend=%SUSP_OPT% -Djava.compiler=NONE

rem "for machines with 1GB RAM"
set CATALINA_OPTS=-Xmx768m -XX:MaxNewSize=384m -XX:NewSize=192m -XX:MaxPermSize=128m  %DEBUG_OPTS%

rem "for machines with 2GB RAM"
rem set CATALINA_OPTS=-Xmx1152m -XX:MaxNewSize=576m -XX:NewSize=288m -XX:MaxPermSize=128m %DEBUG_OPTS%

rem "for machines with 3GB RAM"
rem set CATALINA_OPTS=-Xmx1536m -XX:MaxNewSize=768m -XX:NewSize=384m -XX:MaxPermSize=128m %DEBUG_OPTS%

echo *** 
echo *** Starting DesInventar server
if (%DO_DEBUG%)==(NO) echo ***   Remote debugging not enabled
if (%DO_DEBUG%)==(NO) goto AfterDebugEcho

echo ***   Debug enabled with options:
echo ***   debugger port:  %DEBUG_PORT%

echo ***     will use JRE in %JAVA_HOME%





:AfterDebugEcho

set JAVA=%JAVA_HOME%\bin\java.exe 
SET  JAVA_CLASSPATH=.;%CATALINA_HOME%\bin\bootstrap.jar;%JAVA_HOME%\lib\tools.jar 


@echo on 

%JAVA% %JAVA_PARAMS% -classpath "%JAVA_CLASSPATH%" -Dcatalina.home="%CATALINA_HOME%" -Djava.endorsed.dirs=%CATALINA_HOME%\common\endorsed -Djava.io.tmpdir=%CATALINA_HOME%\temp org.apache.catalina.startup.Bootstrap stop %2 %3 %4 %5 %6 %7 %8 %9 

@echo off 
goto Exit

:ErrNoJavaHome
echo ***
echo *** ERROR: Java home does not exist: %JAVA_HOME%
goto ShowUsage

:ErrNoCatalinaBin
echo ***
echo *** ERROR: No Tomcat bin directory was found at %CATALINA_BIN%
echo ***        Did you forget to run devtool to fetch the CRN tarballs?
goto Exit

:Exit
cd %CURR_DIR%
if "%ERRORLEVEL%"=="1" pause 
endlocal



