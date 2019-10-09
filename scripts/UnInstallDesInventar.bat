rem ********************************************************************************* 
rem * This script installs DesInventar Server Service in windows and starts it      * 
rem *********************************************************************************
@echo off 
setlocal 

set CURR_DIR=%CD%

echo ***     Removing DesInventar Service

sc stop DesInventar
sc Delete DesInventar


del /Q /S "Server\*.*"

endlocal




